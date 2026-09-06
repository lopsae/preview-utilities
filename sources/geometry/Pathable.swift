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


enum StrokeAlignment {
    case inner
    case center
    case outer
}
