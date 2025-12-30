//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import CryptoKit
import SwiftUI


public protocol ImageGeneratorProtocol: Sendable {
    var size: CGSize { get }
    func generateImage(with text: String) async -> (image: Image, threadNumber: String)
}

// TODO: add some tests for the following cases:
// + nonisolated class with async function running in inherited main and background threads
// + default isolated class with async function running in default main and concurrent threads, called from main and background threads
// TODO: createa DefaultIsolationImageGenerator which function runs on the default isolation, to see of that makes visible changes to the defaultIsolation setting.


// MARK: - ImageGenerator


// Package settings use the MainActor default isolation. `nonisolated` is necessary to allow
// functions in this class to run in the cooperative thread pool.
nonisolated final class ImageGenerator: ImageGeneratorProtocol, Sendable {

    let size: CGSize
    let sleepRange: ClosedRange<Duration>

    init(size: CGSize, sleepRange: ClosedRange<Duration> = .seconds(2) ... .seconds(5)) {
        self.size = size
        self.sleepRange = sleepRange
    }


    // Package settings use the `NonisolatedNonsendingByDefault` upcoming feature, in which async
    // functions by default will use the actor where it is called. Use `@concurrent` to use the
    // thread pool.
    @concurrent
    func generateImage(with text: String) async -> (image: Image, threadNumber: String) {
        return await ImageGeneratorUtils.generateImage(text: text, size: size, sleepRange: sleepRange)
    }

}


// MARK: - DefaultIsolationImageGenerator


/// Image generator that uses the package's default isolation context, which is configured to
/// MainActor isolation. When called even from a background thread, the image generation will
/// always happens in the main thread.
///
/// If the package default isolation setting is changed to non-isolated, and assuming
/// `NonisolatedNonsendingByDefault` is also enabled, the image generation will occurr in the
/// isolation contect where `generateImage` is called.
final class DefaultIsolationImageGenerator: /*ImageGeneratorProtocol,*/ Sendable {

    let size: CGSize
    let sleepRange: ClosedRange<Duration>

    init(size: CGSize, sleepRange: ClosedRange<Duration> = .seconds(2) ... .seconds(5)) {
        self.size = size
        self.sleepRange = sleepRange
    }

    func generateImage(with text: String) async -> (image: Image, threadNumber: String) {
        return await ImageGeneratorUtils.generateImage(text: text, size: size, sleepRange: sleepRange)
    }

}


// MARK: - ImageGeneratorUtils


