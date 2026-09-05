//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities
import SwiftUI


// FIXME: Add tests.
struct CanvasGraticuleForRect: View {
    let spacing: CGFloat
    let width: CGFloat
    let rectRenderer: /*@escaping*/ (_ context: inout GraphicsContext, _ rect: CGRect) -> Void


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
