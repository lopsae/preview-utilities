//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


@MainActor @Observable
public class ImageGeneratorStore {

    let generator: any ImageGeneratorProtocol

    public private(set) var status: [String: GenerationStatus] = [:]
    public private(set) var images: [String: Image] = [:]


    // TODO: make init that only receives size and uses isolateedImageGenerator
    public init(size: CGSize, generator: (any ImageGeneratorProtocol)? = nil) {
        if let generator {
            self.generator = generator
        } else {
            self.generator = ConcurrentImageGenerator(size: size)
        }
    }


    public var size: CGSize { generator.size }


    @concurrent @discardableResult
    public func generateImage(with text: String) async -> Image {
        if let image = await images[text] {
            return image
        }
        let requestThreadInfo = ThreadInfo()
        await markAsRequested(text: text, threadInfo: requestThreadInfo)

        let generateTuple = await generator.generateImage(with: text)

        let storageThreadInfo = ThreadInfo()
        await storeImage(
            generateTuple.image, text: text,
            threadInfo: storageThreadInfo,
            requestThreadInfo: requestThreadInfo,
            generationThreadInfo: generateTuple.threadInfo
        )

        return generateTuple.image
    }


    private func markAsRequested(text: String, threadInfo: ThreadInfo) {
        status[text] = .requested(threadInfo: threadInfo)
    }


    private func storeImage(
        _ image: Image,
        text: String,
        threadInfo: ThreadInfo,
        requestThreadInfo: ThreadInfo,
        generationThreadInfo: ThreadInfo
    ) {
        images[text] = image
        status[text] = .stored(
            threadInfo: threadInfo,
            requestThreadInfo: requestThreadInfo,
            generationThreadInfo: generationThreadInfo)
    }


    public enum GenerationStatus {

        case requested(threadInfo: ThreadInfo)
        case stored(threadInfo: ThreadInfo, requestThreadInfo: ThreadInfo, generationThreadInfo: ThreadInfo)

        public var statusColor: Color {
            switch self {
            case .requested: .orange
            case .stored:    .green
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
            }
        }

    }

}


#Preview("Storage", traits: .fixedHeader) {
    @Previewable @State var items: [String] = ["One", "Two", "Three", "Four"]
    @Previewable @State var imageGenerator = ImageGeneratorStore(size: .init(square: 100))

    VStack {
        ForEach(items.enumerated(), id: \.offset) { index, item in
            Group {
                if let image = imageGenerator.images[item] {
                    image.resizable()
                } else {
                    Rectangle().fill(.secondary)
                }
            }
            .frame(size: imageGenerator.size)
            .roundedRectangleClip(cornerRadius: 8)
            .task {
                await imageGenerator.generateImage(with: item)
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
                        .frame(square: 12)

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
