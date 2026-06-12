//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Playgrounds
import SwiftUI


/// A format style that outputs the last word of a string.
///
/// Use this format style through the available `FormatStyle` extensions ``Foundation/FormatStyle/lastWord``:
///
/// ```swift
/// Text("black quartz", format: .lastWord) // Displays "quartz"
/// ```
///
/// ## Topics
///
/// ### FormatStyle Extensions
/// + ``Foundation/FormatStyle/lastWord``\
///
public nonisolated
struct LastWordFormatStyle: FormatStyle, Sendable {

    /// Creates a format style that outputs the last word of a string.
    init() {}


    @_documentation(visibility: internal)
    public func format(_ value: String) -> String {
        guard let lastSpace = value.lastIndex(where: { $0.isWhitespace }) else {
            return value
        }
        return String(value[value.index(after: lastSpace)...])
    }

}


extension FormatStyle where Self == LastWordFormatStyle {

    /// Returns a format style that outputs the last word of a string.
    ///
    /// Returns a ``LastWordFormatStyle`` that outputs the last word of the input string.
    public nonisolated
    static var lastWord: Self { LastWordFormatStyle() }

}


// MARK: - Playgrounds


#Playground("Default") {
    _ = "black quartz".formatted(.lastWord)
}


// MARK: - Previews


#Preview("Snippet", traits: .sizeThatFitsLayout) {
    Text("black quartz", format: .lastWord) // Displays "quartz"
    .padding()
}
