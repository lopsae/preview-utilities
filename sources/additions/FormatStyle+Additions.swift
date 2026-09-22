//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import Foundation
import Playgrounds
import SwiftUI


extension FormatStyle {

    /// A floating point format style that constrains formatted values to a given number of allowed
    /// digits in the fraction part.
    ///
    /// Shorthand for a `FloatingPointFormatStyle` configured to the given number of fraction length
    /// precision.
    ///
    /// - Parameter length: The number of digits to use when formatting the fraction part of a number.
    /// - Returns: A format style that constrains formatted values to a given number of allowed
    ///   digits in the fraction part.
    @inlinable
    public nonisolated
    static func fractionLength<Value: BinaryFloatingPoint>(_ length: Int) -> Self
    where Self == FloatingPointFormatStyle<Value>
    {
        .init().precision(.fractionLength(length))
    }

}


// MARK: - Convenience Properties

// `arithmeticRoundedInteger` could be defined as functions to allow a single generic implementation
// for `BinaryFloatingPoint`. However, these are kept deliberately as vars to eschew the terminating
// parenthesis of the function call.


extension FormatStyle where Self == FloatingPointFormatStyle<Double> {

    /// A `Double` format style that rounds formatted values to the nearest-or-even integer.
    ///
    /// Shorthand for a `FloatingPointFormatStyle<Double>` configured to round to the nearest-or-even
    /// integer.
    @inlinable
    public nonisolated
    static var arithmeticRoundedInteger: Self {
        .number.rounded(rule: .toNearestOrEven, increment: 1)
    }

}


extension FormatStyle where Self == FloatingPointFormatStyle<CGFloat> {

    /// A `CGFloat` format style that rounds formatted values to the nearest-or-even integer.
    ///
    /// Shorthand for a `FloatingPointFormatStyle<CGFloat>` configured to round to the nearest-or-even
    /// integer.
    @inlinable
    public nonisolated
    static var arithmeticRoundedInteger: Self {
        .init().rounded(rule: .toNearestOrEven, increment: 1)
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var doubleValue: Double = 2.57
    @Previewable @State var cgFloatValue: CGFloat = 5.72

    Text("`Double` Rounded:")
    Text(doubleValue, format: .arithmeticRoundedInteger)

    Text("`Double` Fraction Length:")
    Text(doubleValue, format: .fractionLength(5))

    Slider.captioned(
        "Double Value",
        value: $doubleValue, in: 0...10,
        currentValueFormat: .fractionLength(1),
        boundsValueFormat: .arithmeticRoundedInteger)

    DashedDivider()

    Text("`CGFloat` Rounded:")
    Text(cgFloatValue, format: .arithmeticRoundedInteger)

    Text("`CGFloat` Fraction Length:")
    Text(cgFloatValue, format: .fractionLength(5))

    Slider.captioned(
        "CGFloat Value",
        value: $cgFloatValue, in: 0...10,
        currentValueFormat: .fractionLength(1),
        boundsValueFormat: .arithmeticRoundedInteger)
}


#Playground("StringInterpolation") {
    let doubleValue: Double = 2.575757
    _ = "Formatted Double: \(doubleValue, format: .fractionLength(3))"

    let cgFloatValue: CGFloat = 5.727272
    _ = "Formatted CGFloat: \(cgFloatValue, format: .fractionLength(3))"
}
