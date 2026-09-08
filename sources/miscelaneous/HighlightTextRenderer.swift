//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


/// Renders contiguous text attributed with `Highlight` through a provided closure.
///
/// Highlights the text attributed with ``Highlight`` by performing the drawing of these text runs
/// through the provided closure. The ``DrawHighlight`` closure is responsible of drawing the
/// highlight effect and the highlighted text runs. The closure's `leadingStart` and `trailingEnd`
/// parameters indicate if the highlight starts or ends on a different line.
///
/// The remaining text runs are drawn unmodified by the instance.
public struct HighlightTextRenderer: TextRenderer {

    public typealias DrawHighlight = (
        _ context: GraphicsContext,
        _ runs: [Text.Layout.Run],
        _ bounds: CGRect,
        _ leadingStart: Bool,
        _ trailingEnd: Bool
    ) -> Void

    let debugRuns: DebugTextRenderer.Configuration
    let drawHighlight: DrawHighlight


    public init(
        debugRuns: DebugTextRenderer.Configuration = .none,
        drawHighlight: @escaping DrawHighlight
    ) {
        self.debugRuns = debugRuns
        self.drawHighlight = drawHighlight
    }


    @_documentation(visibility: internal)
    public func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        // The contiguous attributed runs accumulated for the current highlight.
        var attributedRuns: [AttributedRun] = []
        // The group began as a continuation from a previous line.
        var continuesFromPreviousLine = false
        // Whether we are still on the line where the current group began.
        var hasLineChanged = false

        for line in layout {
            for run in line {
                let attribute = run[Highlight.self]

                // Idle: start a group on an attributed run, otherwise draw the run as-is.
                if attributedRuns.isEmpty {
                    if let attribute {
                        attributedRuns = [AttributedRun(run: run, attribute: attribute)]
                        continuesFromPreviousLine = false
                        hasLineChanged = false
                    } else {
                        draw(run: run, in: context)
                    }
                    continue
                }

                // Still on the start line: keep collecting adjacent attributed runs.
                if !hasLineChanged, let attribute {
                    attributedRuns.append(AttributedRun(run: run, attribute: attribute))
                    continue
                }

                // The group is complete, draw collected highlight.
                drawAttributed(
                    runs: attributedRuns,
                    leadingStart: !continuesFromPreviousLine,
                    trailingEnd: !hasLineChanged,
                    in: context
                )

                if hasLineChanged, let attribute {
                    // Reopen the highlight on next line with the current run.
                    attributedRuns = [AttributedRun(run: run, attribute: attribute)]
                    continuesFromPreviousLine = true
                    hasLineChanged = false
                } else {
                    // Flush collected runs, draw the current regular run.
                    attributedRuns = []
                    continuesFromPreviousLine = false
                    draw(run: run, in: context)
                }
            }

            hasLineChanged = true
        }

        // Flush a highlight that reaches the end of the text with no trailing plain run.
        if attributedRuns.containsAny {
            drawAttributed(
                runs: attributedRuns,
                leadingStart: !continuesFromPreviousLine,
                trailingEnd: true,
                in: context
            )
        }
    }


    private func draw(run: Text.Layout.Run, in context: GraphicsContext) {
        context.draw(run)
        if debugRuns.drawsAny {
            DebugTextRenderer.drawTypographicBounds(run: run, in: context, configuration: debugRuns)
        }
    }


    /// Strokes the capsule behind `attributedRuns` and draws its glyphs on top.
    ///
    /// `leadingStart` indicates the highlight starts on the leading edge, when `false` the
    /// highlight started on a previous line not included in the given runs.
    ///
    /// `trailingEnd` indicates the highlight ends on the trailing edge, when `false` the
    /// highlight ends on a later line not included in the given runs.
    ///
    private func drawAttributed(
        runs attributedRuns: [AttributedRun],
        leadingStart: Bool,
        trailingEnd: Bool,
        in context: GraphicsContext
    ) {
        let runs = attributedRuns.map(\.run)
        // TODO: Bounds could be returned as nil if there are only `widthOnly` highlights.
        guard let bounds = enclosingRect(of: attributedRuns) else {
            context.draw(runs: runs)
            DebugTextRenderer.drawTypographicBounds(runs: runs, in: context, configuration: debugRuns)
            return
        }

        drawHighlight(context, runs, bounds, leadingStart, trailingEnd)

        if debugRuns.drawsAny {
            DebugTextRenderer.drawTypographicBounds(runs: runs, in: context, configuration: debugRuns)
        }
    }
 

    private func enclosingRect(of attributedRuns: [AttributedRun]) -> CGRect? {
        attributedRuns.map(\.contributingRect)
        .reduceElements { partialResult, contributingRect in
            partialResult.envelop(contributingRect)
        }
    }

}


