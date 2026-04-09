//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation
import SwiftUI


extension FormatStyle where Self == FloatingPointFormatStyle<Double> {

    @inlinable nonisolated
    public static var arithmeticRoundedInteger: FloatingPointFormatStyle<Double> {
        .number.rounded(rule: .toNearestOrEven, increment: 1)
    }

    @inlinable nonisolated
    public static func fractionLength(_ length: Int) -> FloatingPointFormatStyle<Double> {
        .number.precision(.fractionLength(length))
    }

}


extension FormatStyle where Self == FloatingPointFormatStyle<CGFloat> {

    @inlinable nonisolated
    public static var arithmeticRoundedInteger: FloatingPointFormatStyle<CGFloat> {
        Self().rounded(rule: .toNearestOrEven, increment: 1)
    }

    @inlinable nonisolated
    public static func fractionLength(_ length: Int) -> FloatingPointFormatStyle<CGFloat> {
        Self().precision(.fractionLength(length))
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
    @Previewable @State var cgfloatValue: CGFloat = 5.72

    Text("`Double` Rounded: ")
    Text(doubleValue, format: .arithmeticRoundedInteger)

    Text("`Double` Fraction Length: ")
    Text(doubleValue, format: .fractionLength(3))

    Slider.captioned(
        "Double Value",
        value: $doubleValue, in: 0...10,
        currentValueFormat: .fractionLength(1),
        boundsValueFormat: .arithmeticRoundedInteger)

    DashedDivider()

    Text("`CGFloat` Rounded: ")
    Text(cgfloatValue, format: .arithmeticRoundedInteger)

    Text("`CGFloat` Fraction Length: ")
    Text(cgfloatValue, format: .fractionLength(3))

    Slider.captioned(
        "CGFloat Value",
        value: $cgfloatValue, in: 0...10,
        currentValueFormat: .fractionLength(1),
        boundsValueFormat: .arithmeticRoundedInteger)
}
