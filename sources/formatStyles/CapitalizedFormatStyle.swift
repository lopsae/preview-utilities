//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Playgrounds
import SwiftUI


/// A format style that outputs the input capitalized.
///
/// Use this format style through the `FormatStyle` extension ``Foundation/FormatStyle/capitalized``:
///
/// ```swift
/// Text("black quartz", format: .capitalized) // Displays "Black Quartz"
/// ```
///
/// ## Topics
///
/// ### FormatStyle Extensions
/// + ``Foundation/FormatStyle/capitalized``
/// + ``Foundation/FormatStyle/capitalized(input:)``
/// + ``Foundation/FormatStyle/capitalized(property:)``
/// + ``Foundation/FormatStyle/rawValueCapitalized()``
///
nonisolated
public struct CapitalizedFormatStyle: FormatStyle, Sendable {

    @_documentation(visibility: internal)
    public func format(_ value: String) -> String {
        return value.capitalized
    }

}


extension FormatStyle where Self == CapitalizedFormatStyle {

    /// Returns a format style that outputs a capitalized string.
    ///
    /// Returns a ``CapitalizedFormatStyle`` that outputs the input string capitalized.
    ///
    /// ```swift
    /// Text("black quartz", format: .capitalized) // Displays "Black Quartz"
    /// ```
    public nonisolated
    static var capitalized: Self { CapitalizedFormatStyle() }

}

// NEXT: rename to capitalized(of:) and add snippet.
extension FormatStyle {

    /// Returns a composite format style that formats the data with a given formatter and
    /// capitalizes the output.
    ///
    /// Returns a ``CompositeFormatStyle`` configured with the given input format style, and a
    /// ``CapitalizedFormatStyle`` as output.
    ///
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


extension FormatStyle {

    /// Returns a format style that outputs a capitalized string value retrieved through a key path.
    ///
    /// Returns a ``CompositeFormatStyle`` that retrieves a string property through a key path and
    /// formats it with a ``CapitalizedFormatStyle``.
    ///
    /// ```swift
    /// nonisolated struct Sphinx: Equatable {
    ///     let material = "quartz"
    /// }
    /// Text(Sphinx(), format: .capitalized(property: \.material)) // Displays "Quartz"
    /// ```
    ///
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


nonisolated
extension FormatStyle {

    /// Returns a format style that outputs the capitalized raw value of a `RawRepresentable` with
    /// a string representation.
    ///
    /// Returns a ``CompositeFormatStyle`` that retrieves the string raw value of a
    /// `RawRepresentable` and formats it with a ``CapitalizedFormatStyle``.
    ///
    /// ```swift
    /// enum Quartz: String { case black, rose }
    /// Text(Quartz.rose, format: .rawValueCapitalized()) // Displays "Rose"
    /// ```
    nonisolated
    public static func rawValueCapitalized<Value: RawRepresentable>() -> Self
    where
        Value.RawValue: StringProtocol,
        Self == CompositeFormatStyle<RawValueFormatStyle<Value>, CapitalizedFormatStyle>
    {
        return .init(input: RawValueFormatStyle(), output: CapitalizedFormatStyle())
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


// MARK: - Previews

private
nonisolated struct Sphinx: Equatable {
    let material = "quartz"
}

private
enum Quartz: String { case black, rose }

#Preview("Default") {
    Text("black quartz", format: .capitalized) // Displays "Black Quartz"

    Text("black quartz", format: .capitalized(input: .firstWord)) // Displays "Black"

    Text(Sphinx(), format: .capitalized(property: \.material)) // Displays "Quartz"

    Text(Quartz.rose, format: .rawValueCapitalized()) // Displays "Rose"
}

