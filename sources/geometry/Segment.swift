//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


/// Linear segment between two points.
///
/// Segments represent a line between two points. Use functions like ``stroke(in:style:lineWidth:alignment:)``
/// to draw the segment in a graphics context.
nonisolated
public struct Segment {

    /// The start point.
    public var start: CGPoint

    /// The end point.
    public var end: CGPoint
}


nonisolated
extension Segment: Pathable {
    var path: Path {
        .init { path in
            path.move(to: start)
            path.addLine(to: end)
        }
    }
}


extension Segment {

    /// Draws the aligned stroke in the given graphics context.
    ///
    /// The stroke alignment shifts the line perpendicular to its ``start`` to ``end`` direction:
    /// ``StrokeAlignment/inner`` shifts towards the clockwise side, ``StrokeAlignment/outer``
    /// towards the opposite. This is consistent with the direction of segments produced by
    /// functions like ``CoreFoundation/CGRect/topSegment``.
    ///
    /// - Parameters:
    ///   - context: The graphics context to use for drawing.
    ///   - style: The style of the stroke.
    ///   - lineWidth: The line width of the stroke.
    ///   - alignment: The alignment of the stroke.
    /// - Returns: `self`, unmodified.
    @discardableResult
    nonisolated
    public func stroke(
        in context: GraphicsContext,
        style: some ShapeStyle,
        lineWidth: CGFloat = .one,
        alignment: StrokeAlignment
    ) -> Self {
        let offset = switch alignment {
        case .inner:  lineWidth / 2
        case .center: CGFloat.zero
        case .outer:  -lineWidth / 2
        }

        translatePerpendicular(by: offset)
            .stroke(in: context, style: style, lineWidth: lineWidth)
        return self
    }

}


// MARK: - Transformations


extension Segment {

    /// The segment translated perpendicular to its `start` to `end` direction, clockwise.
    ///
    /// For zero length segments, self is returned unchanged.
    nonisolated
    func translatePerpendicular(by distance: CGFloat) -> Self {
        let delta = start.delta(to: end)
        let length = delta.hypot
        guard length > 0 else { return self }

        // Clockwise perpendicular of (dx, dy) in screen space is (-dy, dx).
        let offsetX = -delta.height / length * distance
        let offsetY = +delta.width  / length * distance

        return Self(
            start: start.offset(x: offsetX, y: offsetY),
            end:     end.offset(x: offsetX, y: offsetY),
        )
    }

}


extension CGPoint {

    nonisolated
    func delta(to other: CGPoint) -> CGSize {
        .init(
            width:  other.x - x,
            height: other.y - y
        )
    }

}


extension CGSize {

    nonisolated
    var hypot: CGFloat {
        CoreGraphics.hypot(width, height)
    }

}
