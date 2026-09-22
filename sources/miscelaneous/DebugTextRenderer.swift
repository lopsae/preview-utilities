//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


/// Draws the typographic bounds of every run.
public struct DebugTextRenderer: TextRenderer {

    let configuration: Configuration

    public init(configuration: Configuration = .all) {
        self.configuration = configuration
    }

    @_documentation(visibility: internal)
    public func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        let runs = layout.runs
        context.draw(runs: runs)
        Self.drawTypographicBounds(runs: runs, in: context, configuration: configuration)
    }


    static func drawTypographicBounds(
        run: Text.Layout.Run,
        in context: GraphicsContext,
        configuration: Configuration
    ) {
        let bounds = run.typographicBounds

        if configuration.drawsRect {
            bounds.rect.stroke(
                in: context, style: .green.secondary,
                lineWidth: 1, alignment: .inner
            )
        }

        if configuration.drawsAscent {
            bounds.origin.offset(x: 1)
            .segmentToOffset(y: -bounds.ascent)
            .stroke(in: context, style: .red.secondary, lineWidth: 2)
        }

        if configuration.drawsDescent {
            bounds.origin.offset(x: 3)
            .segmentToOffset(y: bounds.descent)
            .stroke(in: context, style: .blue.secondary, lineWidth: 2)
        }
    }


    static func drawTypographicBounds(
        runs: [Text.Layout.Run],
        in context: GraphicsContext,
        configuration: Configuration
    ) {
        for run in runs {
            drawTypographicBounds(run: run, in: context, configuration: configuration)
        }
    }

}


extension DebugTextRenderer {

    // TODO: Could be an option set.
    public struct Configuration {
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

        var drawsAny: Bool {
            drawsRect || drawsAscent || drawsDescent
        }

        public static let all: Self = .init()
        public static let none: Self = .init(all: false)
        public static let onlyRect: Self = .init(rect: true, ascent: false, descent: false)
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


extension Text.Layout {

    var runs: [Run] {
        flatMap { line in
            line.map { run in run }
        }
    }

}
