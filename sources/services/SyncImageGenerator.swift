//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import CryptoKit
import SwiftUI


/// Synchronous image generator. Can be instantiated to produce any number of images of a given
/// size, or used statically to produce the same images.
///
/// This generator only provides synchronous api to run in any isolation context.
nonisolated
public struct SyncImageGenerator {

    #if canImport(AppKit)
    public typealias PlatformImage = NSImage
    #elseif canImport(UIKit)
    public typealias PlatformImage = UIImage
    #endif

    /// Size of the generated images.
    public let size: CGSize

    /// Synchronosly generates an image with a given strings.
    ///
    /// Images generated with the same `text` always have the same background color.
    public func generateImage(
        with text: String,
        caption: String? = nil,
        border: Bool = false
    ) -> Image {
        return Self.generateImage(with: text, caption: caption, size: size, border: border)
    }


    public func generatePlatformImage(
        with text: String,
        caption: String? = nil,
        border: Bool = false
    ) -> PlatformImage {
        return Self.generatePlatformImage(with: text, caption: caption, size: size, border: border)
    }


    public static func generateImage(
        with text: String,
        caption: String? = nil,
        size: CGSize,
        border: Bool = false
    ) -> Image {
        let backgroundComponents = colorComponentsForBackground(text)
        let borderComponents = border ? colorComponentsForBorder(text) : nil
        let platformImage = Self.buildPlatformImage(
            size: size, text: text, caption: caption,
            components: backgroundComponents,
            borderComponents: borderComponents)

        return Image(platformImage: platformImage)
    }


    public static func generatePlatformImage(
        with text: String,
        caption: String? = nil,
        size: CGSize,
        border: Bool = false
    ) -> PlatformImage {
        let backgroundComponents = colorComponentsForBackground(text)
        let borderComponents = border ? colorComponentsForBorder(text) : nil
        let image = Self.buildPlatformImage(
            size: size, text: text, caption: caption,
            components: backgroundComponents,
            borderComponents: borderComponents)
        return image
    }


    #if canImport(AppKit)
    private static func buildPlatformImage(
        size: CGSize,
        text: String,
        caption: String? = nil,
        components: ColorComponents,
        borderComponents: ColorComponents? = nil
    ) -> NSImage {
        let nsImage = NSImage(size: size, flipped: true) { nsRect in
            // Background.
            let backgroundColor = NSColor(
                hue: components.hue,
                saturation: components.saturation,
                brightness: components.brightness,
                alpha: 1.0)
            backgroundColor.setFill()
            nsRect.fill()

            // Border.
            if let borderComponents {
                let strokeColor = NSColor(
                    hue: borderComponents.hue,
                    saturation: borderComponents.saturation,
                    brightness: borderComponents.brightness,
                    alpha: 1.0)
                strokeColor.setStroke()
                let strokeWidth: CGFloat = 5.0
                let borderRect = nsRect.inset(by: strokeWidth / 2)
                let borderPath = NSBezierPath(rect: borderRect)
                borderPath.lineWidth = strokeWidth
                borderPath.stroke()
            }

            // Shadow.
            let shadow = NSShadow()
            shadow.shadowOffset = CGSize(width: 1, height: -3)
            shadow.shadowBlurRadius = 3
            shadow.shadowColor = NSColor.black.withAlphaComponent(0.5)
            shadow.set()

            self.drawStrings(text: text, size: size, caption: caption)
            return true
        }

        return nsImage
    }
    #endif


    #if canImport(UIKit)
    static func buildPlatformImage(
        size: CGSize, text: String, caption: String? = nil,
        components: ColorComponents,
        borderComponents: ColorComponents? = nil
    ) -> UIImage {
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

            // Border.
            if let borderComponents {
                let strokeColor = UIColor(
                    hue: borderComponents.hue,
                    saturation: borderComponents.saturation,
                    brightness: borderComponents.brightness,
                    alpha: 1.0)
                strokeColor.setStroke()
                let strokeWidth: CGFloat = 5.0
                let borderRect = size.rect().inset(by: strokeWidth / 2)
                cgContext.stroke(borderRect, width: strokeWidth)
                cgContext.drawPath(using: .stroke)
            }

            // Shadow.
            cgContext.setShadow(
                offset: CGSize(width: 1, height: 3),
                blur: 3,
                color: UIColor.black.withAlphaComponent(0.5).cgColor
            )

            drawStrings(text: text, size: size, caption: caption)
        }

