//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreGraphics


extension CGPoint {

    // TODO: consider renaming times to multiplying

    /// Returns the a `CGPoint` with each of the component of `self` multiplied by `multiplier`.
    @inlinable nonisolated
    func times(by multiplier: CGFloat) -> Self {
        .init(
            x: self.x * multiplier,
            y: self.y * multiplier
        )
    }


    /// Returns the Hadamart product of `self` and `multiplier`.
    ///
    /// https://en.wikipedia.org/wiki/Hadamard_product_(matrices)
    @inlinable nonisolated
    func times(by multiplier: Self) -> Self {
        .init(
            x: self.x * multiplier.x,
            y: self.y * multiplier.y
        )
    }


    /// Returns the Hadamart product of `self` and `multiplier`, where `x` is multiplied by `width`, and `y` by `heigth`.
    ///
    /// https://en.wikipedia.org/wiki/Hadamard_product_(matrices)
    @inlinable nonisolated
    func times(size multiplier: CGSize) -> Self {
        .init(
            x: self.x * multiplier.width,
            y: self.y * multiplier.height
        )
    }


    /// Returns `self` offset by the given components.
    @inlinable nonisolated
    func offset(x: CGFloat = 0, y: CGFloat = 0) -> Self {
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
