//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import GeometryAdditions
import CoreFoundation
import SwiftUI


extension CGRect: Pathable {
    var path: Path { Path(self) }
}


extension CGRect {

    nonisolated
    var topSegment: Segment {
        CGPoint(x: minX, y: minY)
        .segmentToOffset(x: width)
    }

    nonisolated
    var trailingSegment: Segment {
        CGPoint(x: maxX, y: minY)
        .segmentToOffset(y: height)
    }

    nonisolated
    var bottomSegment: Segment {
        CGPoint(x: maxX, y: maxY)
        .segmentToOffset(x: -width)
    }

    nonisolated
    var leadingSegment: Segment {
        CGPoint(x: minX, y: maxY)
        .segmentToOffset(y: -height)
    }

    // TODO: Could be moved to GeometryAdditions.
    nonisolated
    var topCenterPoint: CGPoint {
        .init(x: minX, y: minY)
        .offset(x: width/2)
    }

    // TODO: Could be moved to GeometryAdditions.
    nonisolated
    var leadingCenterPoint: CGPoint {
        .init(x: minX, y: minY)
        .offset(y: height/2)
    }

    nonisolated
    var horizontalBisectorSegment: Segment {
        leadingCenterPoint
        .segmentToOffset(x: width)
    }

    nonisolated
    var verticalBisectorSegment: Segment {
        topCenterPoint
        .segmentToOffset(y: height)
    }

}


extension CGRect {

    @discardableResult
    func stroke(
        in context: GraphicsContext,
        style: some ShapeStyle,
        lineWidth: CGFloat = .one,
        alignment: StrokeAlignment
    ) -> Self {
        let insetRect = switch alignment {
        case .inside:  self.inset(by: lineWidth/2)
        case .center:  self
        case .outside: self.outset(by: lineWidth/2)
        }

        insetRect.stroke(in: context, style: style, lineWidth: lineWidth)
        return self
    }

}


/// FIXME: Move along Pathable.
enum StrokeAlignment {
    case inside
    case center
    case outside
}
