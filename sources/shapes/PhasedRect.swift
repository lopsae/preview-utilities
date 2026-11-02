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

        PathShape { [phase, inset, lineWidth] rect in
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
    init(on axis: Axis, along: CGFloat, across: CGFloat) {
        switch axis {
        case .horizontal: self.init(x: along,  y: across)
        case .vertical:   self.init(x: across, y: along)
        }
    }


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


    // Adds towards a given edge.
    //
    // Orthogonal adds towards the next clockwise edge. For example adding towards `trailing`,
    // adds in the orthogonal direction towards `bottom`.
    nonisolated
    func adding(
        _ value: CGFloat,
        orthogonal: CGFloat = .zero,
        towards edge: Edge
    ) -> Self {
        switch edge {
        case .top:
            self.adding(x: orthogonal, y: -value)
        case .trailing:
            self.adding(x: value, y: orthogonal)
        case .bottom:
            self.adding(x: -orthogonal, y: value)
        case .leading:
            self.adding(x: -value, y: -orthogonal)
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


// FIXME: Move to GeometryAdditions.
extension CGSize {

    nonisolated
    func length(along axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal: width
        case .vertical:   height
        }
    }

}



// FIXME: Move to its own file.
nonisolated
struct PathShape: Shape {

    let pathClosure: @Sendable (CGRect) -> Path

    func path(in rect: CGRect) -> Path { pathClosure(rect) }

}


// FIXME: Move to its own addition.
extension Edge {

    nonisolated
    var opposite: Self {
        switch self {
        case .top:      .bottom
        case .leading:  .trailing
        case .bottom:   .top
        case .trailing: .leading
        }
    }

    nonisolated
    var clockwise: Self {
        switch self {
        case .top:      .trailing
        case .trailing: .bottom
        case .bottom:   .leading
        case .leading:  .top
        }
    }

    nonisolated
    var counterClockwise: Self {
        switch self {
        case .top:      .leading
        case .leading:  .bottom
        case .bottom:   .trailing
        case .trailing: .top
        }
    }

}


// FIXME: Move to its own file.
enum Paths {}


extension Paths {

    nonisolated
    static func arrow(
        tip: CGPoint,
        towards edge: Edge,
        size: CGSize
    ) -> Path {
        let length = size.length(along: edge.axis)
        let width = size.length(along: edge.axis.orthogonal) / 2

        var path = Path()
        // FIXME: Dry this code.

        switch edge {
        case .top:
            let end = tip.adding(length, towards: edge.opposite)

            let wingClock   = tip.adding(width, orthogonal: +width, towards: edge.clockwise)
            let wingCounter = tip.adding(width, orthogonal: -width, towards: edge.counterClockwise)

            tip.segmentTo(point: end).add(to: &path)
            path.move(to: wingCounter)
            path.addLine(to: tip)
            path.addLine(to: wingClock)

            // FIXME: Add [CGPoint] as pathable.
//            [wingCounter, point, wingClock].add(to: &path)

        case .bottom:
            let end = tip.adding(-length, along: .vertical)
            tip.segmentTo(point: end).add(to: &path)
            let wingOne = tip.adding(-width, orthogonal: +width, along: .vertical)
            let wingTwo = tip.adding(-width, orthogonal: -width, along: .vertical)
            tip.segmentTo(point: wingOne).add(to: &path)
            tip.segmentTo(point: wingTwo).add(to: &path)
        case .leading:
            let end = tip.adding(length, along: .horizontal)
            tip.segmentTo(point: end).add(to: &path)
            let wingOne = tip.adding(width, orthogonal: +width, along: .horizontal)
            let wingTwo = tip.adding(width, orthogonal: -width, along: .horizontal)
            tip.segmentTo(point: wingOne).add(to: &path)
            tip.segmentTo(point: wingTwo).add(to: &path)
        case .trailing:
            let end = tip.adding(length, towards: edge.opposite)

            let wingClock   = tip.adding(width, orthogonal: +width, towards: edge.clockwise)
            let wingCounter = tip.adding(width, orthogonal: -width, towards: edge.counterClockwise)

            tip.segmentTo(point: end).add(to: &path)
            path.move(to: wingCounter)
            path.addLine(to: tip)
            path.addLine(to: wingClock)
        }

        return path
    }

}


#Preview("Arrow") {
    ZStack {
        PathShape { rect in
            Path(crosshair: rect.centerPoint)
        }
        .stroke(.primary, lineWidth: 2)

        PathShape { rect in
            Paths.arrow(
                tip: rect.centerPoint.adding(y: -10),
                towards: .bottom,
                size: [20, 40]
            )
        }
        .stroke(.blue, lineWidth: 2)

        PathShape { rect in
            Paths.arrow(
                tip: rect.centerPoint.adding(x: 10),
                towards: .leading,
                size: [40, 20]
            )
        }
        .stroke(.orange, lineWidth: 2)

        PathShape { rect in
            Paths.arrow(
                tip: rect.centerPoint.adding(y: 20),
                towards: .top,
                size: [100, 150]
            )
        }
        .stroke(.purple, lineWidth: 16)

        PathShape { rect in
            Paths.arrow(
                tip: rect.centerPoint.adding(x: -20),
                towards: .trailing,
                size: [150, 100]
            )
        }
        .stroke(.green, lineWidth: 16)
    }
}
