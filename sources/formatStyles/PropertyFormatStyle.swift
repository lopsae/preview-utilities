//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// A format style that returns a string property referenced by a key path.
///
/// - Note: This formatter retrieves a string property for an input object using a key path. Since
/// `KeyPath` cannot be meaningfully encoded or decoded a `Codable` implementation is provided, but
/// a serialization round-trip of this type does is not possible. Encoding stores a dummy value.
/// Decoding will always fail with a `DecodingError.dataCorrupted` error.
nonisolated
struct PropertyFormatStyle<Input>: FormatStyle {
    let property: KeyPath<Input, String>

    func format(_ value: Input) -> String {
        return value[keyPath: property]
    }

    init(_ property: KeyPath<Input, String>) {
        self.property = property
    }

    /// `PropertyFormatStyle` cannot be meaningfully encoded/decoded. This function will always
    /// throw a `DecodingError.dataCorrupted` error.
    init(from decoder: any Decoder) throws {
        throw DecodingError.dataCorrupted(
            .init(codingPath: decoder.codingPath, debugDescription: "PropertyFormatStyle cannot be decoded.")
        )
    }

    /// `PropertyFormatStyle` cannot be meaningfully encoded/decoded. This function stores a dummy
    /// value and succeeds.
    func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode("PropertyFormatStyle")
    }

}


nonisolated
extension FormatStyle {

    /// Returns a format style that outputs the capitalized raw value of a `RawRepresentable`.
    nonisolated
    static func property<Input>(
        _ property: KeyPath<Input, String>
    ) -> Self
    where
        Self == PropertyFormatStyle<Input>
    {
        return .init(property)
    }

}
