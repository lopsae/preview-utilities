//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreGraphics
import SwiftUI


extension CGRect {

    @inlinable public func set(
        x newX: CGFloat? = nil,
        y newY: CGFloat? = nil,
        width newWidth: CGFloat? = nil,
        height newHeight: CGFloat? = nil
    ) -> Self {
        var newRect = self
        if let newX { newRect.origin.x = newX }
        if let newY { newRect.origin.y = newY }
        if let newWidth { newRect.size.width  = newWidth }
        if let newHeight { newRect.size.height = newHeight }
        return newRect
    }


    @inlinable public var center: CGPoint {
        size.toPoint
            .times(by: 0.5)
            .offset(by: origin)
    }


    @inlinable public func center(size: CGSize) -> Self {
        let centeredRect = CGRect(
            x: (self.width - size.width) / 2 + self.origin.x,
            y: (self.height - size.height) / 2 + self.origin.y,
            width: size.width,
            height: size.height
        )
        return centeredRect
    }


    @inlinable public func offset(x: CGFloat = 0, y: CGFloat = 0) -> Self {
        self.offsetBy(dx: x, dy: y)
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


// MARK:- Interactions with Path.

extension CGRect {

    @discardableResult
    @inlinable public func addTo(path: inout Path) -> Self {
        path.addRect(self)
        return self
    }

}
