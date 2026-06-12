//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation
import Playgrounds
import SwiftUI



/// A format style that outputs the first character of a string, optionally capitalized.
///
/// Use this format style through the `FormatStyle` extension ``Foundation/FormatStyle/firstCharacter``:
///
/// ```swift
/// Text("black quartz", format: .firstCharacter)             // Displays "b"
/// Text("black quartz", format: .firstCharacter.capitalized) // Displays "B"
/// ```
///
/// ## Topics
///
/// ### FormatStyle Extensions
/// + ``Foundation/FormatStyle/firstCharacter``
/// + ``Foundation/FormatStyle/firstCharacter(of:capitalize:)``
public nonisolated
struct FirstCharacterFormatStyle: FormatStyle, Sendable {

    /// Indicates if the output is capitalized.
    public var capitalize: Bool

    /// Creates a format style that outputs the first character of a string, optionally
    /// capitalized.
    ///
    /// - Parameter capitalize: Enables capitalization of the output; defaults to `false`.
    public init(capitalize: Bool = false) {
        self.capitalize = capitalize
    }


    /// Formats a string value, using this style.
    public func format(_ value: String) -> String {
        let firstCharacter = value.first?.description ?? .init()
        return capitalize
            ? firstCharacter.capitalized
            : firstCharacter
    }


    /// Modifies the format style to always capitalize.
    ///
    /// ```swift
    /// Text("black quartz", format: .firstCharacter.capitalized) // Displays "B"
    /// ```
    public var capitalized: Self {
        var copy = self
        copy.capitalize = true
        return copy
    }


    /// Modifies the capitalization of the format style output.
    ///
    /// ```swift
    /// Text("black quartz", format: .firstCharacter.capitalized(true)) // Displays "B"
    /// ```
    ///
    /// - Parameter capitalize: Enables capitalization of the output.
    /// - Returns: A ``FirstCharacterFormatStyle`` configured to output the first character of the
    ///     input string, optionally capitalized.
    ///
    public func capitalized(_ capitalize: Bool) -> Self {
        var copy = self
        copy.capitalize = capitalize
        return copy
    }

}


extension FormatStyle where Self == FirstCharacterFormatStyle {

    /// A format style that outputs first character of a string.
    ///
    /// Returns a ``FirstCharacterFormatStyle`` configured to output the first character of the
    /// input string.
    ///
    /// ```swift
    /// Text("black quartz", format: .firstCharacter) // Displays "b"
    /// ```
    public nonisolated
    static var firstCharacter: Self { .init() }

}


extension FormatStyle {

    /// Returns a composite format style that formats the data with a given formatter and outputs
    /// the first character, optionally capitalized.
    ///
    /// ```swift
    /// Text("black quartz", format: .firstCharacter(of: .lastWord)) // Displays "q"
    /// ```
    ///
    /// - Parameters:
    ///   - input: The format style that produces a string from the input data.
    ///   - capitalize: Enables capitalization of the output; defaults to `false`.
    /// - Returns: A ``CompositeFormatStyle`` configured with the given input format style, and a
    ///   ``FirstCharacterFormatStyle`` to output the first character.
    public nonisolated
    static func firstCharacter<InputFormat: FormatStyle>(
        of input: InputFormat,
        capitalize: Bool = false
    ) -> Self
    where
        InputFormat.FormatOutput == String,
        Self == CompositeFormatStyle<InputFormat, FirstCharacterFormatStyle>
    {
        let output = FirstCharacterFormatStyle(capitalize: capitalize)
        return CompositeFormatStyle(input: input, output: output)
    }

}


// MARK: - Playgrounds


#Playground("Default") {
    _ = "black quartz".formatted(.firstCharacter)
    _ = "black quartz".formatted(.firstCharacter.capitalized)
    _ = "black quartz".formatted(.firstCharacter(of: .identity, capitalize: true))
}


// MARK: - Previews


#Preview("Snippets") {
    Text("black quartz", format: .firstCharacter)             // Displays "b"
    Text("black quartz", format: .firstCharacter.capitalized) // Displays "B"

    Text("black quartz", format: .firstCharacter.capitalized(true)) // Displays "B"

    Text("black quartz", format: .firstCharacter(of: .lastWord)) // Displays "q"
}
