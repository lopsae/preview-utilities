//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Line drawn along the given axis, within the bounds of the view.
///
/// This view size expands along the given axis, and takes the line width across.
struct AxialLine<Style: ShapeStyle>: View {

    let axis: Axis
    let style: Style
    let lineWidth: CGFloat
    let lineCap: CGLineCap
    let dash: [CGFloat]
    let dashPhase: CGFloat

    init(
        _ axis: Axis,
        style: Style,
        lineWidth: CGFloat,
        lineCap: CGLineCap = .butt,
        dash: [CGFloat] = [],
        dashPhase: CGFloat = .zero
    ) {
        self.axis = axis
        self.style = style
        self.lineWidth = lineWidth
        self.lineCap = lineCap
        self.dash = dash
        self.dashPhase = dashPhase
    }

    var body: some View {
        let strokeStyle = StrokeStyle(
            lineWidth: lineWidth,
            lineCap: lineCap,
            dash: dash,
            dashPhase: dashPhase
        )
        LineShape(axis, extendToEdges: lineCap.extendsToEdges)
        .stroke(style, style: strokeStyle)
        .frame(length: lineWidth, along: axis.orthogonal)
    }

}


extension AxialLine {

    /// Shape with a line drawn along the given axis, in the middle of its bounds.
    ///
    /// The line path extends along the axis in the middle of the shape bounds. The start and end
    /// points are offset half the length of the shape bounds across the given axis to accommodate
    /// stroke styles like `CGLineCap/round` which drawing extends beyond the end of the path start
    /// and ends. The offset allows the drawing of the stroke happens entirely within the shape
    /// bounds.
    ///
    /// To extend the line path to the edges of the shape, enable ``extendToEdges``.
    struct LineShape: Shape {
        let axis: Axis
        let extendToEdges: Bool

        init(_ axis: Axis, extendToEdges: Bool = false) {
            self.axis = axis
            self.extendToEdges = extendToEdges
        }

        func path(in rect: CGRect) -> Path {
            let halfPerpendicular = rect.size.length(along: axis.orthogonal) / 2
            let distanceToEdge = extendToEdges ? .zero : halfPerpendicular
            let length = rect.size.length(along: axis) - distanceToEdge * 2

            let startPoint = CGPoint(on: axis, along: distanceToEdge, across: halfPerpendicular)
            let endPoint = startPoint.offset(along: axis, by: length)

            var path = Path()
            path.move(to: startPoint)
            path.addLine(to: endPoint)
            return path
        }
    }

}


private extension CGPoint {

    nonisolated
    init(on axis: Axis, along: CGFloat, across: CGFloat) {
        switch axis {
        case .horizontal: self.init(x: along,  y: across)
        case .vertical:   self.init(x: across, y: along)
        }
    }

    nonisolated
    func offset(along axis: Axis, by distance: CGFloat) -> Self {
        switch axis {
        case .horizontal: self.offset(x: distance)
        case .vertical:   self.offset(y: distance)
        }
    }

}


private extension CGSize {

    nonisolated
    func length(along axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal:
            width
        case .vertical:
            height
        }
    }

}


private extension CGLineCap {

    var extendsToEdges: Bool {
        switch self {
        case .butt:   true
        case .round:  false
        case .square: false
        @unknown default: false
        }
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    AxialLine(.horizontal, style: .red.secondary, lineWidth: 2)
    .padding()
    .debugOverlay(.hairline)

    AxialLine(.vertical, style: .red.secondary, lineWidth: 2)
    .padding()
    .debugOverlay(.hairline)
}


#Preview("StrokeStyle", traits: .paddingSpacing, .fixedHeader, PreviewContent.layout) {
    let lineWidth = 40
    AxialLine(.horizontal, style: .red.secondary, lineWidth: 40, lineCap: .butt)
    .floatingCaption("Butt", .colorStyle(.green), .borderWidth(4), .alignment(.outerBottomTrailing))

    AxialLine(.horizontal, style: .red.secondary, lineWidth: 40, lineCap: .round)
    .floatingCaption("Round", .colorStyle(.green), .borderWidth(4), .alignment(.outerBottomTrailing))

    AxialLine(.horizontal, style: .red.secondary, lineWidth: 40, lineCap: .square)
    .floatingCaption("Square", .colorStyle(.green), .borderWidth(4), .alignment(.outerBottomTrailing))

    HStack(spacing: Defaults.padding) {
        AxialLine(.vertical, style: .red.secondary, lineWidth: 40, lineCap: .butt)
        .floatingCaption("Butt", .colorStyle(.green), .borderWidth(4), .alignment(.outerBottom))

        AxialLine(.vertical, style: .red.secondary, lineWidth: 40, lineCap: .round)
        .floatingCaption("Round", .colorStyle(.green), .borderWidth(4), .alignment(.outerBottom))

        AxialLine(.vertical, style: .red.secondary, lineWidth: 40, lineCap: .square)
        .floatingCaption("Square", .colorStyle(.green), .borderWidth(4), .alignment(.outerBottom))
    }
}
