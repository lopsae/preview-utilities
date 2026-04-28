//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation
import Playgrounds
import SwiftUI


extension FormatStyle {

    @inlinable nonisolated
    public static func fractionLength<Value: BinaryFloatingPoint>(_ length: Int) -> Self
    where Self == FloatingPointFormatStyle<Value>
    {
        .init().precision(.fractionLength(length))
    }

}


// MARK: - Convenience Properties
// Most of these could be defined as functions to allow a single generic implementation for
// `BinaryFloatingPoint`. However, these are kept deliberately as vars to eschew the terminating
// parenthesis of the function call.


extension FormatStyle where Self == FloatingPointFormatStyle<Double> {

    @inlinable nonisolated
    public static var arithmeticRoundedInteger: Self {
        .number.rounded(rule: .toNearestOrEven, increment: 1)
    }

}


extension FormatStyle where Self == FloatingPointFormatStyle<CGFloat> {

    @inlinable nonisolated
    public static var arithmeticRoundedInteger: Self {
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
