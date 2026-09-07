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
                    .stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .inner)
                    rect.maxPoint.segmentToOffset(x: -rect.width)
                    .stroke(in: context, style: .indigo.secondary, lineWidth: lineWidth, alignment: .inner)
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.minPoint.segmentToOffset(x: rect.width)
                    .stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .center)
                    rect.maxPoint.segmentToOffset(x: -rect.width)
                    .stroke(in: context, style: .indigo.secondary, lineWidth: lineWidth, alignment: .center)
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.minPoint.segmentToOffset(x: rect.width)
                    .stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .outer)
                    rect.maxPoint.segmentToOffset(x: -rect.width)
                    .stroke(in: context, style: .indigo.secondary, lineWidth: lineWidth, alignment: .outer)
                }
            }
        }

        Snapshots.assertView("alignedVertical") {
            VStack(spacing: lineWidth) {
                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.topTrailingPoint.segmentToOffset(y: rect.height)
                    .stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .inner)
                    rect.bottomLeadingPoint.segmentToOffset(y: -rect.height)
                    .stroke(in: context, style: .indigo.secondary, lineWidth: lineWidth, alignment: .inner)
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.topTrailingPoint.segmentToOffset(y: rect.height)
                    .stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .center)
                    rect.bottomLeadingPoint.segmentToOffset(y: -rect.height)
                    .stroke(in: context, style: .indigo.secondary, lineWidth: lineWidth, alignment: .center)
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.topTrailingPoint.segmentToOffset(y: rect.height)
                    .stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .outer)
                    rect.bottomLeadingPoint.segmentToOffset(y: -rect.height)
                    .stroke(in: context, style: .indigo.secondary, lineWidth: lineWidth, alignment: .outer)
                }
            }
        }

        Snapshots.assertView("alignedPositive") {
            VStack(spacing: lineWidth) {
                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    let segment = rect.minPoint
                        .segmentToOffset(x: rect.width, y: lineWidth * 3)
                    segment.stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .inner)
                    segment.stroke(in: context, style: .red.secondary)
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    let segment = rect.minPoint
                        .segmentToOffset(x: rect.width, y: lineWidth * 3)
                    segment.stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .center)
                    segment.stroke(in: context, style: .red.secondary)
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    let segment = rect.minPoint
                        .segmentToOffset(x: rect.width, y: lineWidth * 3)
                    segment.stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .outer)
                    segment.stroke(in: context, style: .red.secondary)
                }
            }
        }

        Snapshots.assertView("alignedNegative") {
            VStack(spacing: lineWidth) {
                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    let segment = rect.minPoint.offset(y: lineWidth * 3)
                        .segmentToOffset(x: rect.width, y: -lineWidth * 3)
                    segment.stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .inner)
                    segment.stroke(in: context, style: .red.secondary)
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    let segment = rect.minPoint.offset(y: lineWidth * 3)
                        .segmentToOffset(x: rect.width, y: -lineWidth * 3)
                    segment.stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .center)
                    segment.stroke(in: context, style: .red.secondary)
                }

                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    let segment = rect.minPoint.offset(y: lineWidth * 3)
                        .segmentToOffset(x: rect.width, y: -lineWidth * 3)
                    segment.stroke(in: context, style: .orange.secondary, lineWidth: lineWidth, alignment: .outer)
                    segment.stroke(in: context, style: .red.secondary)
                }
            }
        }
    }

}
