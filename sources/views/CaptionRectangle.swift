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
        fill: Fill,
        stroke: Stroke = .tertiary,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        traits: FloatingCaptionModifier.Trait...
    ) {
        self.localizationKey = localizationKey
        self.fill = fill
        self.stroke = stroke
        self.width = width
        self.height = height
        self.traits = traits
    }


    var body: some View {
        RoundedRectangle(cornerRadius: Defaults.padding / 3)
            .fill(fill)
            .stroke(.tertiary)
            .frame(width: width, height: height)
            .floatingCaption(localizationKey, traits: traits)
    }
}
