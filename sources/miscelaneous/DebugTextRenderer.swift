//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Draws the typographic bounds of every run.
struct DebugTextRenderer: TextRenderer {

    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        for line in layout {
            for run in line {
                Self.drawDebugTypographicBounds(run: run, in: context)
                context.draw(run)
            }
        }
    }


    static func drawDebugTypographicBounds(
        run: Text.Layout.Run,
        in context: GraphicsContext
    ) {
        // FIXME: Make debug configuration with shorthands for .all, .none., .rect, .ascentDecent
        let typo = run.typographicBounds
        let boundsPath = Rectangle().path(in: typo.rect.inset(by: 0.5))
        context.stroke(boundsPath, with: .style(.green.secondary))

        let ascentLine = Path { path in
            path.move(to: typo.origin.offset(x: 1))
            path.addLine(to: typo.origin.offset(x: 1, y: -typo.ascent))
        }
        context.stroke(ascentLine, with: .style(.red.secondary), lineWidth: 2)

        let descentLine = Path { path in
            path.move(to: typo.origin.offset(x: 3))
            path.addLine(to: typo.origin.offset(x: 3, y: typo.descent))
        }
        context.stroke(descentLine, with: .style(.blue.secondary), lineWidth: 2)
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var fixedWidth: Double = 200

    Slider.captioned("Fixed Width", value: $fixedWidth, in: 0...400, valueFormat: .arithmeticRoundedInteger)

    DashedDivider()

    Text(Strings.sphinxOfBlackQuartz)
    .textRenderer(DebugTextRenderer())
    .frame(width: fixedWidth)
    .floatingCaption("Text", .width, .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)
}
