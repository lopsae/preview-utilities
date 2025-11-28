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


    @inlinable func center(size: CGSize) -> CGRect {
        let centeredRect = CGRect(
            x: (self.width - size.width) / 2 + self.origin.x,
            y: (self.height - size.height) / 2 + self.origin.y,
            width: size.width,
            height: size.height
        )
        return centeredRect
    }

}


#if canImport(UIKit)

import UIKit

extension CGRect {

    @inlinable func inset(by value: CGFloat) -> Self {
        inset(by: UIEdgeInsets.all(value))
    }

}

#endif


#if os(macOS)

extension CGRect {

    @inlinable func inset(by value: CGFloat) -> Self {
        self.insetBy(dx: value, dy: value)
    }

}

#endif
