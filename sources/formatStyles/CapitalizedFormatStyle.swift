//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


/// A structure that capitalizes a string.
struct CapitalizedFormatStyle: FormatStyle {

    func format(_ value: String) -> String {
        return value.capitalized
    }

}


extension FormatStyle {

    /// Returns a format style that uses the string output of another formatter and outputs the
    /// capitalized string.
    static func capitalized<InputFormat: FormatStyle>(
        input: InputFormat
    ) -> Self
    where
        InputFormat.FormatOutput == String,
        Self == CompositeFormatStyle<InputFormat, CapitalizedFormatStyle>
    {
        return .init(input: input, output: CapitalizedFormatStyle())
    }

}
