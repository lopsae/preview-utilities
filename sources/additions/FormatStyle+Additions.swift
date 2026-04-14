//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation
import Playgrounds
import SwiftUI


extension FormatStyle where Self == FloatingPointFormatStyle<Double> {

    @inlinable nonisolated
    public static var arithmeticRoundedInteger: Self {
        .number.rounded(rule: .toNearestOrEven, increment: 1)
    }

    @inlinable nonisolated
    public static func fractionLength(_ length: Int) -> Self {
        .number.precision(.fractionLength(length))
    }

}


extension FormatStyle where Self == FloatingPointFormatStyle<CGFloat> {

    @inlinable nonisolated
    public static var arithmeticRoundedInteger: Self {
        .init().rounded(rule: .toNearestOrEven, increment: 1)
    }

    @inlinable nonisolated
    public static func fractionLength(_ length: Int) -> Self {
        .init().precision(.fractionLength(length))
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
    Text(doubleValue, format: .fractionLength(3))

    Slider.captioned(
        "Double Value",
        value: $doubleValue, in: 0...10,
        currentValueFormat: .fractionLength(1),
        boundsValueFormat: .arithmeticRoundedInteger)

    DashedDivider()

    Text("`CGFloat` Rounded:")
    Text(cgFloatValue, format: .arithmeticRoundedInteger)

    Text("`CGFloat` Fraction Length:")
    Text(cgFloatValue, format: .fractionLength(3))

    Slider.captioned(
        "CGFloat Value",
        value: $cgFloatValue, in: 0...10,
        currentValueFormat: .fractionLength(1),
        boundsValueFormat: .arithmeticRoundedInteger)
}


#Playground("StringInterpolation") {
    let doubleValue: Double = 2.575757
    let doubleString = "Double: \(doubleValue, format: .fractionLength(3))"

    let cgFloatValue: CGFloat = 5.727272
    let cgFloatString = "CGFloat: \(cgFloatValue, format: .fractionLength(3))"
}
