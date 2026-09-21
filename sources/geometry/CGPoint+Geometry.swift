//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import CoreFoundation
public import GeometryAdditions


extension CGPoint {

    // FIXME: Add documentation.

    @inlinable nonisolated
    public func segmentToOffset(x: CGFloat = .zero, y: CGFloat = .zero) -> Segment {
        .init(start: self, end: self.offset(x: x, y: y))
    }

}
