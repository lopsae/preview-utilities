//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import GeometryAdditions
public import CoreFoundation
public import SwiftUI


extension CGRect: Pathable {
    var path: Path { Path(self) }
}


extension CGRect {

    /// Top segment.
    ///
    /// Segment from the top-leading point, to the top-trailing.
    @inlinable nonisolated
    public var topSegment: Segment {
        topLeadingPoint.segmentToOffset(x: width)
    }


    /// Trailing segment.
    ///
    /// Segment from the top-trailing point, to the bottom-trailing.
    @inlinable nonisolated
    public var trailingSegment: Segment {
        topTrailingPoint.segmentToOffset(y: height)
    }


    /// Bottom segment.
    ///
    /// Segment from the bottom-trailing point, to the bottom-leading.
    @inlinable nonisolated
    public var bottomSegment: Segment {
        bottomTrailingPoint.segmentToOffset(x: -width)
    }


    /// Leading segment.
    ///
    /// Segment from the bottom-leading point, to the top-leading.
    @inlinable nonisolated
    public var leadingSegment: Segment {
        bottomLeadingPoint.segmentToOffset(y: -height)
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

    /// Draws the aligned stroke in the given graphics context.
    ///
    /// The drawn rectangle is inset, outset, or drawn as-is depending on the `alignment` parameter,
    /// so that the drawn stroke is exactly inside, outside, or centered in the rectangle path.
    ///
    /// - Parameters:
    ///   - context: The graphics context to use for drawing.
    ///   - style: The style of the stroke.
    ///   - lineWidth: The line width of the stroke.
    ///   - alignment: The alignment of the stroke.
    /// - Returns: `self`, unmodified.
    @discardableResult
    public func stroke(
        in context: GraphicsContext,
        style: some ShapeStyle,
        lineWidth: CGFloat = .one,
        alignment: StrokeAlignment
    ) -> Self {
        let insetRect = switch alignment {
        case .inner:  self.inset(by: lineWidth/2)
        case .center: self
        case .outer:  self.outset(by: lineWidth/2)
        }

        insetRect.stroke(in: context, style: style, lineWidth: lineWidth)
        return self
    }

}
