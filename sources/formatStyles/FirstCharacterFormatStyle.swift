//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation
import Playgrounds


/// A structure that converts a string to its first character, optionally capitalized.
///
/// Use this format style through the factory methods ``Foundation/FormatStyle/firstCharacter`` or
/// ``Foundation/FormatStyle/firstCharacterCapitalized``:
///
/// ```swift
/// "black quartz".formatted(.firstCharacter)            // "b"
/// "black quartz".formatted(.firstCharacterCapitalized) // "B"
/// ```
///
/// ## See Also
///
/// + ``Foundation/FormatStyle/firstCharacter``
/// + ``Foundation/FormatStyle/firstCharacterCapitalized``
/// + ``Foundation/FormatStyle/firstCharacter(capitalized:)``
/// + ``Foundation/FormatStyle/firstCharacter(capitalized:input:)``
public nonisolated
struct FirstCharacterFormatStyle: FormatStyle, Sendable {

    let capitalized: Bool


    /// Creates a format style that converts a string to its first character.
    /// - Parameter capitalized: Indicates if the converted string is capitalized; defaults to
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
    public nonisolated
    static var firstCharacter: Self { .init() }

    /// Returns a format style that outputs first character of a string, capitalized.
    public nonisolated
    static var firstCharacterCapitalized: Self {
        .init(capitalized: true)
    }

    /// Returns a format style that outputs first character of a string, optionally capitalized.
    /// - Parameter capitalized: Indicates if the output string is capitalized.
    public nonisolated
    static func firstCharacter(capitalized: Bool) -> Self {
        .init(capitalized: capitalized)
    }

}


extension FormatStyle {

    /// Returns a format style that first formats the data through an input formatter, and then
    /// outputs only the first character optionally capitalized.
    /// - Parameters:
    ///   - capitalized: Indicates if the output string is capitalized.
    ///   - input: The format style that produces a string from the input data.
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


#Playground("Default") {
    _ = "black quartz".formatted(.firstCharacter)
    _ = "black quartz".formatted(.firstCharacterCapitalized)
    _ = "black quartz".formatted(.firstCharacter(capitalized: true, input: .identity))
}
