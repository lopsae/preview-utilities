//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


/// A structure that capitalizes a string.
nonisolated
struct CapitalizedFormatStyle: FormatStyle {

    func format(_ value: String) -> String {
        return value.capitalized
    }

}


extension FormatStyle where Self == CapitalizedFormatStyle {

    /// Returns a format style that outputs a capitalized string.
    nonisolated
    static var capitalized: Self { .init() }

}


extension FormatStyle {

    /// Returns a format style that uses the string output of another formatter and outputs the
    /// capitalized string.
    nonisolated
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


nonisolated
extension FormatStyle {

    /// Returns a format style that outputs the capitalized raw value of a `RawRepresentable`.
    nonisolated
    static func rawValueCapitalized<Value: RawRepresentable>() -> Self
    where
        Value.RawValue: StringProtocol,
        Self == CompositeFormatStyle<RawValueFormatStyle<Value>, CapitalizedFormatStyle>
    {
        return .init(input: RawValueFormatStyle(), output: CapitalizedFormatStyle())
    }

}
