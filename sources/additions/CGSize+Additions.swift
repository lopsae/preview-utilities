//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreGraphics


extension CGSize {

    @inlinable nonisolated
    public init(squareOf length: CGFloat) {
        self.init(width: length, height: length)
    }


    @inlinable nonisolated
    public static func square(of length: CGFloat) -> Self {
        .init(squareOf: length)
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


    @inlinable nonisolated
    public func adding(width: CGFloat = .zero, height: CGFloat = .zero) -> Self {
        .init(width: self.width + width, height: self.height + height)
    }


    /// Returns a size that can contain both `self` and the given size.
    ///
    /// The returned size uses the largest of each component from both sizes.
    @inlinable nonisolated
    public func enveloping(_ size: CGSize) -> Self {
        .init(
            width: Swift.max(width, size.width),
            height: Swift.max(height, size.height)
        )
    }


    /// Updates this size to a size that can contain both `self` and the given size.
    ///
    /// The updated size size uses the largest of each component from both sizes.
    @inlinable nonisolated
    public mutating func envelop(_ size: CGSize) {
        width = Swift.max(width, size.width)
        height = Swift.max(height, size.height)
    }


    /// Returns a `CGSize` with each component of `self` rounded to an integral value using the
    /// specified rounding rule.
    @inlinable nonisolated
    public func rounded(_ rule: FloatingPointRoundingRule) -> Self {
        .init(
            width:  width .rounded(rule),
            height: height.rounded(rule)
        )
    }


    /// Returns a `CGSize` with each component of `self` multiplied by `multiplier`.
    @inlinable nonisolated
    func multiplying(by multiplier: CGFloat) -> Self {
        .init(
            width:  width  * multiplier,
            height: height * multiplier
        )
    }


    /// Returns the Hadamart product of `self` and `multiplier`.
    ///
    /// https://en.wikipedia.org/wiki/Hadamard_product_(matrices)
    @inlinable nonisolated
    func hadamart(bySize multiplier: CGSize) -> Self {
        .init(
            width:  width  * multiplier.width,
            height: height * multiplier.height
        )
    }


    // TODO: add tests, include scaling to fill zero sizes.
    @inlinable nonisolated
    public func scaled(toFill size: CGSize) -> Self {
        let fillScale: CGFloat

        if width == .zero {
            if height == .zero { return .zero }
            fillScale = size.height / height
        } else if height == .zero {
            fillScale = size.width / width
        } else {
            fillScale = Swift.max(size.width / width, size.height / height)
        }

        return multiplying(by: fillScale)
    }


    /// Returns the lesser of the size components.
    @inlinable nonisolated
    public var min: CGFloat {
        Swift.min(width, height)
    }


    /// Returns the greater of the size components.
    @inlinable nonisolated
    public var max: CGFloat {
        Swift.max(width, height)
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
