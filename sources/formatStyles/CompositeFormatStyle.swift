//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// A Structure that joins two format styles.
nonisolated
public struct CompositeFormatStyle<InputFormat, OutputFormat>: FormatStyle, Sendable
where
    InputFormat: FormatStyle & Sendable,
    OutputFormat: FormatStyle & Sendable,
    InputFormat.FormatOutput == OutputFormat.FormatInput
{

    let input: InputFormat
    let output: OutputFormat

    public func format(_ value: InputFormat.FormatInput) -> OutputFormat.FormatOutput {
        let intermediate = input.format(value)
        return output.format(intermediate)
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    nonisolated
    struct Dummy: CustomStringConvertible {
        var description: String { "description" }
    }

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable let dummy = PreviewContent.Dummy()
    Text("Identity + Capitalized: `\("lorem ipsum", format: CompositeFormatStyle(input: .identity, output: .capitalized))`")
    Text("First Letter + Capitalized: `\("lorem ipsum", format: CompositeFormatStyle(input: .firstCharacter, output: .capitalized))`")
    Text("Description + Capitalized: `\(dummy, format: CompositeFormatStyle(input: .description(), output: .capitalized))`")
}

