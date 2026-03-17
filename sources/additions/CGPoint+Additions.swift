//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreGraphics


extension CGPoint {

    /// Returns a `CGPoint` with each component of `self` multiplied by `multiplier`.
    @inlinable nonisolated
    func multiplying(by multiplier: CGFloat) -> Self {
        .init(
            x: self.x * multiplier,
            y: self.y * multiplier
        )
    }


    /// Returns the Hadamart product of `self` and `multiplier`.
    ///
    /// https://en.wikipedia.org/wiki/Hadamard_product_(matrices)
    @inlinable nonisolated
    func hadamart(by multiplier: Self) -> Self {
        .init(
            x: self.x * multiplier.x,
            y: self.y * multiplier.y
        )
    }


    /// Returns the Hadamart product of `self` and `multiplier`, where `x` is multiplied by `width`, and `y` by `heigth`.
    ///
    /// https://en.wikipedia.org/wiki/Hadamard_product_(matrices)
    @inlinable nonisolated
    func hadamart(bySize multiplier: CGSize) -> Self {
        .init(
            x: self.x * multiplier.width,
            y: self.y * multiplier.height
        )
    }


    /// Returns `self` offset by the given components.
    @inlinable nonisolated
    func offset(x: CGFloat = .zero, y: CGFloat = .zero) -> Self {
        .init(
            x: self.x + x,
            y: self.y + y
        )
    }


    /// Returns `self` offset by the given `CGPoint`.
    @inlinable nonisolated
    func offset(by other: Self) -> Self {
        .init(
            x: self.x + other.x,
            y: self.y + other.y
        )
    }

}


extension CGPoint: @retroactive ExpressibleByArrayLiteral {

    public init(arrayLiteral elements: CGFloat...) {
        guard elements.count == 2 else {
            fatalError("Array literal expected with exactly two elements, found: \(elements)" )
        }
        self.init(x: elements[0], y: elements[1])
    }

}
