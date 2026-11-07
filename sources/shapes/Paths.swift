//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


/// Namespace for custom drawn paths.
public enum Paths {}


// MARK: - Crosshair


extension Paths {

    /// Creates a path containing a crosshair at the given point.
    ///
    /// The crosshair total size is a square of `length * 2` per side.
    ///
    /// - Parameters:
    ///   - point: The center of the crosshair.
    ///   - length: The length of each crosshair arm.
    nonisolated
    public static func crosshair(at point: CGPoint, length: CGFloat = 4) -> Path {
        return .init { path in
            let hSegment = point.adding(x: -length).segmentToOffset(x: length*2)
            let vSegment = point.adding(y: -length).segmentToOffset(y: length*2)
            path.addPath(hSegment)
            path.addPath(vSegment)
        }

    }

}


// MARK: - Arrow


extension Paths {


    // FIXME: Document and publicize. Remove @Testable from snapshot tests.
    nonisolated
    static func arrow(
        tip: CGPoint,
        towards edge: Edge,
        size: CGSize
    ) -> Path {
        let length = size.length(along: edge.axis)
        let width = size.length(along: edge.axis.orthogonal) / 2
        let boundedWidth = width.clamped(to: ...length)

        let shaftEnd    = tip.adding(length, towards: edge.opposite)
        let wingForward = tip.adding(boundedWidth, orthogonal: +boundedWidth, towards: edge.rotated)
        let wingReverse = tip.adding(boundedWidth, orthogonal: -boundedWidth, towards: edge.counterRotated)

        return .init { path in
            path.addPath(points: tip, shaftEnd)
            path.addPath(points: wingReverse, tip, wingForward)
        }
    }

}


// MARK: - Previews


#Preview("Arrow") {
    let edgesAndColors: [(edge: Edge, color: Color)] = [
        (.top,      .purple),
        (.leading,  .orange),
        (.bottom,   .blue),
        (.trailing, .green),
    ]

    ZStack {
        PathShape { rect in
            Paths.crosshair(at: rect.centerPoint)
        }
        .stroke(.primary, lineWidth: 2)

        let size: CGSize = [150, 100]
        let padding: CGFloat = 20
        let lineWidth: CGFloat = 16

        ForEach(edgesAndColors, id: \.edge) { edge, color in
            PathShape { rect in
                Paths.arrow(
                    tip: rect.centerPoint.adding(padding, towards: edge.opposite),
                    towards: edge,
                    size: edge.axis == .horizontal ? size : size.transposed
                )
            }
            .stroke(color, lineWidth: lineWidth)
        }
    }

    ForEach(edgesAndColors, id: \.edge) { edge, color in
        PathShape { rect, path in
            path = Paths.arrow(
                tip: rect.edgeCenterPoint(on: edge),
                towards: edge,
                size: rect.size
            )
        }
        .stroke(color, lineWidth: 2)
        .frame(size: [100, 40])
        .floatingCaption(verbatim: String(describing: edge), alignment: .outerTrailingBottom, .colorStyle(color))
    }
}
