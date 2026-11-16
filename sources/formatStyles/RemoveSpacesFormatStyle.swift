//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import Foundation

import SwiftUI


// FIXME: Document, publicize, test, list in api-docs.


/// A format style that removes whitespace from a string.
///
/// Use this format style through the `FormatStyle` extension ``Foundation/FormatStyle/removeSpaces``:
///
/// ```swift
/// Text("black quartz", format: .removeSpaces) // Displays "blackquartz"
/// ```
///
/// Or form a composite `FormatStyle` with another by using ``Foundation/FormatStyle/removingSpaces``:
///
/// ```swift
/// Text("black quartz", format: .capitalize.removingSpaces) // Displays "BlackQuartz"
/// ```
///
/// ## Topics
///
/// ### FormatStyle Extensions
/// + ``Foundation/FormatStyle/removeSpaces``
///
/// ### FormatStyle Modifiers
/// + ``Foundation/FormatStyle/removingSpaces``
nonisolated
public struct RemoveSpacesFormatStyle: FormatStyle, Sendable {

    public init() {}

    public func format(_ value: String) -> String {
        return value.components(separatedBy: .whitespaces).joined()
    }

}


extension FormatStyle where Self == RemoveSpacesFormatStyle {

    nonisolated
    public static var removeSpaces: Self { RemoveSpacesFormatStyle() }

}


extension FormatStyle where Self: Sendable, FormatOutput == String {

    nonisolated
    public var removingSpaces: CompositeFormatStyle<Self, RemoveSpacesFormatStyle> {
        return CompositeFormatStyle(input: self, output: .removeSpaces)
    }

}


// MARK: - Previews


#Preview("Snippets", traits: .spacing(16)) {
    Text("black quartz", format: .removeSpaces) // Displays "blackquartz"

    Text("black quartz", format: .capitalize.removingSpaces) // Displays "BlackQuartz"
}
