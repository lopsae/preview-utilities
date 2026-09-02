//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import CoreFoundation


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
