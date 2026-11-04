//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Namespace for custom drawn paths.
enum Paths {}


// MARK: - Arrow


extension Paths {

    nonisolated
    static func arrow(
        tip: CGPoint,
        towards edge: Edge,
        size: CGSize
    ) -> Path {
        let length = size.length(along: edge.axis)
        let width = size.length(along: edge.axis.orthogonal) / 2

        let end = tip.adding(length, towards: edge.opposite)
        let wingClock   = tip.adding(width, orthogonal: +width, towards: edge.rotated)
        let wingCounter = tip.adding(width, orthogonal: -width, towards: edge.counterRotated)

        return .init { path in
            path.addPath(points: tip, end)
            path.addPath(points: wingCounter, tip, wingClock)
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
            Path(crosshair: rect.centerPoint)
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

    // FIXME: Top and bottom arrows have issues.
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


// FIXME: Move to GeometryAdditions.
extension CGRect {

    nonisolated
    func edgeCenterPoint(on edge: Edge) -> CGPoint {
        switch edge {
        case .top:      topCenterPoint
        case .leading:  leadingCenterPoint
        case .bottom:   bottomCenterPoint
        case .trailing: trailingCenterPoint
        }
    }

}

