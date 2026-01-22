//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


@MainActor @Observable
public class ImageGeneratorStore<Generator: ImageGeneratorProtocol> {

    public typealias ImageTask = Task<Image?, Never>

    let generator: Generator

    /// Stores the current status of the image generation for each text.
    public private(set) var status: [String: GenerationStatus] = [:]

    /// Stores the internal task generating the image.
    ///
    /// Only one task per text is kept at any time. This task can be cancelled both directly or
    /// through the cancelation of the task context calling ``generateImage(with:)``.
    /// Since cancelation can happen even after the image generation is done, it is possible to have
    /// a cancelled task for an image that has successfully generated and stored. The
    /// source-of-truth for the success of an image generation is if the image exists in ``images``.
    public private(set) var tasks:  [String: ImageTask] = [:]

    /// Stores the generated images for each text.
    public private(set) var images: [String: Image] = [:]


    public init(generator: Generator) {
        self.generator = generator
    }


    public convenience init(size: CGSize) where Generator == ConcurrentImageGenerator {
        self.init(generator: ConcurrentImageGenerator(size: size))
    }


    public var size: CGSize { generator.size }


    @discardableResult
    /// Syncronously returns an image if it has already been generated or stored. Otherwise starts
    /// or restarts the internal image generation task and returns `nil`.
    public func startGeneration(with text: String) -> Image? {
        if let image = images[text] {
            return image
        }
        retrieveOrGenerateTask(for: text, requestThreadInfo: ThreadInfo())
        return nil
    }


    // TODO: could also throw a cancelation error.
    @concurrent @discardableResult
    /// Asyncronously generates and returns an image. If the image is already generated and stored
    /// it will be returned immediately. Otherwise, starts or restarts the internal image generation
    /// task.
    ///
    /// When called from a task context, this function will detect task cancelation and will cancel
    /// the internal image generation task and return nil. Since internally only a single image
    /// generation task is kept for each text, cancelling the task will impact every other image
    /// request by returning `nil`.
    public func generateImage(with text: String) async -> Image? {
        if let image = await images[text] {
            return image
        }

        // Task needs to be created in the class own isolation, so that only one task per text exists.
        let requestThreadInfo = ThreadInfo()
        let task = await retrieveOrGenerateTask(for: text, requestThreadInfo: requestThreadInfo)

        // Propagate task cancelation into the generationTask.
        return await withTaskCancellationHandler {
            await task.value
        } onCancel: {
            task.cancel()
        }
    }


    @discardableResult
    private func retrieveOrGenerateTask(for text: String, requestThreadInfo: ThreadInfo) -> ImageTask {
        if let existingTask = tasks[text], !existingTask.isCancelled {
            return existingTask
        }

        let task = Task<Image?, Never>.init { @concurrent in
            let generationTuple: ImageGeneratorProtocol.GenerationTuple
            do {
                generationTuple = try await generator.generateImage(with: text)
            } catch ImageGeneratorError.cancelled(let cancelationThreadInfo) {
                await storeImageCancelation(
                    text: text,
                    requestThreadInfo: requestThreadInfo,
                    cancelationThreadInfo: cancelationThreadInfo)
                return nil
            } catch {
                // `generateImage` only throws ImageGeneratorError.
                // `do throws(ImageGeneratorError)` results in a warning...
                fatalError()
            }

            let storageThreadInfo = ThreadInfo()
            await storeImage(
                generationTuple.image, text: text,
                storageThreadInfo: storageThreadInfo,
                requestThreadInfo: requestThreadInfo,
                generationThreadInfo: generationTuple.threadInfo)

            return generationTuple.image
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

}


// MARK: - GenerationStatus


extension ImageGeneratorStore {

    public enum GenerationStatus: IdentifiableCase {

        case requested(threadInfo: ThreadInfo)
        case stored(threadInfo: ThreadInfo, requestThreadInfo: ThreadInfo, generationThreadInfo: ThreadInfo)
        case cancelled(threadInfo: ThreadInfo, requestThreadInfo: ThreadInfo)

        public enum Case: String { case requested, stored, cancelled }
        var `case`: Case {
            switch self {
            case .requested: .requested
            case .stored:    .stored
            case .cancelled: .cancelled
            }
        }

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


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    struct ImageWithButtons: View {
        var image: Image?
        var size: CGSize
        var cancelable: Bool
        var cancelClosure: () -> Void
        var restartClosure: () -> Void

        var body: some View {
            Group {
                if let image {
                    image.resizable()
                } else {
                    Rectangle().fill(.secondary)
                    .overlay {
                        Group {
                            if cancelable {
                                Button("Cancel", systemImage: "xmark", action: cancelClosure)
                                .tint(.red)
                            } else {
                                Button("Restart", systemImage: "arrow.clockwise", action: restartClosure)
                                .tint(.green)
                            }
                        }
                        .labelStyle(.iconOnly)
                        .buttonBorderShape(.circle)
                        .buttonStyle(.borderedProminent)
                    }
                }
            } // Group
            .frame(size: size)
            .roundedRectangleClip(cornerRadius: 8)
        }

    }

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var externalTasks: [String: Task<Void, Never>] = [:]
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
                PreviewContent.ImageWithButtons(
                    image: imageGenerator.images[item],
                    size: imageGenerator.size,
                    cancelable: externalTasks[item] != nil
                ) {
                    if let task = externalTasks[item] {
                        task.cancel()
                        externalTasks[item] = nil
                    }
                } restartClosure: {
                    // Start the external task.
                    let task = Task {
                        _ = await imageGenerator.generateImage(with: item)
                    }
                    externalTasks[item] = task
                }
            } // HStack
            .onAppear {
                // Start the external task.
                let task = Task {
                    _ = await imageGenerator.generateImage(with: item)
                }
                externalTasks[item] = task
            }
        }
    } // VStack

