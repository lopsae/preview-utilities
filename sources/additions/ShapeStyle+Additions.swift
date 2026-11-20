//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


extension ShapeStyle where Self == AnyShapeStyle {

    // FIXME: Test.

    /// Either of two styles, wrapped in `AnyShapeStyle`.
    ///
    /// - Parameters:
    ///   - condition: Indicates if the `trueStyle` or `falseStyle` is returned.
    ///   - trueStyle: Style to return when `condition` is `true`.
    ///   - falseStyle: Style to return when `condition` is `false`.
    /// - Returns: One of the given styles, wrapped in `AnyShapeStyle`.
    public static func `if`(
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
