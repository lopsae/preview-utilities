//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// FIXME: Rename to ShapeHighlightTextRenderer.
// FIXME: Offer typed function for this text renderer.
// FIXME: Color border and text separately.
struct CapsuleHighlightRenderer: TextRenderer {

    let strokeStyle: AnyShapeStyle
    let highlightPath: (_ bounds: CGRect, _ leadingStart: Bool, _ trailingEnd: Bool) -> Path

    private static let strokeStyle = StrokeStyle(lineWidth: 1.5, dash: [5, 4])


    init(
        strokeStyle: some ShapeStyle,
        highlightPath: @escaping (_ bounds: CGRect, _ leadingStart: Bool, _ trailingEnd: Bool) -> Path
    ) {
        self.strokeStyle = AnyShapeStyle(strokeStyle)
        self.highlightPath = highlightPath
    }


    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        // The contiguous attributed runs accumulated for the current highlight.
        var attributedRuns: [AttributedRun] = []
        // The group began as a continuation from a previous line.
        var continuesFromPreviousLine = false
        // Whether we are still on the line where the current group began.
        var hasLineChanged = false

        for line in layout {
            for run in line {
                let attribute = run[ShapeHighlight.self]

                // Idle: start a group on an attributed run, otherwise draw the run as-is.
                if attributedRuns.isEmpty {
                    if let attribute {
                        attributedRuns = [AttributedRun(run: run, attribute: attribute)]
                        continuesFromPreviousLine = false
                        hasLineChanged = false
                    } else {
                        context.draw(run)
                    }
                    continue
                }

                // Still on the start line: keep collecting adjacent attributed runs.
                if !hasLineChanged, let attribute {
                    attributedRuns.append(AttributedRun(run: run, attribute: attribute))
                    continue
                }

                // The group is complete, flush. On a later line, an attributed first run
                // means the highlight continues, so its trailing corners are cut.
                let nextLineAttribute = hasLineChanged ? attribute : nil
                drawHighlight(
                    attributedRuns: attributedRuns,
                    cutLeadingCorners: continuesFromPreviousLine,
                    cutTrailingCorners: hasLineChanged,
                    in: context
                )

                if let nextLineAttribute {
                    // Reopen the highlight on next line with the continuing run.
                    attributedRuns = [AttributedRun(run: run, attribute: nextLineAttribute)]
                    continuesFromPreviousLine = true
                    hasLineChanged = false
                } else {
                    attributedRuns = []
                    continuesFromPreviousLine = false
                    context.draw(run)
                }
            }

            hasLineChanged = true
        }

        // FIXME: Add preview and test.
        // Flush a highlight that reaches the end of the text with no trailing plain run.
        if attributedRuns.containsAny {
            drawHighlight(
                attributedRuns: attributedRuns,
                cutLeadingCorners: continuesFromPreviousLine,
                cutTrailingCorners: false,
                in: context
            )
        }
    }


    /// Strokes the capsule behind `attributedRuns` and draws its glyphs on top. Cut corners
    /// determine the leading and trailing edges of the capsule shape.
    private func drawHighlight(
        attributedRuns: [AttributedRun],
        cutLeadingCorners: Bool,
        cutTrailingCorners: Bool,
        in context: GraphicsContext
    ) {
        guard let bounds = enclosingRect(of: attributedRuns) else { return }

        let path = highlightPath(bounds, !cutLeadingCorners, !cutTrailingCorners)
        context.stroke(path, with: .style(strokeStyle), style: Self.strokeStyle)

        for element in attributedRuns {
            // FIXME: Add property to enable bounds.
            let runRect = element.run.typographicBounds.rect
            let boundsPath = Rectangle().path(in: runRect)
            context.stroke(boundsPath, with: .style(.red.secondary))
            context.draw(element.run)
        }
    }


    private func enclosingRect(of attributedRuns: [AttributedRun]) -> CGRect? {
        attributedRuns.map(\.contributingRect)
        .reduceElements { partialResult, contributingRect in
            partialResult.envelop(contributingRect)
        }
    }

}


extension Sequence {

    // FIXME: Move to Sequence+Additions.
    func reduceElements(
        updateAccumulatingResult: (_ partialResult: inout Element, _ element: Element) throws -> Void
    ) rethrows -> Element? {
        var iterator = makeIterator()
        guard let first = iterator.next() else { return nil }
        let sequence = AnySequence { iterator }
        return try sequence.reduce(into: first, updateAccumulatingResult)
    }

}


// MARK: - AttributedRun


