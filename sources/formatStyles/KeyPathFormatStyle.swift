//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


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
