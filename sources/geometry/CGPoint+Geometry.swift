//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import CoreFoundation
public import GeometryAdditions


extension CGPoint {

    /// Creates a segment from `self` to a point offset by the given coordinate values.
    ///
    /// - Parameters:
    ///   - x: The value to offset the _x_ component of the end point; defaults to zero.
    ///   - y: The value to offset the _y_ component of the end point; defaults to zero.
    /// - Returns: A segment from `self` to the offset end point.
    @inlinable nonisolated
    public func segmentToOffset(x: CGFloat = .zero, y: CGFloat = .zero) -> Segment {
        .init(start: self, end: self.offset(x: x, y: y))
    }

}
