//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Draws the typographic bounds of every run.
struct DebugTextRenderer: TextRenderer {

    let configuration: Configuration

    init(configuration: Configuration = .all) {
        self.configuration = configuration
    }

    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        for line in layout {
            for run in line {
                Self.drawDebugTypographicBounds(
                    run: run, in: context,
                    configuration: configuration
                )
                context.draw(run)
            }
        }
    }


    static func drawDebugTypographicBounds(
        run: Text.Layout.Run,
        in context: GraphicsContext,
        configuration: Configuration
    ) {
        // FIXME: Make debug configuration with shorthands for .all, .none., .rect, .ascentDecent
        let bounds = run.typographicBounds

        if configuration.drawsRect {
            let rectPath = Rectangle().path(in: bounds.rect.inset(by: 0.5))
            context.stroke(rectPath, with: .style(.green.secondary))
        }

        if configuration.drawsAscent {
            let ascentLine = Path { path in
                path.move(to: bounds.origin.offset(x: 1))
                path.addLine(to: bounds.origin.offset(x: 1, y: -bounds.ascent))
            }
            context.stroke(ascentLine, with: .style(.red.secondary), lineWidth: 2)
        }

        if configuration.drawsDescent {
            let descentLine = Path { path in
                path.move(to: bounds.origin.offset(x: 3))
                path.addLine(to: bounds.origin.offset(x: 3, y: bounds.descent))
            }
            context.stroke(descentLine, with: .style(.blue.secondary), lineWidth: 2)
        }
    }

}


extension DebugTextRenderer {

    struct Configuration {
        var drawsRect: Bool
        var drawsAscent: Bool
        var drawsDescent: Bool

        init(all: Bool = true) {
            self.drawsRect    = all
            self.drawsAscent  = all
            self.drawsDescent = all
        }

        init(rect: Bool, ascent: Bool, descent: Bool) {
            self.drawsRect    = rect
            self.drawsAscent  = ascent
            self.drawsDescent = descent
        }

        static let all: Self = .init()
        static let none: Self = .init(all: false)
        static let onlyRect: Self = .init(rect: true, ascent: false, descent: false)
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
    .floatingCaption("All", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    Text(Strings.sphinxOfBlackQuartz)
        .textRenderer(DebugTextRenderer(configuration: .onlyRect))
    .frame(width: fixedWidth)
    .floatingCaption("Rects", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)
}
