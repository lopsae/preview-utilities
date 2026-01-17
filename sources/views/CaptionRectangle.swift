//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// Rectangle configured with stroke, fill, fixed size, and floating caption.
struct CaptionRectangle<Fill: ShapeStyle, Stroke: ShapeStyle>: View {
    let localizationKey: LocalizedStringKey
    let fill: Fill
    let stroke: Stroke
    let width: CGFloat?
    let height: CGFloat?
    let traits: [FloatingCaptionModifier.Trait]


    init(
        _ localizationKey: LocalizedStringKey,
        fill: Fill = .gray.gradient.tertiary,
        stroke: Stroke = .tertiary,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        traits: [FloatingCaptionModifier.Trait]
    ) {
        self.localizationKey = localizationKey
        self.fill = fill
        self.stroke = stroke
        self.width = width
        self.height = height
        self.traits = traits
    }


    init(
        _ localizationKey: LocalizedStringKey,
        fill: Fill = .gray.gradient.tertiary,
        stroke: Stroke = .tertiary,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        traits: FloatingCaptionModifier.Trait...
    ) {
        self.init(
            localizationKey, fill: fill, stroke: stroke,
            width: width, height: height, traits: traits)
    }


    init(
        _ localizationKey: LocalizedStringKey,
        fill: Fill = .gray.gradient.tertiary,
        stroke: Stroke = .tertiary,
        size: CGSize,
        traits: FloatingCaptionModifier.Trait...
    ) {
        self.init(
            localizationKey, fill: fill, stroke: stroke,
            width: size.width, height: size.height,
            traits: traits)
    }


    init(
        _ localizationKey: LocalizedStringKey,
        color: Color,
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
            width: width, height: height, traits: traits)
    }


    init(
        _ localizationKey: LocalizedStringKey,
        color: Color,
        size: CGSize,
        traits: FloatingCaptionModifier.Trait...
    )
        where Fill == AnyShapeStyle, Stroke == AnyShapeStyle
    {
        self.init(
            localizationKey,
            fill: AnyShapeStyle(color.gradient.tertiary),
            stroke: AnyShapeStyle(color.secondary),
            width: size.width, height: size.height,
            traits: traits)
    }


    var body: some View {
        RoundedRectangle(cornerRadius: Defaults.padding / 3)
            .fill(fill)
            .stroke(stroke)
            .frame(width: width, height: height)
            .floatingCaption(localizationKey, traits: traits)
    }
}


// MARK: - Preview


#Preview("Default", traits: .iPhoneProSizeForcedLayout) {
    CaptionRectangle(
        "Caption Rectangle",
        width: 120, height: 120,
        traits: .height)

    CaptionRectangle(
        "Caption Rectangle",
        fill: .cyan.gradient.tertiary,
        width: 120, height: 120,
        traits: .width)

    CaptionRectangle(
        "Caption Rectangle",
        fill: .mint.gradient.tertiary,
        stroke: .clear,
        width: 120, height: 120,
        traits: .height)
}
