//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation
import Playgrounds
import SwiftUI



/// A format style that outputs the first character of a string, optionally capitalized.
///
/// Use this format style through the available `FormatStyle` extensions like ``Foundation/FormatStyle/firstCharacter``
/// or ``Foundation/FormatStyle/firstCharacterCapitalized``:
///
/// ```swift
/// Text("black quartz", format: .firstCharacter)            // Displays "b"
/// Text("black quartz", format: .firstCharacterCapitalized) // Displays "B"
/// ```
///
/// ## Topics
///
/// ### FormatStyle Extensions
/// + ``Foundation/FormatStyle/firstCharacter``
/// + ``Foundation/FormatStyle/firstCharacterCapitalized``
/// + ``Foundation/FormatStyle/firstCharacter(capitalized:)``
/// + ``Foundation/FormatStyle/firstCharacter(of:capitalized:)``
public nonisolated
struct FirstCharacterFormatStyle: FormatStyle, Sendable {

    let capitalized: Bool


    /// Creates a format style that outputs the first character of a string, optionally
    /// capitalized.
    ///
    /// - Parameter capitalized: Indicates if the output string is capitalized; defaults to
    ///   `false`.
    init(capitalized: Bool = false) {
        self.capitalized = capitalized
    }


    @_documentation(visibility: internal)
    public func format(_ value: String) -> String {
        let firstCharacter = value.first?.description ?? .init()
        return capitalized
            ? firstCharacter.capitalized
            : firstCharacter
    }

}


// FUTURE: single static var firstCharacter, and make capitalized and capitalized(bool) modifier
// functions.
extension FormatStyle where Self == FirstCharacterFormatStyle {

    /// Returns a format style that outputs first character of a string.
    ///
    /// Returns a ``FirstCharacterFormatStyle`` configured to output the first character of the
    /// input string.
    ///
    /// ```swift
    /// Text("black quartz", format: .firstCharacter) // Displays "b"
    /// ```
    public nonisolated
    static var firstCharacter: Self { .init() }

    /// Returns a format style that outputs first character of a string, capitalized.
    ///
    /// Returns a ``FirstCharacterFormatStyle`` configured to output the first character of the
    /// input string, capitalized.
    ///
    /// ```swift
    /// Text("black quartz", format: .firstCharacterCapitalized) // Displays "B"
    /// ```
    public nonisolated
    static var firstCharacterCapitalized: Self {
        .init(capitalized: true)
    }

    /// Returns a format style that outputs first character of a string, optionally capitalized.
    ///
    /// Returns a ``FirstCharacterFormatStyle`` configured to output the first character of the
    /// input string, optionally capitalized.
    ///
    /// ```swift
    /// Text("black quartz", format: .firstCharacter(capitalized: true)) // Displays "B"
    /// ```
    ///
    /// - Parameter capitalized: Indicates if the output string is capitalized.
    public nonisolated
    static func firstCharacter(capitalized: Bool) -> Self {
        .init(capitalized: capitalized)
    }

}


extension FormatStyle {

    /// Returns a composite format style that formats the data with a given formatter and outputs
    /// the first character, optionally capitalized.
    ///
    /// Returns a ``CompositeFormatStyle`` configured with the given input format style, and a
    /// ``FirstCharacterFormatStyle`` to output the first character, optionally capitalized.
    ///
    /// ```swift
    /// Text("black quartz", format: .firstCharacter(of: .lastWord)) // Displays "q"
    /// ```
    ///
    /// - Parameters:
    ///   - input: The format style that produces a string from the input data.
    ///   - capitalized: Indicates if the output string is capitalized.
    public nonisolated
    static func firstCharacter<InputFormat: FormatStyle>(
        of input: InputFormat,
        capitalized: Bool = false
    ) -> Self
    where
        InputFormat.FormatOutput == String,
        Self == CompositeFormatStyle<InputFormat, FirstCharacterFormatStyle>
    {
        let output = FirstCharacterFormatStyle(capitalized: capitalized)
        return CompositeFormatStyle(input: input, output: output)
    }

}


// MARK: - Playgrounds


#Playground("Default") {
    _ = "black quartz".formatted(.firstCharacter)
    _ = "black quartz".formatted(.firstCharacterCapitalized)
    _ = "black quartz".formatted(.firstCharacter(of: .identity, capitalized: true))
}


// MARK: - Previews


#Preview("Snippet") {
    Text("black quartz", format: .firstCharacter)            // Displays "b"
    Text("black quartz", format: .firstCharacterCapitalized) // Displays "B"

    Text("black quartz", format: .firstCharacter(capitalized: true)) // Displays "B"

    Text("black quartz", format: .firstCharacter(of: .lastWord)) // Displays "q"
}
