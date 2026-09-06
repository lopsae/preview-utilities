//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


nonisolated
struct Segment {
    var start: CGPoint
    var end: CGPoint
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


nonisolated
extension Segment {

    /// Draws the aligned stroke in the given graphics context.
    ///
    /// The stroke alignment shifts the line perpendicular to its `start` to `end` direction:
    /// `inside` shifts towards the clockwise side, `outside` towards the opposite. This is
    /// consistent with the direction of segments produced by functions like `CGRect/topSegment`.
    @discardableResult
    func stroke(
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

    // FIXME: Move to an operations extension.
    /// The segment translated perpendicular to its `start` to `end` direction, clockwise.
    ///
    /// For zero length segments, self is returned unchanged.
    func translatePerpendicular(by distance: CGFloat) -> Self {
        let dx = end.x - start.x
        let dy = end.y - start.y
        let length = hypot(dx, dy)
        guard length > 0 else { return self }

        // Clockwise perpendicular of (dx, dy) in screen space is (-dy, dx).
        let offsetX = -dy / length * distance
        let offsetY =  dx / length * distance

        // FIXME: use convenience functions after tests.
        return Self(
            start: CGPoint(x: start.x + offsetX, y: start.y + offsetY),
            end:   CGPoint(x: end.x   + offsetX, y: end.y   + offsetY)
        )
    }

}
