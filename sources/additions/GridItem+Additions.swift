//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension GridItem {

    public static func adaptive(
        minimum: CGFloat,
        maximum: CGFloat = .infinity,
        spacing: CGFloat? = nil,
        alignment: Alignment? = nil
    ) -> Self {
        return .init(
            .adaptive(minimum: minimum, maximum: maximum),
            spacing: spacing,
            alignment: alignment
        )
    }

}
