//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


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
