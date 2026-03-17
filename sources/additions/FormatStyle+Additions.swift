//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


extension FormatStyle where Self == FloatingPointFormatStyle<Double> {

    @inlinable
    public static var arithmeticRoundedInteger: FloatingPointFormatStyle<Double> {
        .number.rounded(rule: .toNearestOrEven, increment: 1)
    }

    @inlinable
    public static func fractionLength(_ length: Int) -> FloatingPointFormatStyle<Double> {
        .number.precision(.fractionLength(length))
    }

}
