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
        let requestThreadNumber = ThreadInfo.currentDisplayNumber()
        await markAsRequested(text: text, threadName: requestThreadNumber)

        let storageThreadNumber = ThreadInfo.currentDisplayNumber()
        let generateTuple = await generator.generateImage(with: text)
        await storeImage(
            generateTuple.image, text: text,
            threadName: storageThreadNumber,
            requestThreadName: requestThreadNumber,
            generationThreadName: generateTuple.threadNumber
        )

        return generateTuple.image
    }


    private func markAsRequested(text: String, threadName: String) {
        status[text] = .requested(threadName: threadName)
    }


    private func storeImage(
        _ image: Image,
        text: String,
        threadName: String,
        requestThreadName: String,
        generationThreadName: String
    ) {
        images[text] = image
        status[text] = .stored(
            threadName: threadName,
            requestThreadName: requestThreadName,
            generationThreadName: generationThreadName)
    }


    public enum GenerationStatus {

        case requested(threadName: String)
        case stored(threadName: String, requestThreadName: String, generationThreadName: String)

        public var statusColor: Color {
            switch self {
            case .requested: .orange
            case .stored:    .green
            }
        }

        public var statusText: String {
            switch self {
            case let .requested(threadName):
                "Requested in \(threadName)"
            case let .stored(
                threadName,
                requestThreadName: requestThreadName,
                generationThreadName: generationThreadName
            ):
                "Stored in \(threadName) ← gen:\(generationThreadName) ← req:\(requestThreadName)"
            }
        }


        public var compactStatusText: String {
            switch self {
            case let .requested(threadName):
                "req:\(threadName)"
            case let .stored(
                threadName,
                requestThreadName: requestThreadName,
                generationThreadName: generationThreadName
            ):
                "s:\(threadName) ← g:\(generationThreadName) ← r:\(requestThreadName)"
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
