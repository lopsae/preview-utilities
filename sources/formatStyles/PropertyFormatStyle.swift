//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import Foundation
import Playgrounds
import SwiftUI


// TODO: add an example of KeyPath conformance to Sendable. The conformance is automatic, but the type
// has to be marked `& Sendable`. See examples here and in the `onGeometryChange<Property>(keyPath:` extension.


/// A format style that outputs a string property retrieved through a key path.
///
/// Use this format style through the `FormatStyle` extension ``Foundation/FormatStyle/property(_:)``:
///
/// ```swift
/// nonisolated struct Sphinx: Equatable {
///     let material = "quartz"
/// }
/// Text(Sphinx(), format: .property(\.material)) // Displays "quartz"
/// ```
///
/// - Note: This type provides a `Codable` conformance, but a serialization round-trip is not
///   possible. The instance stores a `KeyPath` of the property to output, however `KeyPath` cannot
///   be meaningfully encoded or decoded. Encoding stores a dummy value, while Decoding will always
///   fail by throwing `DecodingError.dataCorrupted`.
///
/// ## Topics
///
/// ### FormatStyle Extensions
/// + ``Foundation/FormatStyle/property(_:)``
///
public nonisolated
struct PropertyFormatStyle<Input: Sendable>: FormatStyle, Sendable {

    let property: KeyPath<Input, String> & Sendable


    /// Creates a format style that outputs a string property retrieved through a key path.
    /// - Parameter property: The key path of the string property to output.
    public init(_ property: KeyPath<Input, String> & Sendable) {
        self.property = property
    }


    /// `PropertyFormatStyle` cannot be meaningfully encoded/decoded. This function will always
    /// throw `DecodingError.dataCorrupted`.
    public init(from decoder: any Decoder) throws {
        throw DecodingError.dataCorrupted(
            .init(codingPath: decoder.codingPath, debugDescription: "PropertyFormatStyle cannot be decoded.")
        )
    }


    /// `PropertyFormatStyle` cannot be meaningfully encoded/decoded. This function stores a dummy
    /// value and succeeds.
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode("PropertyFormatStyle")
    }


    @_documentation(visibility: internal)
    public func format(_ value: Input) -> String {
        return value[keyPath: property]
    }

}


nonisolated
extension FormatStyle {

    /// A format style that outputs a string property retrieved through a key path.
    ///
    /// ```swift
    /// nonisolated struct Sphinx: Equatable {
    ///     let material = "quartz"
    /// }
    /// Text(Sphinx(), format: .property(\.material)) // Displays "quartz"
    /// ```
    ///
    /// - Parameter property: The key path of the string property to output.
    /// - Returns: A ``PropertyFormatStyle`` that outputs a string property retrieved through a key
    ///   path.
    public nonisolated
    static func property<Input>(
        _ property: KeyPath<Input, String> & Sendable
    ) -> Self
    where
        Self == PropertyFormatStyle<Input>
    {
        return PropertyFormatStyle(property)
    }

}


// MARK: - PreviewContent


private typealias Sphinx = FormatStyleExamples.Sphinx


// MARK: - Playgrounds


#Playground("Default") {
    _ = Sphinx().formatted(.property(\.material))
}


// MARK: - Previews


#Preview("Snippets", traits: .sizeThatFitsLayout) {
    Text(Sphinx(), format: .property(\.material)) // Displays "quartz"
    .padding()
}
