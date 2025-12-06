//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


extension FormatStyle where Self == FloatingPointFormatStyle<Double> {

    public static var roundedIntegerToNearestOrEven: FloatingPointFormatStyle<Double> {
        .number.rounded(rule: .toNearestOrEven, increment: 1.0)
    }

    // TODO: delete when unused
    public static var integerBankersRounded: FloatingPointFormatStyle<Double> {
        .number.rounded(rule: .toNearestOrEven, increment: 1.0)
    }

}
