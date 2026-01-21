//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


@MainActor @Observable
public class ImageGeneratorStore<Generator: ImageGeneratorProtocol> {

    public typealias ImageTask = Task<Image?, Never>

    let generator: Generator

    public private(set) var status: [String: GenerationStatus] = [:]
    public private(set) var tasks:  [String: ImageTask] = [:]
    public private(set) var images: [String: Image] = [:]


    public init(generator: Generator) {
        self.generator = generator
    }


    public convenience init(size: CGSize) where Generator == ConcurrentImageGenerator {
        self.init(generator: ConcurrentImageGenerator(size: size))
    }


    public var size: CGSize { generator.size }


    @concurrent @discardableResult
    public func generateImage(with text: String) async -> Image? {
        // The point of truth for an image generation success is if it is alredy stored.
        // There is a chance that a generation task is cancelled, but it still finishes storing
        // the image.
        if let image = await images[text] {
            return image
        }

        // Task needs to be created in the storage isolation, so that only one task per text exists.
        let requestThreadInfo = ThreadInfo()
        let task = await retrieveOrGenerateTask(for: text, requestThreadInfo: requestThreadInfo)
        
        // Propagate task cancelation into the generationTask.
        return await withTaskCancellationHandler {
            await task.value
        } onCancel: {
            // There is a chance this tasks gets cancelled multiple times, or after the task has
            // finished generation and is awaiting to store the image. In that case the stored task
            // may show as cancelled, but the image will be stored. This is considered valid.
            task.cancel()
        }
    }


    private func retrieveOrGenerateTask(for text: String, requestThreadInfo: ThreadInfo) -> ImageTask {
        if let existingTask = tasks[text], !existingTask.isCancelled {
            return existingTask
        }

        let task = Task { @concurrent in
            let generateTuple = await generator.generateImage(with: text)

            let storageThreadInfo = ThreadInfo()

            // TODO: allow generateImage to throw a cancelable error.
            if let image = generateTuple.image {
                await storeImage(
                    image, text: text,
                    storageThreadInfo: storageThreadInfo,
                    requestThreadInfo: requestThreadInfo,
                    generationThreadInfo: generateTuple.threadInfo)
            } else {
                // Image generation was cancelled.
                await storeImageCancelation(
                    text: text,
                    requestThreadInfo: requestThreadInfo,
                    cancelationThreadInfo: generateTuple.threadInfo)
            }

            return generateTuple.image
        }

        tasks[text] = task
        status[text] = .requested(threadInfo: requestThreadInfo)
        return task
    }


    private func storeImage(
        _ image: Image,
        text: String,
        storageThreadInfo: ThreadInfo,
        requestThreadInfo: ThreadInfo,
        generationThreadInfo: ThreadInfo
    ) {
        images[text] = image
        status[text] = .stored(
            threadInfo: storageThreadInfo,
            requestThreadInfo: requestThreadInfo,
            generationThreadInfo: generationThreadInfo)
    }


    private func storeImageCancelation(
        text: String,
        requestThreadInfo: ThreadInfo,
        cancelationThreadInfo: ThreadInfo
    ) {
        status[text] = .cancelled(
            threadInfo: cancelationThreadInfo,
            requestThreadInfo: requestThreadInfo)
    }


    public enum GenerationStatus {

        case requested(threadInfo: ThreadInfo)
        case stored(threadInfo: ThreadInfo, requestThreadInfo: ThreadInfo, generationThreadInfo: ThreadInfo)
        case cancelled(threadInfo: ThreadInfo, requestThreadInfo: ThreadInfo)

        public var statusColor: Color {
            switch self {
            case .requested: .orange
            case .stored:    .green
            case .cancelled: .red
            }
        }

