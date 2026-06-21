//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Playgrounds
import SwiftUI


/// A format style that joins two format styles.
///
/// The `CompositeFormatStyle` joins two format styles into a single one, routing the input data
/// first into the input format style, and then through the output format style.
///
/// Use this format style through the `FormatStyle` extension ``Foundation/FormatStyle/composite(input:output:)``:
///
/// ```swift
/// // Displays "Quartz"
/// Text("black quartz", format: .composite(input: .lastWord, output: .capitalize))
/// ```
///
/// ## Topics
///
/// ### FormatStyle Extensions
/// + ``Foundation/FormatStyle/composite(input:output:)``
///
public nonisolated
struct CompositeFormatStyle<InputStyle, OutputStyle>: FormatStyle, Sendable
where
    InputStyle: FormatStyle & Sendable,
    OutputStyle: FormatStyle & Sendable,
    InputStyle.FormatOutput == OutputStyle.FormatInput
{

    let input: InputStyle
    let output: OutputStyle


    /// Creates format style that joins two format styles.
    public init(input: InputStyle, output: OutputStyle) {
        self.input = input
        self.output = output
    }


    @_documentation(visibility: internal)
    public func format(_ value: InputStyle.FormatInput) -> OutputStyle.FormatOutput {
        let intermediate = input.format(value)
        return output.format(intermediate)
    }

}


extension FormatStyle {

    /// A format style that joins two format styles.
    ///
    /// Returns a ``CompositeFormatStyle`` configured to join two format styles into a single one.
    /// The input data is routed first into the input format style, and then through the output
    /// format style.
    ///
    /// ```swift
    /// // Displays "Quartz"
    /// Text("black quartz", format: .composite(input: .lastWord, output: .capitalize))
    /// ```
    ///
    /// - Parameters:
    ///   - input: The format style that formats the input data first.
    ///   - output: The format style that produces the output with the formatted data.
    /// - Returns: Returns a ``CompositeFormatStyle`` configured with the given input and output
    ///   styles.
    public nonisolated
    static func composite<InputStyle, OutputStyle>(
        input: InputStyle,
        output: OutputStyle
    ) -> Self
    where
        InputStyle: FormatStyle & Sendable,
        OutputStyle: FormatStyle & Sendable,
        InputStyle.FormatOutput == OutputStyle.FormatInput,
        Self == CompositeFormatStyle<InputStyle, OutputStyle>
    {
        return CompositeFormatStyle(input: input, output: output)
    }

}


// MARK: - PreviewContent


private typealias Sphinx = FormatStyleExamples.Sphinx


// MARK: - Playgrounds


#Playground("Default") {
    _ = "black quartz".formatted(.composite(input: .identity, output: .capitalize))
    _ = "black quartz".formatted(.composite(input: .lastWord, output: .firstCharacter))
    _ = Sphinx().formatted(.composite(input: .property(\.material), output: .capitalize))
}


// MARK: - Previews


#Preview("Snippets", traits: .sizeThatFitsLayout) {
    // Displays "Quartz"
    Text("black quartz", format: .composite(input: .lastWord, output: .capitalize))
    .padding()
}
