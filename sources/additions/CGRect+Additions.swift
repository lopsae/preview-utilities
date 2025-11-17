//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreGraphics


extension CGRect {

    @inlinable var center: CGPoint {
        size.toPoint
            .times(by: 0.5)
            .offset(by: origin)
    }


    #if os(macOS)
    @inlinable func inset(by value: CGFloat) -> Self {
        self.insetBy(dx: value, dy: value)
    }
    #endif

}
