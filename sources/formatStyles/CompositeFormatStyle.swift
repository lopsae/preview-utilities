//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import Foundation
import Playgrounds
import SwiftUI


/// A format style that joins two format styles.
///
/// The `CompositeFormatStyle` joins two format styles into a single one, routing the input data
/// into the input format style, and then through the output format style.
///
/// Apply this style using the static function ``Foundation/FormatStyle/composite(input:output:)``:
///
/// ```swift
/// // Displays "Quartz"
/// Text("black quartz", format: .composite(input: .lastWord, output: .capitalize))
/// ```
///
/// Or the instance function ``Foundation/FormatStyle/then(_:)``:
///
/// ```swift
/// // Displays "Rose"
/// Text("rose quartz", format: .firstWord.then(.capitalize))
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
    /// Returns a ``CompositeFormatStyle`` that joins two format styles into a single one. The input
    /// data is routed into the input format style, and then through the output
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
    /// - Returns: A `CompositeFormatStyle` configured with the given input and output styles.
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


extension FormatStyle {
    
    /// Joins `self` with another format style.
    ///
    /// Returns a ``CompositeFormatStyle`` that joins `self` with another format style. The output
    /// of self is formatted through the output format style.
    ///
    /// - Parameter outputStyle: The format style that produces the output formatted data.
    /// - Returns: A `CompositeFormatStyle` configured with `self` and the output format style.
    public nonisolated
    func then<OutputStyle: FormatStyle>(_ outputStyle: OutputStyle) -> CompositeFormatStyle<Self, OutputStyle> {
        return CompositeFormatStyle(input: self, output: outputStyle)
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


#Playground("Then") {
    _ = "black quartz".formatted(.firstWord.then(.capitalize))
    _ = "black quartz".formatted(.capitalize.then(.lastWord))
    _ = Sphinx().formatted(.property(\.material).then(.capitalize))
}


// MARK: - Previews


#Preview("Snippets", traits: .sizeThatFitsLayout) {
    // Displays "Quartz"
    Text("black quartz", format: .composite(input: .lastWord, output: .capitalize))

    // Displays "Rose"
    Text("rose quartz", format: .firstWord.then(.capitalize))
}
