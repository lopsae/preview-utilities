//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// A structure that capitalizes a string.
nonisolated
struct CapitalizedFormatStyle: FormatStyle, Sendable {

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


nonisolated
extension FormatStyle {

    /// Returns a format style that outputs a capitalized string property from the input object.
    nonisolated
    static func capitalized<Input>(
        property: KeyPath<Input, String> & Sendable
    ) -> Self
    where
        Self == CompositeFormatStyle<PropertyFormatStyle<Input>, CapitalizedFormatStyle>
    {
        return .init(input: PropertyFormatStyle(property), output: CapitalizedFormatStyle())
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    nonisolated
    struct Dummy: RawRepresentable, CustomStringConvertible {
        let value = "instance property"
        let rawValue = "instance raw value"
        init?(rawValue: String) {}
        init() {}
        var description: String { "string description" }
    }

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable let dummy = PreviewContent.Dummy()
    Text("String: `\("lorem ipsum", format: .capitalized)`")
    Text("Raw Value: `\(dummy, format: .rawValueCapitalized())`")
    Text("Property: `\(dummy, format: .capitalized(property: \.value))`")
    Text("Format Input: `\(dummy, format: .capitalized(input: .description()))`")
}