// MARK: - AttributedRun


extension HighlightTextRenderer {

    private struct AttributedRun {
        let run: Text.Layout.Run
        let attribute: Highlight

        /// The rect this run contributes to the highlight.
        ///
        /// Runs marked with `ShapeHighlight/onlyWidth` contribute only their width, but not height,
        /// via their zero-height centerline.
        var contributingRect: CGRect {
            attribute.onlyWidth
                ? run.typographicBounds.rect.horizontalBisector
                : run.typographicBounds.rect
        }
    }

}


// MARK: - Highlight Attribute


extension HighlightTextRenderer {

    public struct Highlight: TextAttribute {
        let onlyWidth: Bool
        public init(onlyWidth: Bool = false) {
            self.onlyWidth = onlyWidth
        }
    }

}


// MARK: - Implementations

extension HighlightTextRenderer {

    typealias PathHighlight = (
        _ bounds: CGRect,
        _ leadingStart: Bool,
        _ trailingEnd: Bool
    ) -> Path


    /// Renders contiguous text attributed with `Highlight` with a path drawn with a dashed stroke
    /// style.
    /// 
    /// Highlights the text attributed with ``Highlight`` with a path in a dashed stroke style. The
    /// ``PathHighlight`` closure provides the path to draw behind the highlighted text. The
    /// closure's `leadingStart` and `trailingEnd` parameters indicate if the highlight starts or
    /// ends on a different line.
    /// 
    /// The remaining text runs are drawn unmodified by the instance.
    ///
    /// - Parameters:
    ///   - pathStyle: <#pathStyle description#>
    ///   - debugRuns: <#debugRuns description#>
    ///   - pathHighlight: <#pathHighlight description#>
    /// - Returns: <#description#>
    static func dashedPath(
        pathStyle: some ShapeStyle = .gray,
        debugRuns: DebugTextRenderer.Configuration = .none,
        pathHighlight: @escaping PathHighlight
    ) -> Self {
        HighlightTextRenderer(
            debugRuns: debugRuns
        ) { context, runs, bounds, leadingStart, trailingEnd in
            let path = pathHighlight(bounds, leadingStart, trailingEnd)
            // TODO: Externalize stroke style.
            let strokeStyle = StrokeStyle(lineWidth: 1.5, dash: [5, 4])
            context.stroke(path, with: .style(pathStyle), style: strokeStyle)

            for run in runs {
                context.draw(run)
            }
        }
    }


    /// Renders contiguous text attributed with `Highlight` with a capsule path in a dashed stroke
    /// style.
    /// 
    /// Highlights the text attributed with ``Highlight`` with a capsule path in a dashed stroke
    /// style.
    ///
    /// - Parameters:
    ///   - style: The shape style to apply to the stroke of the capsule path.
    ///   - debugRuns: The text renderer debug configuration to use, defaults to `none`.
    /// - Returns: A text rendered configured to highlight text with a capsule path in a dashed
    ///   stroke.
    public static func dashedCapsule(
        style: some ShapeStyle = .secondary,
        debugRuns: DebugTextRenderer.Configuration = .none
    ) -> Self {
        HighlightTextRenderer.dashedPath(
            pathStyle: style,
            debugRuns: debugRuns
        ) { bounds, leadingStart, trailingEnd in
            let outset: CGFloat = 3
            let outsetBounds = bounds.outset(by: outset)

            let fullRadius = outsetBounds.height / 2
            let edgeRadius: CGFloat = 3

            let leadingRadius = leadingStart ? fullRadius : edgeRadius
            let trailingRadius = trailingEnd ? fullRadius : edgeRadius

            let shape = UnevenRoundedRectangle(
                topLeadingRadius: leadingRadius,
                bottomLeadingRadius: leadingRadius,
                bottomTrailingRadius: trailingRadius,
                topTrailingRadius: trailingRadius
            )

            return shape.path(in: outsetBounds)
        }
    }

}


// MARK: - LocalizedStringKey Interpolation


extension LocalizedStringKey.StringInterpolation {

