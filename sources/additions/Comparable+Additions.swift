//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


extension Comparable {

    /// Returns the value of `self` clamped to the given closed `range`.
    ///
    /// - Parameter range: Closed range to clamp `self` to.
    /// - Returns: The clamped value of `self`.
    @inlinable public func clamped(to range: ClosedRange<Self>) -> Self {
        let clampedValue = Swift.max(range.lowerBound, Swift.min(self, range.upperBound))
        return clampedValue
    }

}
