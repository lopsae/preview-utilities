//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


nonisolated
protocol Pathable {
    var path: Path { get }
}


nonisolated
extension Pathable {

    @discardableResult
    func add(to container: inout Path) -> Self {
        container.addPath(path)
        return self
    }

    //.stroke(in: context, style: .red.secondary, lineWidth: 2)
    @discardableResult
    func stroke(
        in context: GraphicsContext,
        style: some ShapeStyle,
        lineWidth: CGFloat = .one
    ) -> Self {
        context.stroke(path, with: .style(style), lineWidth: lineWidth)
        return self
    }
}


// TODO: Add Pathable, and make drawing in a context a chained command.
nonisolated
struct Segment {
    var start: CGPoint
    var end: CGPoint
}


nonisolated
extension Segment: Pathable {
    var path: Path {
        .init { path in
            path.move(to: start)
            path.addLine(to: end)
        }
    }
}
