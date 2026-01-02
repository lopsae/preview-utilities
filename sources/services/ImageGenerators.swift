//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import CryptoKit
import SwiftUI


public protocol ImageGeneratorProtocol: Sendable, Identifiable {

    var id: UUID { get }
    var size: CGSize { get }

    func generateImage(with text: String) async -> (image: Image, threadInfo: ThreadInfo)

}


nonisolated enum ImageGeneratorDefaults {

    static let sleepRange: ClosedRange<Duration> = .seconds(2) ... .seconds(5)

}


// TODO: add some tests for the following cases:
// + nonisolated class with async function running in inherited main and background threads
// + default isolated class with async function running in default main and concurrent threads, called from main and background threads
// TODO: createa DefaultIsolationImageGenerator which function runs on the default isolation, to see of that makes visible changes to the defaultIsolation setting.


// MARK: - ConcurrentImageGenerator


/// Nonisolated ImageGenerator with a `@concurrent generateImage` function that will always be
/// called in the cooperative thread pool.
nonisolated final class ConcurrentImageGenerator: ImageGeneratorProtocol, Sendable {

    let id: UUID = UUID()

    let size: CGSize
    let sleepRange: ClosedRange<Duration>

    init(size: CGSize, sleepRange: ClosedRange<Duration> = ImageGeneratorDefaults.sleepRange) {
        self.size = size
        self.sleepRange = sleepRange
    }


    /// Generates an image concurrently, this function always runs in the cooperative thread pool.
    ///
    /// This function must use `@concurrent` to use the cooperative thread pool.
    ///
    /// Replacing `@concurrent` with `nonisolated` will cause this function to inherit the isolation
    /// context of the caller, since the package uses the `NonisolatedNonsendingByDefault` upcoming
    /// feature.
    @concurrent
    func generateImage(with text: String) async -> (image: Image, threadInfo: ThreadInfo) {
        return await ImageGeneratorUtils.generateImage(text: text, size: size, sleepRange: sleepRange)
    }

}


// MARK: - NonisolatedImageGenerator


/// Nonisolated ImageGenerator with a `nonisolated generateImage` function that will inherit the
/// isolation context of the caller.
nonisolated final class NonisolatedImageGenerator: ImageGeneratorProtocol, Sendable {

    let id: UUID = UUID()

    let size: CGSize
    let sleepRange: ClosedRange<Duration>

    init(size: CGSize, sleepRange: ClosedRange<Duration> = ImageGeneratorDefaults.sleepRange) {
        self.size = size
        self.sleepRange = sleepRange
    }


    /// Generates an image asyncronously, this function inherits the isolation context of the
    /// caller.
    ///
    /// This function must use `nonisolated` to inherit the caller isolation context. The package
    /// uses the `NonisolatedNonsendingByDefault` upcoming feature.
    ///
    /// Removing `nonisolated` will cause this function to run in the package default isolation
    /// context when run from a detached task. Otherwise, when run from a regular `Task`, it will
    /// inherit the callers context; it is unclear why this happens.
    nonisolated
    func generateImage(with text: String) async -> (image: Image, threadInfo: ThreadInfo) {
        return await ImageGeneratorUtils.generateImage(text: text, size: size, sleepRange: sleepRange)
    }

}


// MARK: - DefaultIsolationImageGenerator


