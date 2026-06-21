//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Playgrounds
import SwiftUI


/// A format style that outputs the first word of a string.
///
/// Use this format style through the `FormatStyle` extension ``Foundation/FormatStyle/firstWord``:
///
/// ```swift
/// Text("black quartz", format: .firstWord) // Displays "black"
/// ```
///
/// Any leading whitespace in the input string is ignored and only the first word, trimmed from
/// whitespace, is output.
///
/// ## Topics
///
/// ### FormatStyle Extensions
/// + ``Foundation/FormatStyle/firstWord``
///
public nonisolated
struct FirstWordFormatStyle: FormatStyle, Sendable {

    /// Creates a format style that outputs the first word of a string.
    public init() {}


    @_documentation(visibility: internal)
    public func format(_ value: String) -> String {
        let trimmed = value.drop(while: { $0.isWhitespace })
        let firstWord = trimmed.prefix(while: { !$0.isWhitespace })
        return String(firstWord)
    }

}


extension FormatStyle where Self == FirstWordFormatStyle {

    /// Returns a format style that outputs first word of a string.
    ///
    /// Returns a ``FirstWordFormatStyle`` that outputs the first word of the input string.
    ///
    /// ```swift
    /// Text("black quartz", format: .firstWord) // Displays "black"
    /// ```
    public nonisolated
    static var firstWord: Self { FirstWordFormatStyle() }

}


// MARK: - Playgrounds


#Playground("Default") {
    _ = "black quartz".formatted(.firstWord)
    _ = "   black quartz".formatted(.firstWord)
    _ = "".formatted(.firstWord)
}


// MARK: - Previews


#Preview("Snippets", traits: .sizeThatFitsLayout) {
    Text("black quartz", format: .firstWord) // Displays "black"
    .padding()
}
