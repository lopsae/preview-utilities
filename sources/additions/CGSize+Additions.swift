//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreGraphics


extension CGSize {

    public init(square side: CGFloat) {
        self.init(width: side, height: side)
    }


    public func add(width: CGFloat = 0, height: CGFloat = 0) -> Self {
        return .init(width: self.width + width, height: self.height + height)
    }


    /// Returns the lesser of the size components.
    @inlinable public var min: CGFloat {
        Swift.min(width, height)
    }


    @inlinable public var toPoint: CGPoint {
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
