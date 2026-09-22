//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct CGRectPathableSnapshots {

    @Test(.snapshotTesting) func stroke() {
        let lineWidth: CGFloat = 8

        Snapshots.assertView("default") {
            CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                rect.stroke(in: context, style: .green.secondary, lineWidth: lineWidth)
            }
        }

        Snapshots.assertView("aligned") {
            VStack(spacing: lineWidth) {
                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.stroke(
                        in: context, style: .green.secondary,
                        lineWidth: lineWidth, alignment: .inner
                    )
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.stroke(
                        in: context, style: .green.secondary,
                        lineWidth: lineWidth, alignment: .center
                    )
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.stroke(
                        in: context, style: .green.secondary,
                        lineWidth: lineWidth, alignment: .outer
                    )
                }
            } // VStack
        }
    }


    @Test(.snapshotTesting) func edgeStrokes() {
        let lineWidth: CGFloat = 8

        let segmentsKeyPaths: [KeyPath<CGRect, Segment>] = [
            \.topSegment, \.trailingSegment, \.bottomSegment, \.leadingSegment
        ]

        Snapshots.assertView("aligned") {
            VStack(spacing: lineWidth) {
                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    for keyPath in segmentsKeyPaths {
                        rect[keyPath: keyPath].stroke(
                            in: context, style: .green.secondary,
                            lineWidth: lineWidth, alignment: .inner
                        )
                    }
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    for keyPath in segmentsKeyPaths {
                        rect[keyPath: keyPath].stroke(
                            in: context, style: .green.secondary,
                            lineWidth: lineWidth, alignment: .center
                        )
                    }
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    for keyPath in segmentsKeyPaths {
                        rect[keyPath: keyPath].stroke(
                            in: context, style: .green.secondary,
                            lineWidth: lineWidth, alignment: .outer
                        )
                    }
                }
            } // VStack
        }
    }

}
