//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


/// A shape that draws a path provided through a closure.
///
/// The path the shape draws is provided by a closure that receives the rect where the shape will
/// be drawn.
nonisolated
public struct PathShape: Shape {

    /// Closure that receives the shape rect, and returns the path to draw.
    public typealias PathProvider = @Sendable (_ rect: CGRect) -> Path

    /// Closure that receives the shape rect and a mutable empty path that will be drawn.
    public typealias PathMutator = @Sendable (_ rect: CGRect, _ path: inout Path) -> Void

    let pathProvider: PathProvider


    /// Creates a shape that draws the path provided by the given closure.
    ///
    /// - Parameter pathProvider: A closure that receives the shape rect, and returns the path to
    ///   draw.
    public init(pathProvider: @escaping PathProvider) {
        self.pathProvider = pathProvider
    }


    /// Creates a shape that draws the path passed to the given closure.
    ///
    /// - Parameter pathMutator: A closure that receives the shape rect and a mutable empty path
    ///   that will be drawn.
    public init(pathMutator: @escaping PathMutator) {
        self.pathProvider = { rect in
            var path = Path()
            pathMutator(rect, &path)
            return path
        }
    }


    @_documentation(visibility: internal)
    public func path(in rect: CGRect) -> Path { pathProvider(rect) }

}


#Preview("Default", traits: .paddingSpacing) {
    PathShape { rect in
        Paths.arrow(tip: rect.centerPoint, towards: .trailing, size: .square(of: 16))
    }
    .stroke(.red, lineWidth: 2)
    .frame(squareOf: 100)
    .floatingCaption("Path Provider", alignment: .outerBottomTrailing, .colorStyle(.yellow))

    DashedDivider()

    PathShape { rect, path in
        CGSize.square(of: 20).centered(in: rect).addToPath(&path) //.add(to: &path)
    }
    .stroke(.orange, lineWidth: 2)
    .frame(squareOf: 100)
    .floatingCaption("Path Mutator", alignment: .outerBottomTrailing, .colorStyle(.yellow))
}
