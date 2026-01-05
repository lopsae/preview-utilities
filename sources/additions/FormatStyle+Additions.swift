//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


extension FormatStyle where Self == FloatingPointFormatStyle<Double> {

    public static var roundedIntegerToNearestOrEven: FloatingPointFormatStyle<Double> {
        .number.rounded(rule: .toNearestOrEven, increment: 1)
    }


    public static func fractionLength(_ length: Int) -> FloatingPointFormatStyle<Double> {
        .number.precision(.fractionLength(length))
    }

}
