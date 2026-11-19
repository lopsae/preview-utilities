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


// FIXME: Doc, publicize, test.
struct UniformSizeSymbolLabelStyle: LabelStyle {

    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            UniformSizeSymbol(content: configuration.icon)
        }
    }

}


extension LabelStyle where Self == UniformSizeSymbolLabelStyle {

    static var uniformIcon: Self {
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
