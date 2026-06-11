//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Playgrounds
import SwiftUI


/// A structure that capitalizes an input string.
nonisolated
public struct CapitalizedFormatStyle: FormatStyle, Sendable {

    @_documentation(visibility: internal)
    public func format(_ value: String) -> String {
        return value.capitalized
    }

}


extension FormatStyle where Self == CapitalizedFormatStyle {

    /// Returns a format style that outputs a capitalized string.
    nonisolated
    static var capitalized: Self { .init() }

}


extension FormatStyle {

    /// Returns a format style that first formats the data through an input formatter, and then
    /// capitalizes its output.
    /// - Parameters:
    ///   - input: The format style that produces a string from the input data.
    nonisolated
    public static func capitalized<InputFormat: FormatStyle>(
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

    /// Returns a format style that outputs the capitalized raw value of a `RawRepresentable` with
    /// a string representation.
    nonisolated
    public static func rawValueCapitalized<Value: RawRepresentable>() -> Self
    where
        Value.RawValue: StringProtocol,
        Self == CompositeFormatStyle<RawValueFormatStyle<Value>, CapitalizedFormatStyle>
    {
        return .init(input: RawValueFormatStyle(), output: CapitalizedFormatStyle())
    }

}


nonisolated
extension FormatStyle {

    /// Returns a format style that outputs a capitalized string value retrieved through a key path.
    /// - Parameter property: The key path to a string property to capitalize.
    nonisolated
    public static func capitalized<Input>(
        property: KeyPath<Input, String> & Sendable
    ) -> Self
    where
        Self == CompositeFormatStyle<PropertyFormatStyle<Input>, CapitalizedFormatStyle>
    {
        return .init(input: PropertyFormatStyle(property), output: CapitalizedFormatStyle())
    }

}


// MARK: - PreviewContent


private enum ExampleEnum: String {
    case alfa, bravo, charlie

    func format<Output, Formatter>(_ formatter: Formatter) -> Output
    where
        Formatter: FormatStyle,
        Formatter.FormatInput == Self,
        Formatter.FormatOutput == Output
    {
        formatter.format(self)
    }

}


nonisolated
private struct ExampleStruct {
    let firstString = "first"
    let secondString = "second"
    let thirdInteger: Int = 3
    let fourthInteger: Int = 3

    func format<Output, Formatter>(_ formatter: Formatter) -> Output
    where
        Formatter: FormatStyle,
        Formatter.FormatInput == Self,
        Formatter.FormatOutput == Output
    {
        formatter.format(self)
    }

}


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


// FIXME: Delete previews, playground are enough.
#Preview("Default", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable let dummy = PreviewContent.Dummy()
    Text("String: `\("lorem ipsum", format: .capitalized)`")
    Text("Raw Value: `\(dummy, format: .rawValueCapitalized())`")
    Text("Property: `\(dummy, format: .capitalized(property: \.value))`")
    Text("Input Format: `\(dummy, format: .capitalized(input: .description()))`")
}


// MARK: - Playgrounds


#Playground("Default") {
    _ = "black quartz".formatted(.capitalized)
    _ = "black quartz".formatted(.capitalized(input: .firstCharacter))
    _ = ExampleEnum.alfa.format(.rawValueCapitalized())
    _ = ExampleStruct().format(.capitalized(property: \.firstString))
}

