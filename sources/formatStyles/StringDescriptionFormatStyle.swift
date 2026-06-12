//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Playgrounds
import SwiftUI


/// A format style that outputs the string description of the input.
///
/// Use this format style through the `FormatStyle` extension ``Foundation/FormatStyle/description()``:
///
/// ```swift
/// nonisolated struct Sphinx: Equatable {
///     let material = "quartz"
/// }
/// Text(Sphinx(), format: .description()) // Displays "Sphinx(material: "quartz")"
/// ```
///
/// ## Topics
///
/// ### FormatStyle Extensions
/// + ``Foundation/FormatStyle/description()``
///
public nonisolated
struct StringDescriptionFormatStyle<Input>: FormatStyle, Sendable {

    /// Creates format style that outputs the string description of the input.
    public init() { }

    @_documentation(visibility: internal)
    public func format(_ value: Input) -> String {
        String(describing: value)
    }

}


extension FormatStyle {

    /// A format style that outputs the string description of the input.
    ///
    /// ```swift
    /// nonisolated struct Sphinx: Equatable {
    ///     let material = "quartz"
    /// }
    /// Text(Sphinx(), format: .description()) // Displays "Sphinx(material: "quartz")"
    /// ```
    ///
    /// - Returns: A ``StringDescriptionFormatStyle`` that outputs the string description of the
    ///   input.
    public nonisolated
    static func description<Input>() -> Self
    where
        Self == StringDescriptionFormatStyle<Input>
    {
        return StringDescriptionFormatStyle()
    }

}


// MARK: - PreviewContent


private typealias Sphinx = FormatStyleExamples.Sphinx


// MARK: - Playgrounds


#Playground("Default") {
    _ = Sphinx().formatted(.description())
    _ = 987.formatted(.description())
    _ = 1.2345.formatted(.description())
}


// MARK: - Previews


#Preview("Snippets", traits: .sizeThatFitsLayout) {
    Text(Sphinx(), format: .description()) // Displays "Sphinx(material: "quartz")"
    .padding()
}
