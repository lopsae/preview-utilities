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
    let strokeStyle: StrokeStyle


    init(
        _ axis: Axis,
        style: Style,
        strokeStyle: StrokeStyle
    ) {
        self.axis = axis
        self.style = style
        self.strokeStyle = strokeStyle
    }

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
        self.strokeStyle = .init(
            lineWidth: lineWidth, lineCap: lineCap,
            dash: dash, dashPhase: dashPhase
        )
    }


    var body: some View {
        LineShape(axis, extendToEdges: strokeStyle.lineCap.extendsToEdges)
        .stroke(style, style: strokeStyle)
        .frame(length: strokeStyle.lineWidth, along: axis.orthogonal)
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
    nonisolated
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


#Preview("Default", traits: .paddingSpacing, .fixedHeaderFooter, PreviewContent.layout) {
    AxialLine(.horizontal, style: .red.secondary, lineWidth: 2)
    .padding()
    .debugGeometry(.hairline)

    AxialLine(.horizontal, style: .red.secondary, lineWidth: 4)
    .padding()
    .debugGeometry(.hairline)

    AxialLine(.horizontal, style: .red.secondary, lineWidth: 8)
    .padding()
    .debugGeometry(.hairline)

    HStack(spacing: SpacingDefaults.padding) {
        AxialLine(.vertical, style: .red.secondary, lineWidth: 2)
        .padding()
        .debugGeometry(.hairline)

        AxialLine(.vertical, style: .red.secondary, lineWidth: 4)
        .padding()
        .debugGeometry(.hairline)

        AxialLine(.vertical, style: .red.secondary, lineWidth: 8)
        .padding()
        .debugGeometry(.hairline)
    }

    VisibleSpacer()
}


#Preview("LineCaps", traits: .spacing(30), .fixedHeaderFooter, PreviewContent.layout) {
    let lineWidth: CGFloat = 40
    ForEach(CGLineCap.allCases) { lineCap in
        AxialLine(.horizontal, style: .red.secondary, lineWidth: lineWidth, lineCap: lineCap)
        .floatingCaption(
            verbatim: lineCap.displayName.capitalized,
            .alignment(.outerBottomTrailing),
            .captionStyle(.green), .borderStyle(.green.tertiary),
            .borderWidth(4)
        )
    }

    // FIXME: Add spacing parameter.
    HStack(CGLineCap.allCases, id: \.self) { lineCap in
        AxialLine(.vertical, style: .red.secondary, lineWidth: lineWidth, lineCap: lineCap)
        .floatingCaption(
            verbatim: lineCap.displayName.capitalized,
            .alignment(.outerBottomTrailing),
            .captionStyle(.green), .borderStyle(.green.tertiary),
            .borderWidth(4)
        )
    }

    VisibleSpacer()
}


#Preview("StrokeStyle", traits: .paddingSpacing, .fixedHeader, PreviewContent.layout) {
    ForEach(CGLineCap.allCases) { lineCap in
        AxialLine(
            .horizontal, style: .red.secondary,
            strokeStyle: .dashed(cap: lineCap)
        )
    }

    let lineWidth: CGFloat = 10
    VStack {
        ForEach(CGLineCap.allCases) { lineCap in
            AxialLine(
                .horizontal, style: .red.secondary,
                strokeStyle: .dashed(width: lineWidth, cap: lineCap)
            )
        }
    }
    .edgeGraticule(insetSpacing: lineWidth, insetCount: 0, .inset(.leading, count: 30))
}


extension StrokeStyle {

    static func dashed(width: CGFloat = 1, cap: CGLineCap = .round) -> Self {
        .init(
            lineWidth: width, lineCap: cap, lineJoin: .round,
            dash: [width*5, width*6], dashPhase: .zero
        )
    }

}


extension CGLineCap {

    var displayName: String {
        switch self {
        case .butt:   "butt"
        case .round:  "round"
        case .square: "square"
        @unknown default:
            "unknown"
        }
    }

}


extension CGLineCap: @retroactive CaseIterable {

    static let allCases: [CGLineCap] = [.butt, .round, .square]

}


// FIXME: Maybe use self identifiable.
private extension ForEach {

    init(
        items: ID...,
        @ContentBuilder content: @escaping (ID) -> Content
    ) where Data == [ID] {
        self.init(items, id: \.self, content: content)
    }

    init(
        _ data: Data,
        @ContentBuilder content: @escaping (Data.Element) -> Content
    ) where
        Data.Element: Hashable,
        Data.Element == ID
    {
        self.init(data, id: \.self, content: content)
    }

}
