//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI

// FUTURE: Figure out a dynamic shape around a caption. Rounded border that surrounds several `Text`s
// respecting each of their sizes. Make it a option/trait.

// FUTURE: Here and in CaptionRectangle, localized key could be optional. At that point, debugOverlay could also use floating caption directly!

/// Overlays a floating caption text aligned to a `FloatingAlignment`.
///
/// Displays in an overlay a floating caption text aligned to a specified ``FloatingAlignment``.
/// The caption can be aligned to the center, any inner edge, and any outer edge of the parent view
/// boundaries. The overlay can be configured to display additional information like its size, and
/// to draw a border around the view's boundary.
///
/// All content added by this modifier is layered in an overlay of the parent view, the original
/// layout is never modified.
///
/// Apply this modifier using ``SwiftUICore/View/floatingCaption(_:_:)``.
public struct FloatingCaptionModifier: ViewModifier {

    let localizedKey: LocalizedStringKey
    let flatTraits: [Trait]


    public init(localizedKey: LocalizedStringKey, traits: [Trait]) {
        self.localizedKey = localizedKey
        self.flatTraits = traits.flattenTraits()
    }

    public func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { geometry in
                let alignment = flatTraits.alignment ?? .inner(.center)
                // TODO: for internal alignments, padding should also consider the border width, when border is present!
                let padding: CGFloat? = flatTraits.containsCase(.padding)
                    ? flatTraits.padding // The trait can specify a nil value for a default padding.
                    : 2 // Default without trait.
                FloatingAlignedContainer(alignment: alignment) { alignments in
                    VStack(alignment: alignments.content.horizontal) {
                        let textStyle: any ShapeStyle = flatTraits.captionStyle
                            ?? .secondary
                        Text(localizedKey)
                            .font(.caption)
                            .foregroundStyle(textStyle)
                            .multilineTextAlignment(alignments.text)

                        // Width, Height, or Size.
                        Group {
                            // FUTURE: if traits is a Set, this could use set operations.
                            let fractionLength: FloatingPointFormatStyle<Double> = .fractionLength(2)
                            if flatTraits.containsCase(.width) && flatTraits.containsCase(.height) {
                                let formattedWidth = geometry.size.width.formatted(fractionLength)
                                let formattedHeight = geometry.size.height.formatted(fractionLength)
                                Text("size: \(formattedWidth), \(formattedHeight)")
                            } else if flatTraits.containsCase(.width) {
                                let formattedWidth = geometry.size.width.formatted(fractionLength)
                                Text("width: \(formattedWidth)")
                            } else if flatTraits.containsCase(.height) {
                                let formattedHeight = geometry.size.height.formatted(fractionLength)
                                Text("height: \(formattedHeight)")
                            }
                        } // Group
                        .font(.caption.monospaced())
                        .foregroundStyle(AnyShapeStyle(textStyle))

                    } // VStack
                    .padding(.all, padding)
                    .fixedSize()
                } // FloatingAlignedContainer

                // Border.
                if let borderStyle = flatTraits.borderStyle {
                    let borderWidth = flatTraits.borderWidth ?? 1
                    Rectangle()
                    .strokeBorder(AnyShapeStyle(borderStyle), lineWidth: borderWidth)
                }
            } // GeometryReader
        } // overlay
    }

}


// MARK: - Trait


extension FloatingCaptionModifier {

    // This trait implementation is an experimental configuration object solely based on an
    // enumeration, in contrast with a structure containing all properties like
    // `DebugOverlayModifier.Configuration`.

    /// Customizations that can be applied to a `FloatingCaptionModifier`.
    ///
    /// Traits are passed to ``SwiftUICore/View/floatingCaption(_:_:)`` to build the configuration
    /// of a floating caption overlay. All passed traits are applied in order to a default
    /// configuration. If multiple traits that modify the same configuration properties are applied,
    /// usually the last will overwrite any former.
    public enum Trait: IdentifiableCase {
        case width
        case height
        case captionStyle(any ShapeStyle)
        case borderStyle(any ShapeStyle)
        case borderWidth(CGFloat)
        case alignment(FloatingAlignment)
        case padding(CGFloat? = nil)
        case traits([Trait])

        public enum Case {
            case width, height
            case captionStyle, borderStyle, borderWidth
            case alignment, padding
            case traits
        }

