//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Rectangle shape with a phased start.
///
/// When a dashed stroke style is used in a regular rectangle, the top-leading corner always
/// shows a gap in the dash pattern, since that is the point the path starts and ends.
///
/// This shape phases the start point in the _y_ component, allowing the dashed pattern to draw
/// property in all corners.
///
/// A positive `phase` value offsets the start point of the rectangle shape along the leading side.
/// The rectangle start point can be phased as much as the rectangle height, larger values result
/// in the rectangle shape starting at the bottom-leading corner.
///
/// Negative `phase` values are ignored, resulting in the rectangle shape starting at the
/// top-leading corner.
nonisolated
struct PhasedRect: InsettableShape {
    let phase: CGFloat
    let inset: CGFloat

    init(phase: CGFloat, inset: CGFloat = .zero) {
        self.phase = phase
        self.inset = inset
    }

    func inset(by amount: CGFloat) -> Self {
        .init(phase: phase, inset: inset + amount)
    }

    func path(in rect: CGRect) -> Path {
        let insetRect = rect.inset(by: inset)

        let yPhased = (insetRect.minY + phase).clamped(to: insetRect.minY...insetRect.maxY)

        var path = Path()
        path.move(to: insetRect.topLeadingPoint.setting(y: yPhased))
        path.addLine(to: insetRect.topLeadingPoint)
        path.addLine(to: insetRect.topTrailingPoint)
        path.addLine(to: insetRect.bottomTrailingPoint)
        path.addLine(to: insetRect.bottomLeadingPoint)
        path.closeSubpath()
        return path
    }

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeaderFooter) {
    @Previewable @State var phase: CGFloat = 10
    @Previewable @State var inset: CGFloat = 4
    @Previewable @State var length: CGFloat = 120
    @Previewable @State var lineWidth: CGFloat = 4

    Slider.captioned(
        "Phase", value: $phase, in: -20...50,
        currentValueFormat: .twoFractionals,
        boundsValueFormat: .arithmeticRoundedInteger
    )

    Slider.captioned(
        "Inset", value: $inset, in: -20...30,
        currentValueFormat: .twoFractionals,
        boundsValueFormat: .arithmeticRoundedInteger
    )

    Slider.captioned(
        "Line Width", value: $lineWidth, in: -20...30,
        currentValueFormat: .twoFractionals,
        boundsValueFormat: .arithmeticRoundedInteger
    )

    Slider.captioned(
        "Length", value: $length, in: 0...200,
        currentValueFormat: .twoFractionals,
        boundsValueFormat: .arithmeticRoundedInteger
    )

    DashedDivider()

    VisibleSpacer()

    ZStack {
        PhasedRect(phase: phase, inset: inset)
        .stroke(.red, style: .dashed(width: lineWidth))

        PathShape { rect in
            let offset: CGFloat = 4 + lineWidth
            let corner = rect.inset(by: inset).topLeadingPoint
            let phasedCorner = corner.adding(x: -offset, y: phase)
            // FIXME: Path for a tiny arrow.
            return .init(crosshair: phasedCorner, length: 6)
        }
        .stroke(.blue, lineWidth: 2)

    }
    .frame(squareOf: length)
    .border(.red.tertiary, width: 1)

    VisibleSpacer()
}


// FIXME: Move to GeometryAdditions
extension CGPoint {

    nonisolated
    func adding(
        _ value: CGFloat,
        orthogonal: CGFloat = .zero,
        along axis: Axis
    ) -> Self {
        switch axis {
        case .horizontal: self.adding(x: value,      y: orthogonal)
        case .vertical:   self.adding(x: orthogonal, y: value)
        }
    }



    nonisolated
    func setting(
        x newX: CGFloat? = nil,
        y newY: CGFloat? = nil,
    ) -> Self {
        var mutablePoint = self
        if let newX { mutablePoint.x = newX }
        if let newY { mutablePoint.y = newY }
        return mutablePoint
    }


    // FIXME: Move to CGPoint+Geometry.
    nonisolated
    func segmentTo(point: CGPoint) -> Segment {
        .init(start: self, end: point)
    }

}


// FIXME: Move to its own file.
nonisolated
struct PathShape: Shape {

    let pathClosure: @Sendable (CGRect) -> Path

    func path(in rect: CGRect) -> Path { pathClosure(rect) }

}


extension Path {

    nonisolated
    init(
        arrowAt point: CGPoint,
        towards edge: Edge,
        size: CGSize
    ) {
        self.init()

        let length = size.length(along: edge.axis)
        let width = size.length(along: edge.axis.orthogonal)

        // FIXME: Dry this code.
        switch edge {
        case .top:
            let end = point.adding(length, along: .vertical)
            point.segmentTo(point: end).add(to: &self)
            let wingOne = point.adding(width/2, orthogonal: +width/2, along: .vertical)
            let wingTwo = point.adding(width/2, orthogonal: -width/2, along: .vertical)
            point.segmentTo(point: wingOne).add(to: &self)
            point.segmentTo(point: wingTwo).add(to: &self)
        case .bottom:
            let end = point.adding(-length, along: .vertical)
            point.segmentTo(point: end).add(to: &self)
            let wingOne = point.adding(-width/2, orthogonal: +width/2, along: .vertical)
            let wingTwo = point.adding(-width/2, orthogonal: -width/2, along: .vertical)
            point.segmentTo(point: wingOne).add(to: &self)
            point.segmentTo(point: wingTwo).add(to: &self)
        case .leading:
            let end = point.adding(length, along: .horizontal)
            point.segmentTo(point: end).add(to: &self)
            let wingOne = point.adding(width/2, orthogonal: +width/2, along: .horizontal)
            let wingTwo = point.adding(width/2, orthogonal: -width/2, along: .horizontal)
            point.segmentTo(point: wingOne).add(to: &self)
            point.segmentTo(point: wingTwo).add(to: &self)
        case .trailing:
            let end = point.adding(-length, along: .horizontal)
            point.segmentTo(point: end).add(to: &self)
            let wingOne = point.adding(-width/2, orthogonal: +width/2, along: .horizontal)
            let wingTwo = point.adding(-width/2, orthogonal: -width/2, along: .horizontal)
            point.segmentTo(point: wingOne).add(to: &self)
            point.segmentTo(point: wingTwo).add(to: &self)
        }

    }

}


#Preview("Arrow") {
    ZStack {
        PathShape { rect in
            Path(crosshair: rect.centerPoint)
        }
        .stroke(.primary, lineWidth: 2)

        PathShape { rect in
            Path(
                arrowAt: rect.centerPoint.adding(y: -10),
                towards: .bottom,
                size: [20, 40]
            )
        }
        .stroke(.blue, lineWidth: 2)

        PathShape { rect in
            Path(
                arrowAt: rect.centerPoint.adding(x: 10),
                towards: .leading,
                size: [40, 20]
            )
        }
        .stroke(.orange, lineWidth: 2)

        PathShape { rect in
            Path(
                arrowAt: rect.centerPoint.adding(y: 10),
                towards: .top,
                size: [20, 40]
            )
        }
        .stroke(.purple, lineWidth: 2)

        PathShape { rect in
            Path(
                arrowAt: rect.centerPoint.adding(x: -10),
                towards: .trailing,
                size: [40, 20]
            )
        }
        .stroke(.green, lineWidth: 2)
    }
}
