//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


nonisolated
protocol Pathable {

    // TODO: Consider if `path` could be a convenience property that calls add(to) with a new path.
    var path: Path { get }

    func add(to container: inout Path) -> Self

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


/// Alignment options for drawing strokes.
public enum StrokeAlignment {

    /// Draws the stroke inside its path.
    case inner

    /// Draws the stroke centered on its path.
    case center

    /// Draws the stroke outside its path.
    case outer
}
