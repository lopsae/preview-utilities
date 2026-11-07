//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
@Suite(.snapshotTesting)
struct PathsSnapshots {

    @Test func arrow() {
        let edgesAndColors: [(edge: Edge, color: Color)] = [
            (.top,      .purple),
            (.leading,  .orange),
            (.bottom,   .blue),
            (.trailing, .green),
        ]

        Snapshots.assertView("all") {
            ZStack {
                PathShape { rect in
                    Paths.crosshair(at: rect.centerPoint)
                }
                .stroke(.black)

                let size: CGSize = [60, 40]
                let distance: CGFloat = 16
                let lineWidth: CGFloat = 8

                ForEach(edgesAndColors, id: \.edge) { edge, color in
                    PathShape { rect in
                        Paths.arrow(
                            tip: rect.centerPoint.adding(distance, towards: edge.opposite),
                            towards: edge,
                            size: edge.axis == .horizontal ? size : size.transposed
                        )
                    }
                    .stroke(color, lineWidth: lineWidth)
                }
            }
        } // Snapshot all

        for horizontal in [true, false] {
            let snapshotName = horizontal ? "sizingHorizontal" : "sizingVertical"
            Snapshots.assertView(snapshotName) {
                let baseSize: CGSize = [120, 30]
                let size = horizontal ? baseSize : baseSize.transposed
                let layout = horizontal
                    ? AnyLayout(VStackLayout(spacing: 10))
                    : AnyLayout(HStackLayout(spacing: 10))
                layout {
                    ForEach(edgesAndColors, id: \.edge) { edge, color in
                        PathShape { rect in
                            Paths.arrow(
                                tip: rect.edgeCenterPoint(on: edge),
                                towards: edge,
                                size: rect.size
                            )
                        }
                        .stroke(color, lineWidth: 4)
                        .frame(size: size)
                        .border(color.tertiary)
                    }
                }
            } // // Snapshot sizing...
        } // for
    }

}
