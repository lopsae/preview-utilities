//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


extension Strideable where Stride == Int {

    /// Returns the value of `self` clamped to the given half-open `range`.
    ///
    /// When `range` is an empty range (if `range.lowerBound` and `range.upperBound` are the same)
    /// `range.lowerBound` is always returned.
    ///
    /// - Parameter range: Half-open range to clamp `self` to.
    /// - Returns: The clamped value of `self`.
    @inlinable public func clamped(to range: Range<Self>) -> Self {
        let inclusiveUpperBound = range.upperBound.advanced(by: -1)
        let clampedValue = Swift.max(range.lowerBound, Swift.min(self, inclusiveUpperBound))
        return clampedValue
    }

}
