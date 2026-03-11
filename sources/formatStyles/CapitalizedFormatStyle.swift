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


// TODO: Move to its own file.
/// A format style that extracts a string from a value using a key path.
nonisolated
struct KeyPathFormatStyle<Input>: FormatStyle {
    let keyPath: KeyPath<Input, String>

    func format(_ value: Input) -> String {
        return value[keyPath: keyPath]
    }

    // KeyPath is not Codable, so we provide a manual implementation.
    // This type cannot meaningfully round-trip through serialization.

    init(keyPath: KeyPath<Input, String>) {
        self.keyPath = keyPath
    }

    init(from decoder: any Decoder) throws {
        throw DecodingError.dataCorrupted(
            .init(codingPath: decoder.codingPath, debugDescription: "KeyPathFormatStyle cannot be decoded.")
        )
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode("KeyPathFormatStyle")
    }

}


nonisolated
extension FormatStyle {

    /// Returns a format style that outputs the capitalized raw value of a `RawRepresentable`.
    nonisolated
    static func property<Input>(
        _ keyPath: KeyPath<Input, String>
    ) -> Self
    where
        Self == KeyPathFormatStyle<Input>
    {
        return .init(keyPath: keyPath)
    }

}


nonisolated
extension FormatStyle {

    /// Returns a format style that outputs the capitalized raw value of a `RawRepresentable`.
    nonisolated
    static func capitalized<Input>(
        keyPath: KeyPath<Input, String>
    ) -> Self
    where
        Self == CompositeFormatStyle<KeyPathFormatStyle<Input>, CapitalizedFormatStyle>
    {
        return .init(input: KeyPathFormatStyle(keyPath: keyPath), output: CapitalizedFormatStyle())
    }

}
