//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import GeometryAdditions
import SwiftUI
import Testing


@MainActor
struct SegmentSnapshots {

    @Test(.snapshotTesting) func stroke() {
        let lineWidth: CGFloat = 8

        Snapshots.assertView("default") {
            CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                rect.minPoint.segmentToOffset(x: rect.width)
                .stroke(in: context, style: .orange.secondary, lineWidth: lineWidth)
                rect.maxPoint.segmentToOffset(x: -rect.width)
                .stroke(in: context, style: .indigo.secondary, lineWidth: lineWidth)
            }
        }

        Snapshots.assertView("alignedHorizontal") {
            VStack(spacing: lineWidth) {
                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.minPoint.segmentToOffset(x: rect.width)
                    .stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .inside)
                    rect.maxPoint.segmentToOffset(x: -rect.width)
                    .stroke(in: context, style: .indigo.secondary, lineWidth: lineWidth, alignment: .inside)
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.minPoint.segmentToOffset(x: rect.width)
                    .stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .center)
                    rect.maxPoint.segmentToOffset(x: -rect.width)
                    .stroke(in: context, style: .indigo.secondary, lineWidth: lineWidth, alignment: .center)
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.minPoint.segmentToOffset(x: rect.width)
                    .stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .outside)
                    rect.maxPoint.segmentToOffset(x: -rect.width)
                    .stroke(in: context, style: .indigo.secondary, lineWidth: lineWidth, alignment: .outside)
                }
            }
        }

        Snapshots.assertView("alignedVertical") {
            VStack(spacing: lineWidth) {
                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.topTrailingPoint.segmentToOffset(y: rect.height)
                    .stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .inside)
                    rect.bottomLeadingPoint.segmentToOffset(y: -rect.height)
                    .stroke(in: context, style: .indigo.secondary, lineWidth: lineWidth, alignment: .inside)
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.topTrailingPoint.segmentToOffset(y: rect.height)
                    .stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .center)
                    rect.bottomLeadingPoint.segmentToOffset(y: -rect.height)
                    .stroke(in: context, style: .indigo.secondary, lineWidth: lineWidth, alignment: .center)
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.topTrailingPoint.segmentToOffset(y: rect.height)
                    .stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .outside)
                    rect.bottomLeadingPoint.segmentToOffset(y: -rect.height)
                    .stroke(in: context, style: .indigo.secondary, lineWidth: lineWidth, alignment: .outside)
                }
            }
        }
    }

}