        // Since the enum have associated values, each enum needs to be identified by a value-less
        // parallel enum.
        public var `case`: Case {
            switch self {
            case .width:        .width
            case .height:       .height
            case .captionStyle: .captionStyle
            case .borderStyle:  .borderStyle
            case .borderWidth:  .borderWidth
            case .alignment:    .alignment
            case .padding:      .padding
            case .traits:       .traits
            }
        }


        public static let border: Self = .borderStyle(.quaternary)
        public static let size: Self = .traits([.width, .height])

        public static let zeroPadding:   Self = .padding(.zero)
        public static let systemPadding: Self = .padding(nil)

        public static func style(_ style: some ShapeStyle) -> Self {
            .traits([.captionStyle(style), .borderStyle(style)])
        }

        public static func colorStyle(_ color: Color) -> Self {
            .traits([.captionStyle(color), .borderStyle(color.secondary)])
        }

    }

}


// For case with an associated value, there needs to be a helper function to extract the last
// value of that case. This means that traits of a given type cannot be additive or build on top
// of each other.
extension BidirectionalCollection where Element == FloatingCaptionModifier.Trait {

    func flattenTraits() -> [Element] {
        return self.flatMap { trait in
            guard case .traits(let traits) = trait else {
                return [trait]
            }
            return traits.flattenTraits()
        }
    }

    var captionStyle: (any ShapeStyle)? {
        let caseInstance = lastCase(.captionStyle)
        if case .captionStyle(let captionStyle) = caseInstance {
            return captionStyle
        }
        return nil
    }


    var borderStyle: (any ShapeStyle)? {
        let caseInstance = lastCase(.borderStyle)
        if case .borderStyle(let borderStyle) = caseInstance {
            return borderStyle
        }
        return nil
    }


    var borderWidth: CGFloat? {
        let caseInstance = lastCase(.borderWidth)
        if case .borderWidth(let borderWidth) = caseInstance {
            return borderWidth
        }
        return nil
    }


    var alignment: FloatingAlignment? {
        let caseInstance = lastCase(.alignment)
        if case .alignment(let alignment) = caseInstance {
            return alignment
        }
        return nil
    }


    var padding: CGFloat? {
        let caseInstance = lastCase(.padding)
        if case .padding(let padding) = caseInstance {
            return padding
        }
        return nil
    }

}


// MARK: - View Extension


extension View {

    public func floatingCaption(_ key: LocalizedStringKey, _ traits: FloatingCaptionModifier.Trait...) -> some View {
        modifier(FloatingCaptionModifier(localizedKey: key, traits: traits))
    }


    public func floatingCaption(_ key: LocalizedStringKey, traits: [FloatingCaptionModifier.Trait]) -> some View {
        modifier(FloatingCaptionModifier(localizedKey: key, traits: traits))
    }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeForcedLayout

}


#Preview("Default", traits: PreviewContent.layout) {
    Rectangle()
        .fill(.indigo.gradient.tertiary)
        .frame(width: 40, height: 100)
        .floatingCaption("Tall Rectangle", .height)

    Rectangle()
        .fill(.indigo.gradient.tertiary)
        .frame(width: 200, height: 15)
        .floatingCaption("Short Rectangle", .width, .border)

    Rectangle()
        .fill(.indigo.gradient.tertiary)
        .frame(width: 200, height: 100)
        .floatingCaption("Default Padding\n(no trait)", .alignment(.innerLeading))
        .floatingCaption("Zero Padding",   .alignment(.trailing),       .zeroPadding)
        .floatingCaption("10 Padding",     .alignment(.bottomLeading),  .padding(10))
        .floatingCaption("System Padding", .alignment(.bottomTrailing), .systemPadding)

    Rectangle()
        .fill(.indigo.gradient.tertiary)
        .frame(squareOf: 100)
        .floatingCaption(
            "External", .size, .alignment(.outerBottom),
            .captionStyle(.indigo), .borderStyle(.indigo.tertiary),
            .borderWidth(3))
}


#Preview("Alignments", traits: PreviewContent.layout) {
    Rectangle()
    .fill(.indigo.gradient.tertiary)
    .frame(squareOf: 200)
    .overlay {
        ForEach(FloatingAlignment.allCases) { alignment in
            ClearRectangle()
            .floatingCaption("aligned\n\(alignment.abbreviatedName)", .alignment(alignment))
        }
    }

}
