//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


/// A structure that converts a string to its first character, optionally capitalized.
struct FirstCharacterFormatStyle: FormatStyle {

    let capitalized: Bool

    init(capitalized: Bool = false) {
        self.capitalized = capitalized
    }

    func format(_ value: String) -> String {
        let firstCharacted = value.first?.description ?? ""
        return capitalized
            ? firstCharacted.capitalized
            : firstCharacted
    }

}


extension FormatStyle where Self == FirstCharacterFormatStyle {

    /// Returns a format style that outputs first character of a string.
    static var firstCharacter: FirstCharacterFormatStyle { .init() }

    /// Returns a format style that outputs first character of a string, optionally capitalized.
    static func firstCharacter(capitalized: Bool) -> FirstCharacterFormatStyle {
        .init(capitalized: capitalized)
    }

}


extension FormatStyle {

    /// Returns a format style that uses the string output of another formatter and outputs the
    /// first character, optionally capitalized.
    static func firstCharacter<InputFormat: FormatStyle>(
        capitalized: Bool = false,
        format inputFormat: InputFormat
    ) -> CompositeFormatStyle<InputFormat, FirstCharacterFormatStyle>
    where
        InputFormat.FormatOutput == String,
        Self == CompositeFormatStyle<InputFormat, FirstCharacterFormatStyle>
    {
        let output = FirstCharacterFormatStyle(capitalized: capitalized)
        return CompositeFormatStyle(input: inputFormat, output: output)
    }

}
