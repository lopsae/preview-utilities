//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI

// TODO: clarify that note that FloatingCaptionModifier.Trait also has properties like .border, but this view
// draws its own border.

/// Rectangle view configured with stroke, fill, floating caption, and optionally fixed size.
public struct CaptionRectangle<Fill: ShapeStyle, Stroke: ShapeStyle>: View {
    let localizationKey: LocalizedStringKey
    let fill: Fill
    let stroke: Stroke
    let width: CGFloat?
    let height: CGFloat?
    let borderWidth: CGFloat
    let traits: [FloatingCaptionModifier.Trait]


    public init(
        _ localizationKey: LocalizedStringKey,
        fill: Fill = .gray.gradient.tertiary,
        stroke: Stroke = .tertiary,
        borderWidth: CGFloat = 1,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        traits: [FloatingCaptionModifier.Trait]
    ) {
        self.localizationKey = localizationKey
        self.fill        = fill
        self.stroke      = stroke
        self.width       = width
        self.height      = height
        self.borderWidth = borderWidth
        self.traits      = traits
    }


    public init(
        _ localizationKey: LocalizedStringKey,
        fill: Fill = .gray.gradient.tertiary,
        stroke: Stroke = .tertiary,
        borderWidth: CGFloat = 1,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        traits: FloatingCaptionModifier.Trait...
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
        traits: FloatingCaptionModifier.Trait...
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
        traits: FloatingCaptionModifier.Trait...
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
        traits: FloatingCaptionModifier.Trait...
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


    public var body: some View {
        RoundedRectangle(cornerRadius: Defaults.padding / 3)
            .fill(fill)
            .strokeBorder(stroke, lineWidth: borderWidth)
            .frame(width: width, height: height)
            .floatingCaption(localizationKey, traits: traits)
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
        borderWidth: 5,
        width: 150, height: 100,
        traits: .height)
}
