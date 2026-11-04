//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@_spi(ItemStacks)
@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
@Suite(.snapshotTesting)
struct PhasedRectSnapshots {

    func phaseArrow(phase: CGFloat, lineWidth: CGFloat, inset: CGFloat) -> some View {
        PathShape { [phase, lineWidth] rect in
            let offset: CGFloat = 4 + lineWidth
            let corner = rect.inset(by: inset).topLeadingPoint
            let phasedCorner = corner.adding(x: -offset, y: phase)
            return Paths.arrow(tip: phasedCorner, towards: .trailing, size: .square(of: 10))
        }
        .stroke(.orange, lineWidth: 2)
    }


    @Test func phases() {
        let spacing: CGFloat = 30
        let lineWidth: CGFloat = 4
        let insets: [CGFloat] = [6, 0, -6]
        let size: CGSize = [120, 20]

        Snapshots.assertView("zero") {
            VStack(items: insets, spacing: spacing) { inset in
                let phase: CGFloat = .zero
                TestViews.quinaryGrayRect(size: size)
                .overlay {
                    PhasedRect(phase: phase, inset: inset)
                        .stroke(.green.secondary, style: .dashed(width: lineWidth, dash: 3, space: 3))
                    phaseArrow(phase: phase, lineWidth: lineWidth, inset: inset)
                }
            }
        }

        Snapshots.assertView("middle") {
            VStack(items: insets, spacing: spacing) { inset in
                let phase: CGFloat = (size.height - inset*2) / 2
                TestViews.quinaryGrayRect(size: size)
                .overlay {
                    PhasedRect(phase: phase, inset: inset)
                        .stroke(.green.secondary, style: .dashed(width: lineWidth, dash: 3, space: 3))
                    phaseArrow(phase: phase, lineWidth: lineWidth, inset: inset)
                }
            }
        }

        Snapshots.assertView("negative") {
            VStack(items: insets, spacing: spacing) { inset in
                let phase: CGFloat = -10
                TestViews.quinaryGrayRect(size: size)
                .overlay {
                    PhasedRect(phase: phase, inset: inset)
                        .stroke(.green.secondary, style: .dashed(width: lineWidth, dash: 3, space: 3))
                    phaseArrow(phase: phase, lineWidth: lineWidth, inset: inset)
                }
            }
        }

        Snapshots.assertView("overflow") {
            VStack(items: insets, spacing: spacing) { inset in
                let phase: CGFloat = size.height - inset*2 + 10
                TestViews.quinaryGrayRect(size: size)
                .overlay {
                    PhasedRect(phase: phase, inset: inset)
                        .stroke(.green.secondary, style: .dashed(width: lineWidth, dash: 3, space: 3))
                    phaseArrow(phase: phase, lineWidth: lineWidth, inset: inset)
                }
            }
        }
    }

}
