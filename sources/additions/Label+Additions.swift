//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


// MARK: Key+Icon Inits


extension Label {

    /// Creates a label with a custom icon and a title generated from a localized string.
    ///
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
        self.init(title: Text(key), icon: icon())
    }


    /// Creates a label with a custom icon and a title generated from a localized string.
    ///
    /// - Parameters:
    ///   - key: The title of the label.
    ///   - icon: The view to use as icon for the label.
    @inlinable
    public init(_ key: LocalizedStringKey, icon: Icon)
    where Title == Text
    {
        self.init(title: Text(key), icon: icon)
    }


    /// Creates a label with a custom title and icon.
    ///
    /// This initializer overloads its parameters to autoclosures.
    ///
    /// - Parameters:
    ///   - key: The view to use as title of the label.
    ///   - icon: The view to use as icon for the label.
    @inlinable
    public init(
        title: @autoclosure () -> Title,
        icon: @autoclosure () -> Icon
    ) {
        self.init(
            title: { title() },
            icon: { icon() }
        )
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

        Label("With Closure") {
            Image(systemName: "clock.badge.airplane")
            .background(.green.secondary)
        }

        DashedDivider()

        Label("With Value", icon: Image(systemName: "ladybug"))
        Label("With Value", icon: Image(systemName: "square"))
        Label("With Value", icon: Image(systemName: "clock.badge.airplane").background(.green.secondary))
    }
    .debugAlignmentGuide(vertical: .firstTextBaseline)
}
