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
/// + ``Foundation/FormatStyle/capitalized(of:)``
/// + ``Foundation/FormatStyle/capitalized(property:)``
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


extension FormatStyle {

    /// Returns a composite format style that formats the data with a given formatter and
    /// capitalizes the output.
    ///
    /// Returns a ``CompositeFormatStyle`` configured with the given input format style, and a
    /// ``CapitalizedFormatStyle`` as output.
    ///
    /// ```swift
    /// Text("black quartz", format: .capitalized(of: .firstWord)) // Displays "Black"
    /// ```
    ///
    /// - Parameters:
    ///   - input: The format style that produces a string from the input data.
    public nonisolated
    static func capitalized<InputFormat: FormatStyle>(
        of input: InputFormat
    ) -> Self
    where
        InputFormat.FormatOutput == String,
        Self == CompositeFormatStyle<InputFormat, CapitalizedFormatStyle>
    {
        return .init(input: input, output: CapitalizedFormatStyle())
    }


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
    public nonisolated
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


private typealias Sphinx = FormatStyleExamples.Sphinx
private typealias Quartz = FormatStyleExamples.Quartz


// MARK: - Playgrounds


#Playground("Default") {
    _ = "black quartz".formatted(.capitalized)
    _ = "black quartz".formatted(.capitalized(of: .firstCharacter))
    _ = Sphinx().formatted(.capitalized(property: \.material))
}


// MARK: - Previews


#Preview("Snippets") {
    Text("black quartz", format: .capitalized) // Displays "Black Quartz"

    Text("black quartz", format: .capitalized(of: .firstWord)) // Displays "Black"

    Text(Sphinx(), format: .capitalized(property: \.material)) // Displays "Quartz"
}

