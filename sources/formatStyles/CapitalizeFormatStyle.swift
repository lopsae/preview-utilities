//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Playgrounds
import SwiftUI


/// A format style that outputs the input capitalized.
///
/// Use this format style through the `FormatStyle` extension ``Foundation/FormatStyle/capitalize``:
///
/// ```swift
/// Text("black quartz", format: .capitalize) // Displays "Black Quartz"
/// ```
///
/// ## Topics
///
/// ### FormatStyle Extensions
/// + ``Foundation/FormatStyle/capitalize``
/// + ``Foundation/FormatStyle/capitalize(_:)``
/// + ``Foundation/FormatStyle/capitalize(property:)``
///
nonisolated
public struct CapitalizeFormatStyle: FormatStyle, Sendable {

    @_documentation(visibility: internal)
    public func format(_ value: String) -> String {
        return value.capitalized
    }

}


extension FormatStyle where Self == CapitalizeFormatStyle {

    /// Returns a format style that outputs a capitalized string.
    ///
    /// Returns a ``CapitalizeFormatStyle`` that outputs the input string capitalized.
    ///
    /// ```swift
    /// Text("black quartz", format: .capitalize) // Displays "Black Quartz"
    /// ```
    public nonisolated
    static var capitalize: Self { CapitalizeFormatStyle() }

}


extension FormatStyle {

    /// Returns a composite format style that formats the data with a given style and capitalizes
    /// the output.
    ///
    /// Returns a ``CompositeFormatStyle`` configured with the given input style, and a
    /// ``CapitalizeFormatStyle`` to capitalize the output.
    ///
    /// ```swift
    /// Text("black quartz", format: .capitalize(.firstWord)) // Displays "Black"
    /// ```
    ///
    /// - Parameters:
    ///   - input: The format style that produces a string from the input data.
    public nonisolated
    static func capitalize<InputFormat: FormatStyle>(
        _ input: InputFormat
    ) -> Self
    where
        InputFormat.FormatOutput == String,
        Self == CompositeFormatStyle<InputFormat, CapitalizeFormatStyle>
    {
        return .init(input: input, output: CapitalizeFormatStyle())
    }


    /// Returns a composite format style that outputs a capitalized string value retrieved through a
    /// key path.
    ///
    /// Returns a ``CompositeFormatStyle`` configured to retrieve a string property with a ``PropertyFormatStyle``
    /// and capitalize it through a ``CapitalizeFormatStyle``.
    ///
    /// ```swift
    /// nonisolated struct Sphinx: Equatable {
    ///     let material = "quartz"
    /// }
    /// Text(Sphinx(), format: .capitalize(property: \.material)) // Displays "Quartz"
    /// ```
    ///
    /// - Parameter property: The key path to a string property to capitalize.
    public nonisolated
    static func capitalize<Input>(
        property: KeyPath<Input, String> & Sendable
    ) -> Self
    where
        Self == CompositeFormatStyle<PropertyFormatStyle<Input>, CapitalizeFormatStyle>
    {
        return .init(input: PropertyFormatStyle(property), output: CapitalizeFormatStyle())
    }

}


// MARK: - PreviewContent


private typealias Sphinx = FormatStyleExamples.Sphinx
private typealias Quartz = FormatStyleExamples.Quartz


// MARK: - Playgrounds


#Playground("Default") {
    _ = "black quartz".formatted(.capitalize)
    _ = "black quartz".formatted(.capitalize(.firstCharacter))
    _ = Sphinx().formatted(.capitalize(property: \.material))
}


// MARK: - Previews


#Preview("Snippets") {
    Text("black quartz", format: .capitalize) // Displays "Black Quartz"

    Text("black quartz", format: .capitalize(.firstWord)) // Displays "Black"

    Text(Sphinx(), format: .capitalize(property: \.material)) // Displays "Quartz"
}

