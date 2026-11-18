//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension ShapeStyle where Self == AnyShapeStyle {

    // FIXME: Doc, publicize, test.
    static func `if`(
        _ condition: Bool,
        then trueStyle: some ShapeStyle,
        else falseStyle: some ShapeStyle
    ) -> Self {
        condition ? Self(trueStyle) : Self(falseStyle)
    }

}


// MARK: - Preview


#Preview("Default", traits: .headerFooter) {
    @Previewable @State var toggle = true

    Toggle("Toggle Style", isOn: $toggle)

    let style: some ShapeStyle = .if(toggle, then: .pink, else: .secondary)
    Image(systemName: "ladybug")
    .font(.largeTitle)
    .foregroundStyle(style)
}
