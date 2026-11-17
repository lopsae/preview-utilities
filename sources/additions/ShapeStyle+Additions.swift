//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension ShapeStyle where Self == AnyShapeStyle {
    static func `if`(
        _ condition: Bool,
        then trueStyle: some ShapeStyle,
        else falseStyle: some ShapeStyle
    ) -> Self {
        condition ? Self(trueStyle) : Self(falseStyle)
    }
}
