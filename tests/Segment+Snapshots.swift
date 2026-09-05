//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct SegmentSnapshots {

    enum TestContent {
        static let rectangle: some View =
            Rectangle()
            .fill(.gray.quinary)
            .frame(size: [120, 50])
    }


    @Test(.snapshotTesting) func stroke() {
        let lineWidth: CGFloat = 10

        // FIXME: Use CanvasGraticuleForRect.
        Snapshots.assertView("default") {
            TestContent.rectangle
            .edgeGraticule(insetSpacing: lineWidth, insetCount: 2)
            .overlayCanvas{ context, size in
                let rect = size.rect().inset(by: lineWidth)
                rect.minPoint.segmentToOffset(x: rect.width)
                .stroke(in: context, style: .green.secondary, lineWidth: lineWidth)

                rect.maxPoint.segmentToOffset(x: -rect.width)
                .stroke(in: context, style: .green.secondary, lineWidth: lineWidth)
            }
        }

        Snapshots.assertView("aligned") {
            VStack(spacing: lineWidth) {
                TestContent.rectangle
                .edgeGraticule(insetSpacing: lineWidth, insetCount: 2)
                .overlayCanvas{ context, size in
                    let rect = size.rect().inset(by: lineWidth)
                    rect.minPoint.segmentToOffset(x: rect.width)
                    .stroke(in: context, style: .green.secondary, lineWidth: lineWidth, alignment: .inside)

                    rect.maxPoint.segmentToOffset(x: -rect.width)
                    .stroke(in: context, style: .green.secondary, lineWidth: lineWidth, alignment: .inside)
                }

                TestContent.rectangle
                .edgeGraticule(insetSpacing: lineWidth, insetCount: 2)
                .overlayCanvas{ context, size in
                    let rect = size.rect().inset(by: lineWidth)
                    rect.minPoint.segmentToOffset(x: rect.width)
                    .stroke(in: context, style: .green.secondary, lineWidth: lineWidth, alignment: .center)

                    rect.maxPoint.segmentToOffset(x: -rect.width)
                    .stroke(in: context, style: .green.secondary, lineWidth: lineWidth, alignment: .center)
                }

                TestContent.rectangle
                .edgeGraticule(insetSpacing: lineWidth, insetCount: 2)
                .overlayCanvas{ context, size in
                    let rect = size.rect().inset(by: lineWidth)
                    rect.minPoint.segmentToOffset(x: rect.width)
                    .stroke(in: context, style: .green.secondary, lineWidth: lineWidth, alignment: .outside)

                    rect.maxPoint.segmentToOffset(x: -rect.width)
                    .stroke(in: context, style: .green.secondary, lineWidth: lineWidth, alignment: .outside)
                }
            }
        }
    }

}


// FIXME: Move to GeometryAdditions.
extension CGRect {

    var minPoint: CGPoint {
        .init(x: minX, y: minY)
    }

    var maxPoint: CGPoint {
        .init(x: maxX, y: maxY)
    }

}
