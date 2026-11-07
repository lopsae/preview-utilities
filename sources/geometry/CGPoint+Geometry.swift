//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import CoreFoundation
public import GeometryAdditions
import SwiftUI


extension CGPoint {

    /// Creates a segment from `self` to a given point.
    ///
    /// - Parameter point: The end point of the segment.
    /// - Returns: A segment from `self` to the given end point.
    @inlinable nonisolated
    public func segmentTo(point: CGPoint) -> Segment {
        .init(start: self, end: point)
    }

    /// Creates a segment from `self` to a point offset by the given coordinate values.
    ///
    /// - Parameters:
    ///   - x: The value to offset the _x_ component of the end point; defaults to zero.
    ///   - y: The value to offset the _y_ component of the end point; defaults to zero.
    /// - Returns: A segment from `self` to the offset end point.
    @inlinable nonisolated
    public func segmentToOffset(x: CGFloat = .zero, y: CGFloat = .zero) -> Segment {
        .init(start: self, end: self.adding(x: x, y: y))
    }

}


nonisolated
extension Array: Pathable where Element == CGPoint {

    var path: Path {
        .init { path in add(to: &path) }
    }

    /// Adds the points to a given path.
    ///
    /// The first point is used to begin a new subpath, and the rest to add lines. The new subpath
    /// is not closed nor ended.
    @discardableResult
    func add(to container: inout Path) -> Array<CGPoint> {
        guard let firstPoint = first else { return self }

        container.move(to: firstPoint)
        self.dropFirst().forEach { point in
            container.addLine(to: point)
        }
        return self
    }

}

extension Path {

    /// Adds the path made by the given points.
    ///
    /// The first point is used to begin a new subpath, and the rest to add lines.
    nonisolated
    mutating func addPath(points: CGPoint...) {
        addPath(points)
    }

}
