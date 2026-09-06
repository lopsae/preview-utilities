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
                // FIXME: Use CanvasGraticuleForRect.
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
            }
        }
    }

}
