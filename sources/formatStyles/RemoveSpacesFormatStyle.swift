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

    /// Creates a format style that removes whitespace from a string.
    public init() {}


    /// Formats a string value, using this style
    /// - Parameter value: The string value to format.
    /// - Returns: `value` without any whitespace characters.
    public func format(_ value: String) -> String {
        return value.components(separatedBy: .whitespaces).joined()
    }

}


extension FormatStyle where Self == RemoveSpacesFormatStyle {

    /// Returns a format style that removes whitespace from a string.
    ///
    /// Returns a ``RemoveSpacesFormatStyle`` that removes whitespace from a string.
    ///
    /// ```swift
    /// Text("black quartz", format: .removeSpaces) // Displays "blackquartz"
    /// ```
    nonisolated
    public static var removeSpaces: Self { RemoveSpacesFormatStyle() }

}


extension FormatStyle where Self: Sendable, FormatOutput == String {

    /// Removes whitespace from the output of `self`.
    ///
    /// Returns a ``CompositeFormatStyle`` that joins `self` with ``RemoveSpacesFormatStyle`` to
    /// remove whitespace from the output of `self`.
    ///
    /// ```swift
    /// Text("black quartz", format: .capitalize.removingSpaces) // Displays "BlackQuartz"
    /// ```
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
