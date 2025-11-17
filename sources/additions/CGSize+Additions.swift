//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreGraphics


extension CGSize {

    /// Returns the lesser of the size components.
    @inlinable var min: CGFloat {
        Swift.min(width, height)
    }

    @inlinable var toPoint: CGPoint {
        .init(x: width, y: height)
    }

}
