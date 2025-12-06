//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


extension FormatStyle where Self == FloatingPointFormatStyle<Double> {

    public static var roundedIntegerToNearestOrEven: FloatingPointFormatStyle<Double> {
        .number.rounded(rule: .toNearestOrEven, increment: 1.0)
    }

    public static var integerBankersRounded: FloatingPointFormatStyle<Double> {
        .number.rounded(rule: .toNearestOrEven, increment: 1.0)
    }

}
