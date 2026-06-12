//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Playgrounds
import SwiftUI


/// A format style that outputs the first word of a string.
///
/// Use this format style through the available `FormatStyle` extensions ``Foundation/FormatStyle/firstWord``:
///
/// ```swift
/// Text("black quartz", format: .firstWord) // Displays "black"
/// ```
///
/// ## Topics
///
/// ### FormatStyle Extensions
/// + ``Foundation/FormatStyle/firstWord``
///
public nonisolated
struct FirstWordFormatStyle: FormatStyle, Sendable {

    /// Creates a format style that outputs the first word of a string.
    init() {}


    @_documentation(visibility: internal)
    public func format(_ value: String) -> String {
        String(value.prefix(while: { !$0.isWhitespace }))
    }

}


extension FormatStyle where Self == FirstWordFormatStyle {

    /// Returns a format style that outputs first word of a string.
    ///
    /// Returns a ``FirstWordFormatStyle`` that outputs the first word of the input string.
    public nonisolated
    static var firstWord: Self { FirstWordFormatStyle() }

}


// MARK: - Playgrounds


#Playground("Default") {
    _ = "black quartz".formatted(.firstWord)
}


// MARK: - Previews


#Preview("Snippet", traits: .sizeThatFitsLayout) {
    Text("black quartz", format: .firstWord) // Displays "black"
    .padding()
}
