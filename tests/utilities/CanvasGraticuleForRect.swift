//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities
import SwiftUI
import Testing


struct CanvasGraticuleForRect: View {
    let spacing: CGFloat
    let width: CGFloat
    let rectRenderer: (_ context: inout GraphicsContext, _ rect: CGRect) -> Void


    var body: some View {
        Rectangle()
        .fill(.gray.quinary)
        .frame(size: [width, spacing*6])
        .overlay {
            EdgeGraticule(insetSpacing: spacing, through: 2, outsetSpacing: .zero, through: .zero)
            .stroke(.quaternary)

            .padding(spacing/2)
            Canvas { context, size in
                let insetRect = size.rect().inset(by: spacing*1.5)
                rectRenderer(&context, insetRect)
            }
        }
    }
}


struct CanvasGraticuleForRectTests {

    @Test(.snapshotTesting) func stroke() {
        Snapshots.assertView("sizes", colorSchemes: .all) {
            VStack(spacing: 8) {
                CanvasGraticuleForRect(spacing: 4, width: 80) { context, rect in
                    context.stroke(Path(rect), with: .style(.red), lineWidth: 1)
                }

                CanvasGraticuleForRect(spacing: 8, width: 100) { context, rect in
                    context.stroke(Path(rect), with: .style(.red), lineWidth: 1)
                }

                CanvasGraticuleForRect(spacing: 12, width: 120) { context, rect in
                    context.stroke(Path(rect), with: .style(.red), lineWidth: 1)
                }
            }
        }
    }

}