/// Nonisolated ImageGenerator with a `generateImage` without `nonisolated` using the package's
/// default isolation context, which is configured to MainActor isolation.
nonisolated final class DefaultIsolationImageGenerator: ImageGeneratorProtocol, Sendable {

    let id: UUID = UUID()

    let size: CGSize
    let sleepRange: ClosedRange<Duration>

    init(size: CGSize, sleepRange: ClosedRange<Duration> = ImageGeneratorDefaults.sleepRange) {
        self.size = size
        self.sleepRange = sleepRange
    }


    /// Generates an image asyncronously, this function uses the package's default isolation, which
    /// is configured to MainActor isolation.
    ///
    /// This function must NOT use `nonisolated` to use the package's default isolation.
    ///
    /// Adding `nonisolated` will cause this function to inherit the isolation from the caller
    /// isolation context.
    func generateImage(with text: String) async -> (image: Image, threadInfo: ThreadInfo) {
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
    // FIXME: threadnumber should be an int, or could be threadInfo
    async -> (image: Image, threadInfo: ThreadInfo) {
        // Simulate async work.
        if let sleepRange {
            let sleepDuration = sleepRange.randomDuration()
            // TODO: if canceled an additional status could be recorded
            try? await Task.sleep(for: sleepDuration)
        }

        let threadInfo = ThreadInfo()
        let components = colorComponentsFromString(text)

        let image = buildImage(text: text, size: size, caption: threadInfo.displayName, components: components)
        return (image: image, threadInfo: threadInfo)
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


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iphoneSize

}


#Preview("Concurrent", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var usesMainActor: Bool = true
    @Previewable @State var images: [(text: String, image: Image?)] = [
        ("One",   nil),
        ("Two",   nil),
        ("Three", nil),
        ("Four",  nil),
        ("Five",  nil)
    ]
    @Previewable @State var imageGenerator = ConcurrentImageGenerator(
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
                let imageTask = if usesMainActor {
                    // Called from inherited the MainActor isolation.
                    Task {
                        await imageGenerator.generateImage(with: tuple.text)
                    }
                } else {
                    // Called using cooperative thread pool.
                    Task.detached {
                        await imageGenerator.generateImage(with: tuple.text)
                    }
                }
                let image = await imageTask.value.image
                images[index].image = image //mutableTuple
            }
            .id(imageGenerator.id.hash(with: index))
        }
    } // VStack
    .onChange(of: usesMainActor) {
        // Reset image generator and stored images.
        imageGenerator = ConcurrentImageGenerator(
            size: imageGenerator.size,
            sleepRange: imageGenerator.sleepRange
        )
        images = images.map { text, image in
            (text, nil)
        }
    }

    Toggle("Call from Main Actor", isOn: $usesMainActor)
        .padding()
}


#Preview("Nonisolated", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var usesMainActor: Bool = true
    @Previewable @State var images: [(text: String, image: Image?)] = [
        ("Uno",    nil),
        ("Dos",    nil),
        ("Tres",   nil),
        ("Cuatro", nil),
        ("Cinco",  nil)
    ]
    @Previewable @State var imageGenerator = NonisolatedImageGenerator(
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
                let imageTask = if usesMainActor {
                    // Called from inherited the MainActor isolation.
                    Task {
                        await imageGenerator.generateImage(with: tuple.text)
                    }
                } else {
                    // Called using cooperative thread pool.
                    Task.detached {
                        await imageGenerator.generateImage(with: tuple.text)
                    }
                }
                let image = await imageTask.value.image
                images[index].image = image //mutableTuple
            }
            .id(imageGenerator.id.hash(with: index))
        }
    } // VStack
    .onChange(of: usesMainActor) {
        // Reset image generator and stored images.
        imageGenerator = NonisolatedImageGenerator(
            size: imageGenerator.size,
            sleepRange: imageGenerator.sleepRange
        )
        images = images.map { text, image in
            (text, nil)
        }
    }

    Toggle("Call from Main Actor", isOn: $usesMainActor)
        .padding()
}


#Preview("Default Isolation", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var usesMainActor: Bool = true
    @Previewable @State var images: [(text: String, image: Image?)] = [
        ("Un",     nil),
        ("Deux",   nil),
        ("Trois",  nil),
        ("Quatre", nil),
        ("Cinq",   nil)
    ]
    @Previewable @State var imageGenerator = DefaultIsolationImageGenerator(
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
                let imageTask = if usesMainActor {
                    // Called from inherited the MainActor isolation.
                    Task {
                        await imageGenerator.generateImage(with: tuple.text)
                    }
                } else {
                    // Called using cooperative thread pool.
                    Task.detached {
                        print("Generating in \(ThreadInfo().displayName)")
                        return await imageGenerator.generateImage(with: tuple.text)
                    }
                }
                let image = await imageTask.value.image
                images[index].image = image //mutableTuple
            }
            .id(imageGenerator.id.hash(with: index))
        }
    } // VStack
    .onChange(of: usesMainActor) {
        // Reset image generator and stored images.
        imageGenerator = DefaultIsolationImageGenerator(
            size: imageGenerator.size,
            sleepRange: imageGenerator.sleepRange
        )
        images = images.map { text, image in
            (text, nil)
        }
    }

    Toggle("Call from Main Actor", isOn: $usesMainActor)
        .padding()
}