    /// Interpolates the given system image and label in a text with the `Highlight` attribute.
    ///
    /// Apply the ``HighlightTextRenderer`` to text using this interpolation to draw the highlight.
    ///
    /// The interpolation uses non-breaking spaces to keep the image and label together, and adds
    /// additional spaces around the highlighted text to account for the highlight spacing.
    public mutating func appendInterpolation(
        highlight systemImage: String,
        label: String? = nil,
        style: some ShapeStyle = .primary,
        breaking: Bool = false
    ) {
        let edgeSpacer = Text(String.narrowNbsp).tracking(1)
        let middleSpacer = label == nil
            ? edgeSpacer
            : Text(String.narrowNbsp)

        let image = Image(systemName: systemImage)
        let imageText = Text("\(edgeSpacer)\(image)")
            .foregroundStyle(style)
            .customAttribute(HighlightTextRenderer.Highlight(onlyWidth: true))

        let middleText = middleSpacer
            .foregroundStyle(style)
            .customAttribute(HighlightTextRenderer.Highlight())

        appendInterpolation(.space)
        appendInterpolation(imageText)
        appendInterpolation(middleText)

        if let label {
            let spacedString = breaking
                ? label
                : label.replacingOccurrences(of: " ", with: String.nbsp)

            let labelText = Text("\(spacedString)\(edgeSpacer)")
                .foregroundStyle(style)
                .customAttribute(HighlightTextRenderer.Highlight())

            appendInterpolation(labelText)
        }

        appendInterpolation(.space)
    }

}


// TODO: move to GeometryAdditions.
extension CGRect {

    mutating func envelop(_ other: CGRect) {
        self = union(other)
    }

    var horizontalBisector: CGRect {
        self.setting(y: minY + height/2, height: .zero)
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var fixedWidth: Double = 400

    Slider.captioned("Fixed Width", value: $fixedWidth, in: 0...400, valueFormat: .arithmeticRoundedInteger)

    DashedDivider()

    let spacer = Text(String.narrowNbsp)//.tracking(2)
    let capsuleImage = Text("\(spacer)\(Image(ImageResource.moduleCatalog(.envelopeOffcenterBadgeBottomTrailing)))")
        .customAttribute(HighlightTextRenderer.Highlight(onlyWidth: true))
    let capsuleText = Text("\(String.narrowNbsp)\("Capsule")\(spacer)")
        .customAttribute(HighlightTextRenderer.Highlight())

    Text("Layout \(capsuleImage)\(capsuleText) Title")
    .font(.title)
    .textRenderer(HighlightTextRenderer.dashedCapsule(debugRuns:.all))
    .frame(width: fixedWidth)
    .floatingCaption("Title Font", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    Text("Layout  \(capsuleImage)\(capsuleText)  Body")
        .textRenderer(HighlightTextRenderer.dashedCapsule())
    .frame(width: fixedWidth)
    .floatingCaption("Body Font", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)
}


#Preview("Interpolation", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var fixedWidth: Double = 400

    Slider.captioned("Fixed Width", value: $fixedWidth, in: 0...400, valueFormat: .arithmeticRoundedInteger)

    DashedDivider()

    Text("Interpolation \(highlight: "ladybug", label: "Ladybug Image") after interpolation.")
    .textRenderer(HighlightTextRenderer.dashedCapsule(style: .teal))
    .frame(width: fixedWidth)
    .floatingCaption("Non-Breaking", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    Text("Interpolation \(highlight: "ladybug", label: "Multiple breaking words", breaking: true) after.")
        .textRenderer(HighlightTextRenderer.dashedCapsule(style: .teal))
    .frame(width: fixedWidth)
    .floatingCaption("Breaking", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    Text("\(highlight: "rectangle.portrait.and.arrow.right", label: "Starting") interpolation at ends \(highlight: "arrowtriangle.left.square", label: "Ending").")
    .textRenderer(HighlightTextRenderer.dashedCapsule(style: .teal))
    .frame(width: fixedWidth)
    .floatingCaption("Start and End", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    Text("Title \(highlight: "ladybug", label: "Ladybug") interpolation.")
    .font(.title)
    .textRenderer(HighlightTextRenderer.dashedCapsule(style: .teal))
    .frame(width: fixedWidth)
    .floatingCaption("Title", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    VisibleSpacer()
    .layoutPriority(-1)
}


#Preview("Styling", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var fixedWidth: Double = 400

    Slider.captioned("Fixed Width", value: $fixedWidth, in: 0...400, valueFormat: .arithmeticRoundedInteger)

    DashedDivider()

    Text("No style \(highlight: "ladybug", label: "Styled Highlight", style: .orange).")
    .textRenderer(HighlightTextRenderer.dashedCapsule(style: .teal))
    .frame(width: fixedWidth)
    .floatingCaption("Styled Highlight", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.vertical)

    DashedDivider()

    Text("Styled text \(highlight: "paintbrush.fill", label: "Inherited") and \(highlight: "paintbrush.pointed.fill", label: "Custom", style: .indigo)  and  \(highlight: "theatermask.and.paintbrush.fill", label: "Hierarchichal", style: .tertiary).")
    .foregroundStyle(.orange)
    .textRenderer(HighlightTextRenderer.dashedCapsule(style: .teal))
    .frame(width: fixedWidth)
    .floatingCaption("Start and End", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.vertical)

    DashedDivider()

    VisibleSpacer()
    .layoutPriority(-1)
}