        return uiImage
    }
    #endif


    /// Draws the given strings. This function is expected to be called within a call to
    /// `UIGraphicsImageRenderer/image` in iOS, or `NSImage(size:flipped:drawingHandle:)` in macOS.
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


    /// Generates deterministic color components for the given `string` for the image background.
    private static func colorComponentsForBackground(_ string: String) -> ColorComponents {
        let hash = persistentHash(for: string)

        // Hue.
        let hue = hueComponent(hash: hash, offset: 0)
        // Saturation in the range of: 0.6 - 1.0.
        let saturation = colorComponent(hash: hash, offset: 60, delta: 40)
        // Brightness in the range: 0.55 - 0.9.
        let brightness = colorComponent(hash: hash, offset: 55, delta: 35)

        return .init(hue: hue, saturation: saturation, brightness: brightness)
    }


    /// Generates deterministic color components for the given `string` for the image border.
    private static func colorComponentsForBorder(_ string: String) -> ColorComponents {
        let hash = persistentHash(for: string)

        // Hue with an offset of 1/6 of a circle.
        let hue = hueComponent(hash: hash, offset: 60)
        // Saturation in the range of: 0.6 - 1.0.
        let saturation = colorComponent(hash: hash, offset: 60, delta: 40)
        // Brightness in the range: 0.35 - 0.7.
        let brightness = colorComponent(hash: hash, offset: 35, delta: 35)

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


    /// Calculates the hue component based in a 360 modulo.Offset should be in the range `[0, 360)`.
    /// Returned component value is in the range `[0, 1)`.
    private static func hueComponent(hash: Int, offset: Int) -> Double {
        let hueAngle = (hash + offset) % 360
        return hueAngle.asDouble / 360.0
    }


    /// Caculates a color component with an offset and delta in the range `[0, 100]`
    /// Returned component value is in the range `[offset/100, (offset+delta)/100)`.
    private static func colorComponent(hash: Int, offset: Int, delta: Int) -> Double {
        return (offset + (hash % delta)).asDouble / 100.0
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


#Preview("Platform", traits: .fixedHeader, PreviewContent.layout) {
    // TODO: use stackBelow modifier
    let imageGenerator = SyncImageGenerator(size: .square(of: 100))
    let instanceImage = imageGenerator.generatePlatformImage(with: "Instance")
    Image(platformImage: instanceImage)
    Text(type(of: instanceImage).description())

    let staticImage = SyncImageGenerator.generatePlatformImage(with: "Static", size: .square(of: 100))
    Image(platformImage: staticImage)
    Text(type(of: staticImage).description())
}


#Preview("Static", traits: .fixedHeader, PreviewContent.layout) {
    SyncImageGenerator.generateImage(
        with: "200", caption: "Large",
        size: .square(of: 200))
    SyncImageGenerator.generateImage(
        with: "100", caption: "Regular",
        size: .square(of: 100), border: true)
    SyncImageGenerator.generateImage(
        with: "50", caption: "Small",
        size: .square(of: 50), border: true)
}


#Preview("Alphabet", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable let imageGenerator = SyncImageGenerator(size: .square(of: 80))

    LazyVGrid(
        columns: [.adaptive(minimum: 75, maximum: 90, spacing: 4)],
        alignment: .center,
        spacing: 4
    ) {
        ForEach(Strings.natoPhoneticAlphabet, id: \.self) { string in
            ConstrainedFill(alignment: .center) {
                imageGenerator.generateImage(with: string, border: true)
                .resizable()
                .scaledToFill()
            }
            .aspectRatio(1, contentMode: .fill)
            .roundedRectangleClip(cornerRadius: 8)


        }
    }
}

// TODO: move to addition.
extension Image {

    #if canImport(AppKit)
    public typealias PlatformImage = NSImage
    #elseif canImport(UIKit)
    public typealias PlatformImage = UIImage
    #endif

    nonisolated
    init(platformImage: PlatformImage) {
        #if canImport(AppKit)
        self.init(nsImage: platformImage)
        #elseif canImport(UIKit)
        self.init(uiImage: platformImage)
        #endif
    }

}
