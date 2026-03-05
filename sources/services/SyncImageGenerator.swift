//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import CryptoKit
import SwiftUI


struct SyncImageGenerator {

    /// Size of the generated images.
    let size: CGSize

    /// Synchronosly generates an image with a given strings.
    ///
    /// Images generated with the same `text` always have the same background color.
    func generateImage(with text: String, caption: String? = nil) -> Image {
        return Self.generateImage(with: text, caption: caption, size: size)
    }


    static func generateImage(with text: String, caption: String? = nil, size: CGSize) -> Image {
        let components = colorComponentsFromString(text)
        let image = Self.buildImage(text: text, size: size, caption: caption, components: components)
        return image
    }


    // TODO: test also in mac
    #if canImport(AppKit)
    private static func buildImage(text: String, size: CGSize, caption: String? = nil, components: ColorComponents) -> Image {
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
    static func buildImage(text: String, size: CGSize, caption: String? = nil, components: ColorComponents) -> Image {
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


    /// Draws the given strings. This function is expected to be called within a call to
    /// `UIGraphicsImageRenderer/image`.
    private static func drawStrings(text: String, size: CGSize, caption: String? = nil) {
        #if canImport(AppKit)
        typealias PlatformFont = NSFont
        typealias PlatformColor = NSColor
        #elseif canImport(UIKit)
        typealias PlatformFont = UIFont
        typealias PlatformColor = UIColor
        #endif

        // Text string.
        let textAttrString = NSAttributedString(string: text, attributes: [
            .font: PlatformFont.preferredFont(forTextStyle: .headline),
            .foregroundColor: PlatformColor.white,
            .paragraphStyle: NSParagraphStyle.make {
                $0.alignment = .center
            }
        ])
        let textSize = textAttrString.size()
        let textRect = textSize.centered(in: size)
        textAttrString.draw(in: textRect)


        // Caption string.
        guard let caption else { return }

        let captionAttrString = NSAttributedString(string: caption, attributes: [
            .font:  PlatformFont.preferredFont(forTextStyle: .caption1),
            .foregroundColor: PlatformColor.white,
            .paragraphStyle: NSParagraphStyle.make {
                $0.alignment = .center
            }
        ])
        let captionSize = captionAttrString.size()
        var captionRect = captionSize.centered(in: size)
        let captionSpacing: CGFloat = .zero
        captionRect.origin.y = textRect.maxY + captionSpacing

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
        else { return .zero }

        let hashed: SHA256Digest = SHA256.hash(data: inputData)
        let intValue: Int = hashed.reduce(0) { partialResult, int8 in
            partialResult + Int(int8)
        }

        return intValue
    }

}


extension SyncImageGenerator {

    struct ColorComponents/*: Sendable*/ {
        let hue: CGFloat
        let saturation: CGFloat
        let brightness: CGFloat
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable let imageGenerator = SyncImageGenerator(size: .square(of: 100))
    let strings = ["One", "Two", "Three"]

    ForEach(strings, id: \.self) { string in
        imageGenerator.generateImage(with: string)
    }
}


#Preview("Static", traits: .fixedHeader, PreviewContent.layout) {
    SyncImageGenerator.generateImage(
        with: "200", caption: "Large",
        size: .square(of: 200))
    SyncImageGenerator.generateImage(
        with: "100", caption: "Regular",
        size: .square(of: 100))
    SyncImageGenerator.generateImage(
        with: "50", caption: "Small",
        size: .square(of: 50))
}
