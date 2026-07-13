//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Shape with a line drawn along the given axis, in the middle of its bounds.
///
/// The line path extends along the axis in the middle of the shape bounds. The start and end points
/// are offset half the length of the shape bounds across the given axis to accommodate stroke
/// styles like `CGLineCap/round` so that the drawing of the stroke happens entirely within the
/// shape bounds.
///
/// To extend the line path to the edges of the shape, enable ``extendToEdges``.
struct AxialLine: Shape {

    let axis: Axis
    let extendToEdges: Bool

    init(_ axis: Axis, extendToEdges: Bool = false) {
        self.axis = axis
        self.extendToEdges = extendToEdges
    }

    func path(in rect: CGRect) -> Path {
        let halfPerpendicular = rect.size.length(on: axis.orthogonal) / 2
        let distanceToEdge = extendToEdges ? .zero : halfPerpendicular
        let length = rect.size.length(on: axis) - distanceToEdge * 2

        let startPoint = CGPoint(on: axis, along: distanceToEdge, across: halfPerpendicular)
        let endPoint = startPoint.offset(along: axis, by: length)

        var path = Path()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        return path
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
    func length(on axis: Axis) -> CGFloat {
        switch axis {
        case .horizontal:
            width
        case .vertical:
            height
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
    AxialLine(.horizontal)
        .stroke(.red.secondary, lineWidth: 2)
        .frame(height: 10)
        .padding()
        .debugOverlay(.hairline)
    AxialLine(.vertical)
        .stroke(.red.secondary, lineWidth: 2)
        .frame(width: 10)
        .padding()
        .debugOverlay(.hairline)
}


#Preview("StrokeStyle", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    let strokeStyle = StrokeStyle(lineWidth: 40, lineCap: .round)
    AxialLine(.horizontal)
        .stroke(.red.secondary, style: strokeStyle)
        .frame(height: 40)
        .border(.green.tertiary, width: 4)
    AxialLine(.vertical)
        .stroke(.red.secondary, style: strokeStyle)
        .frame(width: 40)
        .border(.green.tertiary, width: 4)
}
