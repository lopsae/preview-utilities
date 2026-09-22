//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import Foundation
import Playgrounds
import SwiftUI


/// A format style that outputs the last word of a string.
///
/// Use this format style through the `FormatStyle` extension ``Foundation/FormatStyle/lastWord``:
///
/// ```swift
/// Text("black quartz", format: .lastWord) // Displays "quartz"
/// ```
///
/// Any trailing whitespace in the input string is ignored and only the last word, trimmed from
/// whitespace, is output.
///
/// ## Topics
///
/// ### FormatStyle Extensions
/// + ``Foundation/FormatStyle/lastWord``
///
public nonisolated
struct LastWordFormatStyle: FormatStyle, Sendable {

    /// Creates a format style that outputs the last word of a string.
    public init() {}


    @_documentation(visibility: internal)
    public func format(_ value: String) -> String {
        guard let lastNonSpace = value.lastIndex(where: { !$0.isWhitespace }) else {
            return .empty
        }
        let trimmed = value[...lastNonSpace]
        guard let lastSpace = trimmed.lastIndex(where: { $0.isWhitespace }) else {
            return String(trimmed)
        }
        let afterLastSpace = trimmed.index(after: lastSpace)
        let lastWord = trimmed[afterLastSpace...]
        return String(lastWord)
    }

}


extension FormatStyle where Self == LastWordFormatStyle {

    /// Returns a format style that outputs the last word of a string.
    ///
    /// Returns a ``LastWordFormatStyle`` that outputs the last word of the input string.
    ///
    /// ```swift
    /// Text("black quartz", format: .lastWord) // Displays "quartz"
    /// ```
    public nonisolated
    static var lastWord: Self { LastWordFormatStyle() }

}


// MARK: - Playgrounds


#Playground("Default") {
    _ = "black quartz".formatted(.lastWord)
    _ = "black quartz   ".formatted(.lastWord)
    _ = "".formatted(.lastWord)
}


// MARK: - Previews


#Preview("Snippets", traits: .sizeThatFitsLayout) {
    Text("black quartz", format: .lastWord) // Displays "quartz"
    .padding()
}
