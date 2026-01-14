//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


/// A structure that converts a string to its first character, optionally capitalized.
nonisolated
struct FirstCharacterFormatStyle: FormatStyle {

    let capitalized: Bool

    init(capitalized: Bool = false) {
        self.capitalized = capitalized
    }

    func format(_ value: String) -> String {
        let firstCharacted = value.first?.description ?? .init()
        return capitalized
            ? firstCharacted.capitalized
            : firstCharacted
    }

}


extension FormatStyle where Self == FirstCharacterFormatStyle {

    /// Returns a format style that outputs first character of a string.
    nonisolated
    static var firstCharacter: FirstCharacterFormatStyle { .init() }

    /// Returns a format style that outputs first character of a string, optionally capitalized.
    nonisolated
    static func firstCharacter(capitalized: Bool) -> FirstCharacterFormatStyle {
        .init(capitalized: capitalized)
    }

}


extension FormatStyle {

    /// Returns a format style that uses the string output of another formatter and outputs the
    /// first character, optionally capitalized.
    nonisolated
    static func firstCharacter<InputFormat: FormatStyle>(
        capitalized: Bool = false,
        input: InputFormat
    ) -> Self
    where
        InputFormat.FormatOutput == String,
        Self == CompositeFormatStyle<InputFormat, FirstCharacterFormatStyle>
    {
        let output = FirstCharacterFormatStyle(capitalized: capitalized)
        return .init(input: input, output: output)
    }

}