extension CapsuleHighlightRenderer {

    private struct AttributedRun {
        let run: Text.Layout.Run
        let attribute: ShapeHighlight

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


// MARK: - Attribute


extension CapsuleHighlightRenderer {

    struct ShapeHighlight: TextAttribute {
        let onlyWidth: Bool
        init(onlyWidth: Bool = false) {
            self.onlyWidth = onlyWidth
        }
    }

}


// MARK: - Preconfigured

extension CapsuleHighlightRenderer {

    static func capsule(strokeStyle: some ShapeStyle) -> Self {
        CapsuleHighlightRenderer(strokeStyle: strokeStyle) { bounds, leadingStart, trailingEnd in
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

    mutating func appendInterpolation(
        capsule name: String,
        label: String? = nil,
        color: Color = .gray,
        breaking: Bool = false
    ) {
        let edgeSpacer = Text(String.narrowNbsp).tracking(1)
        let middleSpacer = label == nil
            ? edgeSpacer
            : Text(String.narrowNbsp)

        let image = Image(systemName: name)
        let imageText = Text("\(edgeSpacer)\(image)")
            .customAttribute(CapsuleHighlightRenderer.ShapeHighlight(onlyWidth: true))

        let middleText = middleSpacer
            .customAttribute(CapsuleHighlightRenderer.ShapeHighlight())

        appendInterpolation(imageText)
        appendInterpolation(middleText)

        guard let label else { return }

        let spacedString = breaking
            ? label
            : label.replacingOccurrences(of: " ", with: String.nbsp)

        let labelText = Text("\(spacedString)\(edgeSpacer)")
            .customAttribute(CapsuleHighlightRenderer.ShapeHighlight())

        appendInterpolation(labelText)
    }

}


// FIXME: move to GeometryAdditions.
extension CGRect {

    // FIXME: Already exist as union.
    mutating func envelop(_ other: CGRect) {
        self.origin.x = min(origin.x, other.origin.x)
        self.origin.y = min(origin.y, other.origin.y)
        let maxX = max(maxX, other.maxX)
        let maxY = max(maxY, other.maxY)

        self.size.width  = maxX - origin.x
        self.size.height = maxY - origin.y
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
        .customAttribute(CapsuleHighlightRenderer.ShapeHighlight(onlyWidth: true))
    let capsuleText = Text("\(String.narrowNbsp)\("Capsule")\(spacer)")
        .customAttribute(CapsuleHighlightRenderer.ShapeHighlight())

    Text("Layout \(capsuleImage)\(capsuleText) Title")
    .font(.title)
    .textRenderer(CapsuleHighlightRenderer.capsule(strokeStyle: .teal))
    .frame(width: fixedWidth)
    .floatingCaption("Title Font", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    Text("Layout  \(capsuleImage)\(capsuleText)  Body")
        .textRenderer(CapsuleHighlightRenderer.capsule(strokeStyle: .teal))
    .frame(width: fixedWidth)
    .floatingCaption("Body Font", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)
}


#Preview("Interpolation", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var fixedWidth: Double = 400

    Slider.captioned("Fixed Width", value: $fixedWidth, in: 0...400, valueFormat: .arithmeticRoundedInteger)

    DashedDivider()

    Text("Interpolation \(capsule: "ladybug", label: "Ladybug Image") after interpolation.")
    .textRenderer(CapsuleHighlightRenderer.capsule(strokeStyle: .teal))
    .frame(width: fixedWidth)
    .floatingCaption("Non-Breaking", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    Text("Interpolation \(capsule: "ladybug", label: "Multiple breaking words", breaking: true) after.")
        .textRenderer(CapsuleHighlightRenderer.capsule(strokeStyle: .teal))
    .frame(width: fixedWidth)
    .floatingCaption("Breaking", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    Text("\(capsule: "rectangle.portrait.and.arrow.right", label: "Starting") interpolation at ends \(capsule: "arrowtriangle.left.square", label: "Ending").")
    .textRenderer(CapsuleHighlightRenderer.capsule(strokeStyle: .teal))
    .frame(width: fixedWidth)
    .floatingCaption("Start and End", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    Text("Title \(capsule: "ladybug", label: "Ladybug") interpolation.")
    .font(.title)
    .textRenderer(CapsuleHighlightRenderer.capsule(strokeStyle: .teal))
    .frame(width: fixedWidth)
    .floatingCaption("Title", .colorStyle(.orange), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    VisibleSpacer()
    .layoutPriority(-1)
}

