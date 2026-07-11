//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI

// FIXME: try to make abstraction using axis.


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
