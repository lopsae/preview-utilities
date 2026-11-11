//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


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


// MARK: - Previews


#Preview("Default") {
    Label("With Closure") {
        Rectangle()
        .fill(.red.gradient)
        .frame(squareOf: 20)
    }

    Label("With Value", icon: Image(systemName: "ladybug"))
}
