//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


/// A label style that places the icon inside a `UniformSizeSymbol`.
///
/// ``UniformSizeSymbol`` frames the icon in an uniform square size based on the `circle` symbol,
/// irregardless of the size of actual icon. This allows labels to have a consistent icon size even
/// with different or changing symbols.
///
/// Use this style through the `LabelStyle` extension ``SwiftUI/LabelStyle/uniformIcon``:
///
/// ```swift
/// Label("Label", systemImage: "ladybug")
/// .labelStyle(.uniformIcon)
/// ```
///
/// This style internally builds a `Label` view and is composable with other label styles. Stack it
/// with other label styles compose its effects:
///
/// ```swift
/// Label("Label", systemImage: "ladybug")
/// .labelStyle(.uniformIcon)
/// .labelStyle(.iconOnly)
/// ```
///
/// The order matters, if applied outside a terminal style, such as `.iconOnly`, this style has
/// no effect.
///
///
/// ### LabelStyle Extensions
/// + ``SwiftUI/LabelStyle/uniformIcon``
///
nonisolated
public struct UniformSizeSymbolLabelStyle: LabelStyle {

    /// Creates label style with a uniform icon size.
    public init() {}

    @_documentation(visibility: internal)
    public func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            UniformSizeSymbol(content: configuration.icon)
        }
    }

}


// MARK: - LabelStyle Extension


extension LabelStyle where Self == UniformSizeSymbolLabelStyle {

    /// A label style with a uniform icon size.
    nonisolated
    public static var uniformIcon: Self {
        UniformSizeSymbolLabelStyle()
    }

}


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing, .headerFooter) {
    let labels = VStack {
        Label("Styled", systemImage: "guidepoint.horizontal")
        .border(.mint.secondary)
        Label("Styled", systemImage: "guidepoint.vertical")
        .border(.mint.secondary)
    }

    labels
    .floatingCaption("Default", alignment: .outerTrailing)

    DashedDivider()

    labels
    .labelStyle(.iconOnly)
    .floatingCaption("IconOnly", alignment: .outerTrailing)

    DashedDivider()

    labels
    .labelStyle(.uniformIcon)
    .floatingCaption("UniformIcon", alignment: .outerTrailing)

    DashedDivider()

    labels
    .labelStyle(.uniformIcon)
    .labelStyle(.iconOnly)
    .floatingCaption("Uniform+IconOnly", alignment: .outerTrailing)
}


// MARK: Snippets
#Preview("Snippets", traits: .paddingSpacing) {
    Label("Label", systemImage: "ladybug")
    .labelStyle(.uniformIcon)

    Label("Label", systemImage: "ladybug")
    .labelStyle(.uniformIcon)
    .labelStyle(.iconOnly)
}

