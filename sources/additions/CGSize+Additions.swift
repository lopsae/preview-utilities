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


    @inlinable public func rect(origin: CGPoint = .zero) -> CGRect {
        .init(origin: origin, size: self)
    }


    @inlinable public func centered(in size: CGSize) -> CGRect {
        let rect = CGRect(origin: .zero, size: size)
        return rect.center(size: self)
    }


    @inlinable public func centered(in rect: CGRect) -> CGRect {
        rect.center(size: self)
    }

}
