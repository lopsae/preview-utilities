//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import GeometryAdditions
public import SwiftUI


extension Path {

    @inlinable nonisolated
    mutating func moveTo(x: CGFloat, y: CGFloat) {
        self.move(to: .init(x: x, y: y))
    }

    @inlinable nonisolated
    mutating func addLineTo(x: CGFloat, y: CGFloat) {
        self.addLine(to: .init(x: x, y: y))
    }

}


extension Path {

    /// Creates a path containing a rectangle.
    @inlinable nonisolated
    public init(rect: CGRect) {
        self.init(rect)
    }


    /// Creates a path containing crosshair at the given point.
    ///
    /// The crosshair total size is a square of `length * 2`.
    ///
    /// - Parameters:
    ///   - point: The center of the crosshair.
    ///   - length: The length of each crosshair arm.
    @inlinable nonisolated
    public init(crosshair point: CGPoint, length: CGFloat = 4) {
        self.init()
        // FIXME: Use segment pathable when exposed.
        let hSegment = point.offset(x: -length).segmentToOffset(x: length*2)
        move(to: hSegment.start)
        addLine(to: hSegment.end)
        let vSegment = point.offset(y: -length).segmentToOffset(y: length*2)
        move(to: vSegment.start)
        addLine(to: vSegment.end)
    }

}