        public var statusText: String {
            switch self {
            case let .requested(threadInfo):
                "Requested in \(threadInfo.number?.description ?? "nil")"
            case let .stored(
                threadInfo,
                requestThreadInfo: requestThreadInfo,
                generationThreadInfo: generationThreadInfo
            ):
                "Stored in \(nilDefault: threadInfo.number) ← gen:\(nilDefault: generationThreadInfo.number) ← req:\(nilDefault: requestThreadInfo.number)"
            case let .cancelled(threadInfo, requestThreadInfo):
                "Cancelled in \(nilDefault: threadInfo.number) ← req:\(nilDefault: requestThreadInfo.number)"
            }
        }


        public var compactStatusText: String {
            switch self {
            case let .requested(threadInfo):
                "req:\(nilDefault: threadInfo.number)"
            case let .stored(
                threadInfo,
                requestThreadInfo: requestThreadInfo,
                generationThreadInfo: generationThreadInfo
            ):
                "s:\(nilDefault: threadInfo.number) ← g:\(nilDefault: generationThreadInfo.number) ← r:\(nilDefault: requestThreadInfo.number)"
            case let .cancelled(threadInfo, requestThreadInfo):
                "c:\(nilDefault: threadInfo.number) ← r:\(nilDefault: requestThreadInfo.number)"
            }
        }


        public var minimalStatusText: String {
            switch self {
            case let .requested(threadInfo):
                "\(threadInfo.number, default: "?")"
            case let .stored(
                threadInfo,
                requestThreadInfo: requestThreadInfo,
                generationThreadInfo: generationThreadInfo
            ):
                "\(threadInfo.number, default: "?"):\(generationThreadInfo.number, default: "?"):\(requestThreadInfo.number, default: "?")"
            case let .cancelled(threadInfo, requestThreadInfo):
                "x:\(threadInfo.number, default: "?"):\(requestThreadInfo.number, default: "?")"
            }
        }

    }

}


#Preview("Storage", traits: .fixedHeader) {
    @Previewable @State var tasks: [String: Task<Void, Never>] = [:]
    @Previewable @State var imageGenerator = ImageGeneratorStore(
        generator: ConcurrentImageGenerator(
            size: .square(of: 100),
            sleepRange: .seconds(5) ... .seconds(7)
        )
    )

    let items: [String] = ["One", "Two", "Three", "Four"]

    VStack {
        ForEach(items.enumerated(), id: \.offset) { index, item in
            HStack {
                Group {
                    if let image = imageGenerator.images[item] {
                        image.resizable()
                    } else {
                        Rectangle().fill(.secondary)
                    }
                }
                .frame(size: imageGenerator.size)
                .roundedRectangleClip(cornerRadius: 8)

                if imageGenerator.images[item] == nil {
                    Group {
                        if let task = tasks[item] {
                            Button("Cancel", systemImage: "xmark") {
                                guard !task.isCancelled else { return }
                                task.cancel()
                                tasks[item] = nil
                            }
                            .tint(.red)
                        } else {
                            Button("Restart", systemImage: "arrow.clockwise") {
                                let task = Task {
                                    _ = await imageGenerator.generateImage(with: item)
                                }
                                tasks[item] = task
                            }
                            .tint(.green)
                        }
                    }
                    .labelStyle(.iconOnly)
                    .buttonBorderShape(.circle)
                    .buttonStyle(.borderedProminent)
                }
            }
            .onAppear {
                let task = Task {
                    _ = await imageGenerator.generateImage(with: item)
                }
                tasks[item] = task
            }
        }
    } // VStack
    .padding(.bottom)

    Divider()

    Grid(alignment: .leading) {
        GridRow {
            Text("Item").bold()
            Text("Status").bold()
        }

        Divider()
            .gridCellUnsizedAxes(.horizontal)

        ForEach(items, id: \.self) { item in
            let generationStatus = imageGenerator.status[item]
            GridRow {
                Text(item)
                    .font(.body)

                HStack(spacing: 8) {
                    Circle()
                        .fill(generationStatus?.statusColor ?? .gray)
                        .frame(squareOf: 12)

                    Text(generationStatus?.statusText ?? "Idle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .maxWidthFrame(alignment: .leading)
                }
            }
        }
    } // Grid
    .maxWidthFrame()
    .padding()
}
