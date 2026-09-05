//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct CGRectPathableSnapshots {

    enum TestContent {
        static let rectangle: some View =
            Rectangle()
            .fill(.gray.quinary)
            .frame(size: [120, 50])
    }


    @Test(.snapshotCapture) func stroke() {
        let lineWidth: CGFloat = 10

        Snapshots.assertView("default") {
            TestContent.rectangle
            .edgeGraticule(insetSpacing: lineWidth, insetCount: 2)
            .overlayCanvas{ context, size in
                size.rect().inset(by: lineWidth)
                .stroke(in: context, style: .green.secondary, lineWidth: lineWidth)
            }
        }

        Snapshots.assertView("aligned") {
            VStack(spacing: lineWidth) {
                // FIXME: Use CanvasGraticuleForRect.
                CanvasGraticuleForRect(spacing: lineWidth, width: 120) { context, rect in
                    rect.stroke(
                        in: context, style: .green.secondary,
                        lineWidth: lineWidth, alignment: .inside
                    )
                }

                TestContent.rectangle
                .edgeGraticule(insetSpacing: lineWidth, insetCount: 2)
                .overlayCanvas{ context, size in
                    size.rect().inset(by: lineWidth)
                    .stroke(in: context, style: .green.secondary, lineWidth: lineWidth, alignment: .center)
                }

                TestContent.rectangle
                .edgeGraticule(insetSpacing: lineWidth, insetCount: 2)
                .overlayCanvas{ context, size in
                    size.rect().inset(by: lineWidth)
                    .stroke(in: context, style: .green.secondary, lineWidth: lineWidth, alignment: .outside)
                }
            }
        }
    }

}


// FIXME: Make a more concise CGRect drawing function.
extension View {

    func overlayCanvas(
        renderer: @escaping (inout GraphicsContext, CGSize) -> Void
    ) -> some View {
        self.overlay {
            Canvas(renderer: renderer)
        }
    }

}