    Divider()

    Grid(alignment: .leading) {
        GridRow {
            Text("Item").bold()
            Text("Status").bold()
            Text("Internal Task").bold()
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
                } // HStack

                switch generationStatus?.case {
                case .requested:
                    Button("Cancel", systemImage: "xmark") {
                        if let task = imageGenerator.tasks[item] {
                            task.cancel()
                        }
                    }
                    .tint(.red)
                case .cancelled:
                    Button("Restart", systemImage: "arrow.clockwise") {
                        imageGenerator.startGeneration(with: item)
                    }
                    .tint(.green)
                case .stored:
                    Label("Done", systemImage: "checkmark")
                        .foregroundStyle(.green)
                case .none:
                    Label("No Task", systemImage: "questionmark")
                }
            } // Grid Row
        }
    } // Grid
    .maxWidthFrame()
}


#Preview("LazyHStack", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .previewStarted
    @Previewable @State var scrollPosition = ScrollPosition()
    @Previewable @State var imageGenerator = ImageGeneratorStore(
        generator: ConcurrentImageGenerator(
            size: .square(of: 100),
            sleepRange: .seconds(5) ... .seconds(7)
        )
    )

    printOnce.print()

    let strings = Strings.natoPhoneticAlphabet

    ScrollView(.horizontal) {
        LazyHStack(spacing: 20) {
            ForEach(strings, id:\.self) { string in
                Group {
                    if let image = imageGenerator.images[string] {
                        image.resizable()
                    } else {
                        Rectangle().fill(.secondary)
                    }
                } // Group
                .frame(size: imageGenerator.size)
                .roundedRectangleClip(cornerRadius: 8)
                .task {
                    print("Generating image: \(string)")
                    await imageGenerator.generateImage(with: string)
                    if Task.isCancelled {
                        print("Task cancelled: \(string)")
                    }
                }

            } // ForEach

        } // LazyHStack
        .scrollTargetLayout()
    } // ScrollView
    .scrollPosition($scrollPosition)
    .frame(height: 120)

    HStack {
        let indices: [Int] = [
            strings.startIndex,
            strings.endIndex * 1/4,
            strings.endIndex * 3/4,
            strings.beforeEndIndex
        ]
        ForEach(indices, id: \.self) { index in
            let string  = strings[index]
            Button(string.formatted(.firstCharacterCapitalized)) {
                withAnimation {
                    scrollPosition.scrollTo(id: string)
                }
            }
            .buttonStyle(.borderedProminent)
            .monospaced()
        }
    } // HStack
    .maxWidthFrame()

    let columns: Int = 3
    LazyVGrid(
        columns: Array(
            repeating: .init(.flexible()),
            count: columns
        ),
        alignment: .leading,
        spacing: 4.0
    ) {

        ForEach(strings.columnMajorReordered(columns: columns), id: \.self) { item in
            let generationStatus = imageGenerator.status[item]
            HStack {
                Text(item.formatted(.firstCharacter(capitalized: true)))
                    .frame(width: 15, alignment: .leading)
                Circle()
                    .fill(generationStatus?.statusColor ?? .gray)
                    .frame(squareOf: 15)

                Text(generationStatus?.minimalStatusText ?? "Idle")
                    .font(.caption.monospaced())
                    .lineLimit(1)
                    .maxWidthFrame(alignment: .leading)
            }
        } // ForEach
    } // LazyVGrid
}
