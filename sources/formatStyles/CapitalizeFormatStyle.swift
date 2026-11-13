//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import Foundation
import Playgrounds
import SwiftUI


/// A format style that outputs a capitalized string.
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

    /// Creates a format style that outputs a capitalized string.
    public init() {}

    /// Formats a string value, using this style
    /// - Parameter value: The string value to format.
    /// - Returns: A capitalized `value`.
    public func format(_ value: String) -> String {
        return value.capitalized
    }

}


extension FormatStyle where Self == CapitalizeFormatStyle {

    /// Returns a format style that outputs a capitalized string.
    ///
    /// Returns a ``CapitalizeFormatStyle`` that outputs a capitalized string.
    ///
    /// ```swift
    /// Text("black quartz", format: .capitalize) // Displays "Black Quartz"
    /// ```
    nonisolated
    public static var capitalize: Self { CapitalizeFormatStyle() }

}


extension FormatStyle where Self: Sendable, FormatOutput == String {

    /// Capitalizes the output of `self`.
    ///
    /// Returns a ``CompositeFormatStyle`` that joins `self` with ``CapitalizeFormatStyle`` to
    /// capitalize the output of `self`.
    ///
    /// ```swift
    /// Text("rose quartz", format: .firstWord.capitalized) // Displays "Rose"
    /// ```
    nonisolated
    public var capitalized: CompositeFormatStyle<Self, CapitalizeFormatStyle> {
        return CompositeFormatStyle(input: self, output: .capitalize)
    }

}



extension FormatStyle {

    /// Returns a composite format style that formats the data with a given style and capitalizes
    /// the output.
    ///
    /// Returns a ``CompositeFormatStyle`` configured with the given input style, and a
    /// ``CapitalizeFormatStyle`` to capitalize the output.
    ///
    /// ```swift
    /// Text("black quartz", format: .capitalize(.lastWord)) // Displays "Quartz"
    /// ```
    ///
    /// - Parameters:
    ///   - input: The format style that produces a string from the input data.
    nonisolated
    public static func capitalize<InputStyle: FormatStyle>(
        _ input: InputStyle
    ) -> Self
    where
        InputStyle.FormatOutput == String,
        Self == CompositeFormatStyle<InputStyle, CapitalizeFormatStyle>
    {
        return .init(input: input, output: CapitalizeFormatStyle())
    }


    /// Returns a composite format style that outputs a capitalized string value retrieved through a
    /// key path.
    ///
    /// Returns a ``CompositeFormatStyle`` configured to retrieve a string property using a ``PropertyFormatStyle``
    /// and capitalize its output through a ``CapitalizeFormatStyle``.
    ///
    /// ```swift
    /// nonisolated struct Sphinx: Equatable {
    ///     let material = "quartz"
    /// }
    /// Text(Sphinx(), format: .capitalize(property: \.material)) // Displays "Quartz"
    /// ```
    ///
    /// - Parameter property: The key path to a string property to capitalize.
    nonisolated
    public static func capitalize<Input>(
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


#Playground("Capitalized") {
    _ = Sphinx().formatted(.property(\.material).capitalized)
}


// MARK: - Previews


#Preview("Snippets") {
    Text("black quartz", format: .capitalize) // Displays "Black Quartz"

    Text("black quartz", format: .capitalize(.lastWord)) // Displays "Quartz"

    Text("rose quartz", format: .firstWord.capitalized) // Displays "Rose"

    Text(Sphinx(), format: .capitalize(property: \.material)) // Displays "Quartz"
}

