//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


/// Rectangle view configured with stroke, fill, floating caption, and optionally fixed size.
public struct CaptionRectangle<Fill: ShapeStyle, Stroke: ShapeStyle>: View {
    let localizationKey: LocalizedStringKey
    let fill: Fill
    let stroke: Stroke
    let width: CGFloat?
    let height: CGFloat?
    let borderWidth: CGFloat
    let flatTraits: [CaptionRectangleTrait]


    public init(
        _ localizationKey: LocalizedStringKey,
        fill: Fill = .gray.gradient.tertiary,
        stroke: Stroke = .tertiary,
        borderWidth: CGFloat = 1,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        traits: some Sequence<CaptionRectangleTrait>
    ) {
        self.localizationKey = localizationKey
        self.fill        = fill
        self.stroke      = stroke
        self.width       = width
        self.height      = height
        self.borderWidth = borderWidth
        self.flatTraits  = traits.flattenTraits()
    }


    public init(
        _ localizationKey: LocalizedStringKey,
        fill: Fill = .gray.gradient.tertiary,
        stroke: Stroke = .tertiary,
        borderWidth: CGFloat = 1,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        traits: CaptionRectangleTrait...
    ) {
        self.init(
            localizationKey, fill: fill, stroke: stroke, borderWidth: borderWidth,
            width: width, height: height, traits: traits)
    }


    public init(
        _ localizationKey: LocalizedStringKey,
        fill: Fill = .gray.gradient.tertiary,
        stroke: Stroke = .tertiary,
        borderWidth: CGFloat = 1,
        size: CGSize,
        traits: CaptionRectangleTrait...
    ) {
        self.init(
            localizationKey, fill: fill, stroke: stroke, borderWidth: borderWidth,
            width: size.width, height: size.height,
            traits: traits)
    }


    public init(
        _ localizationKey: LocalizedStringKey,
        color: Color,
        borderWidth: CGFloat = 1,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        traits: CaptionRectangleTrait...
    )
        where Fill == AnyShapeStyle, Stroke == AnyShapeStyle
    {
        self.init(
            localizationKey,
            fill: AnyShapeStyle(color.gradient.tertiary),
            stroke: AnyShapeStyle(color.secondary),
            borderWidth: borderWidth,
            width: width, height: height, traits: traits)
    }


    public init(
        _ localizationKey: LocalizedStringKey,
        color: Color,
        borderWidth: CGFloat = 1,
        size: CGSize,
        traits: CaptionRectangleTrait...
    )
        where Fill == AnyShapeStyle, Stroke == AnyShapeStyle
    {
        self.init(
            localizationKey,
            fill: AnyShapeStyle(color.gradient.tertiary),
            stroke: AnyShapeStyle(color.secondary),
            borderWidth: borderWidth,
            width: size.width, height: size.height,
            traits: traits)
    }


    @_documentation(visibility: internal)
    public var body: some View {
        RoundedRectangle(cornerRadius: SpacingDefaults.padding / 3)
        .fill(fill)
        .strokeBorder(stroke, lineWidth: borderWidth)
        .frame(width: width, height: height)
        .overlay {
            GeometryReader { geometry in
                let alignment = flatTraits.alignment ?? .center
                FloatingAlignedContainer(alignment: alignment, spacing: 2) { alignments in
                    VStack(alignment: alignments.content.horizontal) {
                        // TODO: Add support for verbatim and no caption. See `TextSource`.
                        Text(localizationKey)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(alignments.text)

                        // TODO: Code shared with FloatingCaption and DebugGeometry. Think to DRY.
                        // Maybe a style for geometryProxy?

                        // Width, Height, or Size.
                        Group {
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
                        .foregroundStyle(.secondary)

                    } // VStack
                    .fixedSize()
                } // FloatingAlignedContainer
            } // GeometryReader
        } // overlay
    }

}


// MARK: - Traits

// This trait implementation is an experimental configuration object solely based on an
// enumeration, in contrast to a structure containing all properties like
// `DebugGeometryModifier.Configuration`.

/// Customizations that can be applied to a `CaptionRectangle`.
public enum CaptionRectangleTrait: IdentifiableCase {

    /// Prints the width of the owner view along the text caption.
    case width

    /// Prints the height of the owner view along the text caption.
    case height

    /// Aligns the caption to the given floating alignment.
    case alignment(FloatingAlignment)

    /// Applies the associated traits.
    case traits([Self])


    /// Enumeration to identify each trait case.
    @_documentation(visibility: internal)
    public enum Case {
        case width, height
        case alignment
        case traits
    }


    /// Identifier of the trait case.
    @_documentation(visibility: internal)
    public var `case`: Case {
        switch self {
        case .width:        .width
        case .height:       .height
        case .alignment:    .alignment
        case .traits:       .traits
        }
    }

    /// Prints the width and height of the owner view along the text caption.
    public static let size: Self = .traits([.width, .height])

}


// MARK: - Trait Collection

// For case with an associated value, there needs to be a helper function to extract the last
// value of that case. This means that traits of a given type cannot be additive or build on top
// of each other.

// The behaviour of the trait becomes either one of presence: A trait is activated if it is present
// in the collection of traits.
// Or by overwrite: the last present trait is the active configuration.

extension Sequence where Element == CaptionRectangleTrait {

    func flattenTraits() -> [Element] {
        return self.flatMap { trait in
            guard case .traits(let traits) = trait else {
                return [trait]
            }
            return traits.flattenTraits()
        }
    }

}


extension BidirectionalCollection where Element == CaptionRectangleTrait {

    var alignment: FloatingAlignment? {
        let caseInstance = lastCase(.alignment)
        if case .alignment(let alignment) = caseInstance {
            return alignment
        }
        return nil
    }

}


// MARK: - Preview


#Preview("Default", traits: .iPhoneProSizeForcedLayout) {
    CaptionRectangle(
        "Only Size",
        width: 150, height: 100,
        traits: .height)

    CaptionRectangle(
        "With Fill",
        fill: .cyan.gradient.tertiary,
        width: 150, height: 100,
        traits: .width)

    CaptionRectangle(
        "With Fill,\nClear Stroke",
        fill: .mint.gradient.tertiary,
        stroke: .clear,
        width: 150, height: 100,
        traits: .height)

    CaptionRectangle(
        "With Fill & Stroke",
        fill: .mint.gradient.tertiary,
        stroke: .teal,
        width: 150, height: 100,
        traits: .height)

    CaptionRectangle(
        "Border Width",
        fill: .mint.gradient.tertiary,
        stroke: .teal,
        borderWidth: 4,
        width: 150, height: 100,
        traits: .height)
}
