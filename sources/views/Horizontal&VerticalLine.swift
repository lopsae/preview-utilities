//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI

// FIXME: try to make abstraction using axis.


struct AxialLine: Shape {

    let axis: Axis
    let extendToEdges: Bool

    init(_ axis: Axis, extendToEdges: Bool = false) {
        self.axis = axis
        self.extendToEdges = extendToEdges
    }

    func path(in rect: CGRect) -> Path {
        let halfPerpendicular = rect.size.length(on: axis.perpendicular) / 2
        let distanceToEdge = extendToEdges ? .zero : halfPerpendicular
        let length = rect.size.length(on: axis) - distanceToEdge * 2

        let startPoint = CGPoint(on: axis, distance: distanceToEdge, perpendicular: halfPerpendicular)
        let endPoint = startPoint.offset(on: axis, distance: length)

        var path = Path()
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        return path
    }

}


private extension CGPoint {

    nonisolated
    init(on axis: Axis, distance: CGFloat, perpendicular: CGFloat) {
        switch axis {
        case .horizontal: self.init(x: distance,      y: perpendicular)
        case .vertical:   self.init(x: perpendicular, y: distance)
        }
    }

    nonisolated
    func offset(on axis: Axis, distance: CGFloat) -> Self {
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


/// Shape with a horizontal line drawn in the middle of its bounds.
///
/// The line path extends horizontally in the middle of the shape bounds. The start and end points
/// are offset half height from the edges to accommodate stroke styles like `CGLineCap/round` which
/// draw extending further from the line ends.
///
/// To extend the line path to the edges of the shape, enable ``extendToEdges``.
struct HorizontalLine: Shape {

    let extendToEdges: Bool

    init(extendToEdges: Bool = false) {
        self.extendToEdges = extendToEdges
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let halfHeight =  rect.height/2
        let edge = extendToEdges ? .zero : halfHeight
        path.moveTo(x: edge, y: halfHeight)
        path.addLineTo(x: rect.width - edge, y: halfHeight)
        return path
    }
}


/// Shape with a horizontal line drawn in the middle of its bounds.
///
/// The line path extends vertically in the middle of the shape bounds. The start and end points
/// are offset half height from the edges to accommodate stroke styles like `CGLineCap/round` which
/// draw extending further from the line ends.
///
/// To extend the line path to the edges of the shape, enable ``extendToEdges``.
struct VerticalLine: Shape {

    let extendToEdges: Bool

    init(extendToEdges: Bool = false) {
        self.extendToEdges = extendToEdges
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let halfWidth = rect.width/2
        let edge = extendToEdges ? .zero : halfWidth
        path.moveTo(x: halfWidth, y: edge)
        path.addLineTo(x: halfWidth, y: rect.height - edge)
        return path
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
