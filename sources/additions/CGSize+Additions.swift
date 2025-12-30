//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreGraphics


extension CGSize {

    @inlinable nonisolated
    public init(square side: CGFloat) {
        self.init(width: side, height: side)
    }


    @inlinable nonisolated
    public static func square(of side: CGFloat) -> Self {
        return .init(square: side)
    }


    @inlinable public func setting(
        width newWidth: CGFloat? = nil,
        height newHeight: CGFloat? = nil
    ) -> Self {
        var mutableSize = self
        if let newWidth {  mutableSize.width  = newWidth }
        if let newHeight { mutableSize.height = newHeight }
        return mutableSize
    }

    // TODO: rename to adding
    @inlinable nonisolated
    public func add(width: CGFloat = 0, height: CGFloat = 0) -> Self {
        return .init(width: self.width + width, height: self.height + height)
    }


    /// Returns the lesser of the size components.
    @inlinable nonisolated
    public var min: CGFloat {
        Swift.min(width, height)
    }


    @inlinable nonisolated
    public var toPoint: CGPoint {
        .init(x: width, y: height)
    }


    @inlinable nonisolated
    public func rect(origin: CGPoint = .zero) -> CGRect {
        .init(origin: origin, size: self)
    }


    @inlinable nonisolated
    public func centered(in size: CGSize) -> CGRect {
        let rect = CGRect(origin: .zero, size: size)
        return rect.center(size: self)
    }


    @inlinable nonisolated
    public func centered(in rect: CGRect) -> CGRect {
        rect.center(size: self)
    }

}