/// Collection of static non-isolated-non-sending functions to be used by image generators from any
/// isolation context. 
nonisolated final class ImageGeneratorUtils {

    /// Generates an image using the callers isolation context, optionally sleeps for a random
    /// duration within the given duration range.
    ///
    /// - Note:
    /// The package settings enable `NonisolatedNonsendingByDefault`, irregardless this function is
    /// marked `nonisolated(nonsending)` for explicitness.
    nonisolated(nonsending)
    static func generateImage(text: String, size: CGSize, sleepRange: ClosedRange<Duration>?)
    async -> (image: Image, threadNumber: String) {
        // Simulate async work.
        if let sleepRange {
            let sleepDuration = sleepRange.randomDuration()
            // TODO: if canceled an additional status could be recorded
            try? await Task.sleep(for: sleepDuration)
        }

        let threadName = ThreadInfo.currentDisplayName()
        let threadNumber = ThreadInfo.currentDisplayNumber()
        let components = colorComponentsFromString(text)

        let image = buildImage(text: text, size: size, caption: threadName, components: components)
        return (image: image, threadNumber: threadNumber)
    }


    #if canImport(AppKit)
    private static func buildImage(text: String, size: CGSize, caption: String, components: ColorComponents) -> Image {
        let nsImage = NSImage(size: size, flipped: true) { nsRect in
            // Background.
            let backgroundColor = NSColor(
                hue: components.hue,
                saturation: components.saturation,
                brightness: components.brightness,
                alpha: 1.0)
            backgroundColor.setFill()
            nsRect.fill()

            // Shadow.
            let shadow = NSShadow()
            shadow.shadowOffset = CGSize(width: 1, height: -3)
            shadow.shadowBlurRadius = 3
            shadow.shadowColor = NSColor.black.withAlphaComponent(0.5)
            shadow.set()

            self.drawStrings(text: text, size: size, caption: caption)
            return true
        }

        return Image(nsImage: nsImage)
    }
    #endif


    #if canImport(UIKit)
    private static func buildImage(text: String, size: CGSize, caption: String, components: ColorComponents) -> Image {
        let format = UIGraphicsImageRendererFormat()
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let uiImage = renderer.image { context in
            // Background.
            let backgroundColor = UIColor(
                hue: components.hue,
                saturation: components.saturation,
                brightness: components.brightness,
                alpha: 1.0)
            backgroundColor.setFill()
            context.fill(size.rect())

            let cgContext = context.cgContext

            // Shadow.
            cgContext.setShadow(
                offset: CGSize(width: 1, height: 3),
                blur: 3,
                color: UIColor.black.withAlphaComponent(0.5).cgColor
            )

            drawStrings(text: text, size: size, caption: caption)
        }

        return Image(uiImage: uiImage)
    }
    #endif


    private static func drawStrings(text: String, size: CGSize, caption: String) {
        #if canImport(AppKit)
        typealias PlatformFont = NSFont
        typealias PlatformColor = NSColor
        #elseif canImport(UIKit)
        typealias PlatformFont = UIFont
        typealias PlatformColor = UIColor
        #endif

        let textAttrString = NSAttributedString(string: text, attributes: [
            .font: PlatformFont.preferredFont(forTextStyle: .headline),
            .foregroundColor: PlatformColor.white,
            .paragraphStyle: NSParagraphStyle.make {
                $0.alignment = .center
            }
        ])
        let textSize = textAttrString.size()
        let textRect = textSize.centered(in: size)

        let captionAttrString = NSAttributedString(string: caption, attributes: [
            .font:  PlatformFont.preferredFont(forTextStyle: .caption1),
            .foregroundColor: PlatformColor.white,
            .paragraphStyle: NSParagraphStyle.make {
                $0.alignment = .center
            }
        ])
        let captionSize = captionAttrString.size()
        var captionRect = captionSize.centered(in: size)
        captionRect.origin.y = textRect.maxY + 0

        textAttrString.draw(in: textRect)
        captionAttrString.draw(in: captionRect)
    }


    /// Generates deterministic color components for the given `string`.
    private static func colorComponentsFromString(_ string: String) -> ColorComponents {
        let hash = persistentHash(for: string)

        let hue: Double = (hash % 360).asDouble / 360.0
        // In the range: 0.6 - 1.0.
        let saturation: Double = 0.6 + (hash % 40).asDouble / 100.0
        // In the range: 0.5 - 0.8.
        let brightness: Double = 0.5 + (hash % 30).asDouble / 100.0

        return .init(hue: hue, saturation: saturation, brightness: brightness)
    }


    private static func persistentHash(for input: String) -> Int {
        guard let inputData = input.data(using: .utf8)
        else { return 0 }

        let hashed: SHA256Digest = SHA256.hash(data: inputData)
        let intValue: Int = hashed.reduce(0) { partialResult, int8 in
            partialResult + Int(int8)
        }

        return intValue
    }

}


private struct ColorComponents: Sendable {
    let hue: CGFloat
    let saturation: CGFloat
    let brightness: CGFloat
}


// MARK: - Previews


private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iphoneSize

}


#Preview("Generator", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var images: [(text: String, image: Image?)] = [
        ("One",   nil),
        ("Two",   nil),
        ("Three", nil),
        ("Four",  nil),
        ("Five",  nil)
    ]

    let imageGenerator = ImageGenerator(
        size: .init(square: 100),
        sleepRange: .seconds(0.5) ... .seconds(1)
    )

    VStack {
        ForEach(images.enumerated(), id: \.offset) { index, tuple in
            Group {
                if let image = tuple.image {
                    image.resizable()
                } else {
                    Rectangle().fill(.secondary)
                }
            }
            .frame(size: imageGenerator.size)
            .roundedRectangleClip(cornerRadius: 8)
            .task {
                // ImageGenerator is called here from the MainActor isolation.
                let image = await imageGenerator.generateImage(with: tuple.text).image
                var mutableTuple = tuple
                mutableTuple.image = image
                images[index] = mutableTuple
            }
        }
    } // VStack
}


#Preview("Default Isolation", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var images: [(text: String, image: Image?)] = [
        ("Un",     nil),
        ("Deux",   nil),
        ("Trois",  nil),
        ("Quatre", nil),
        ("Cinq",   nil)
    ]

    let imageGenerator = DefaultIsolationImageGenerator(
        size: .init(square: 100),
        sleepRange: .seconds(0.5) ... .seconds(1)
    )

    VStack {
        ForEach(images.enumerated(), id: \.offset) { index, tuple in
            Group {
                if let image = tuple.image {
                    image.resizable()
                } else {
                    Rectangle().fill(.secondary)
                }
            }
            .frame(size: imageGenerator.size)
            .roundedRectangleClip(cornerRadius: 8)
            .task {
                let imageTask = Task.detached {
                    // ImageGenerator is called here outside of MainActor isolation.
                    await imageGenerator.generateImage(with: tuple.text).image
                }
                let image = await imageTask.value

                var mutableTuple = tuple
                mutableTuple.image = image
                images[index] = mutableTuple
            }
        }
    } // VStack
}
