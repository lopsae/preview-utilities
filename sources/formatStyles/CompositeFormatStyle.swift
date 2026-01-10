//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


/// A Structure that joins two format styles.
struct CompositeFormatStyle<InputFormat: FormatStyle, OutputFormat: FormatStyle>: FormatStyle
where InputFormat.FormatOutput == OutputFormat.FormatInput {

    let input: InputFormat
    let output: OutputFormat

    func format(_ value: InputFormat.FormatInput) -> OutputFormat.FormatOutput {
        let intermediate = input.format(value)
        return output.format(intermediate)
    }

}
