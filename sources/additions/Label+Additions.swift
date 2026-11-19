//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


// MARK: Key+Icon Inits


extension Label {

    /// Creates a label with custom icon and a title generated from a localized string.
    /// - Parameters:
    ///   - key: The title of the label.
    ///   - icon: The view to use as icon for the label.
    @inlinable
    public init(
        _ key: LocalizedStringKey,
        @ContentBuilder icon: () -> Icon
    ) where
        Title == Text
    {
        self.init(
            title: { Text(key) },
            icon: icon
        )
    }


    /// Creates a label with custom icon and a title generated from a localized string.
    /// - Parameters:
    ///   - key: The title of the label.
    ///   - icon: The view to use as icon for the label.
    @inlinable
    public init(_ key: LocalizedStringKey, icon: Icon)
    where Title == Text
    {
        self.init(
            title: { Text(key) },
            icon: { icon }
        )
    }

}


// MARK: - UniformIcon


// FIXME: Test.

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
/// This style is composable, stack it with other label styles to compose its effects:
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


extension LabelStyle where Self == UniformSizeSymbolLabelStyle {

    /// A label style with a uniform icon size.
    nonisolated
    public static var uniformIcon: Self {
        UniformSizeSymbolLabelStyle()
    }

}


// MARK: - Previews


#Preview("Default") {
    Group {
        Label("With Closure") {
            FilledRectangle(.orange.gradient, size: .square(of: 20))
        }

        Label("With Closure") {
            FilledRectangle(.orange.gradient, size: .square(of: 40))
        }

        Label("With Value", icon: Image(systemName: "ladybug"))

        Label("With Value", icon: Image(systemName: "square"))
    }
    .debugAlignmentGuide(vertical: .firstTextBaseline)
}


// MARK: UniformIcon


#Preview("UniformIcon", traits: .paddingSpacing, .headerFooter) {
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
