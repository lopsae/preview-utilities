//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct CapsuleHighlightRenderer: TextRenderer {

    let strokeColor: Color

    private static let outset: CGFloat = 3
    private static let cutCornerRadius: CGFloat = 3
    private static let stroke = StrokeStyle(lineWidth: 1.5, dash: [5, 4])

    func draw(layout: Text.Layout, in context: inout GraphicsContext) {
        // The contiguous attributed runs accumulated for the current highlight.
        var group: [HighlightRun] = []
        // The group began as a continuation from a previous line, so its leading corners are cut.
        var continuesFromPreviousLine = false
        // Whether we are still on the line where the current group began.
        var onGroupStartLine = true

        for line in layout {
            for run in line {
                let attribute = run[Attribute.self]

                // Idle: start a group on an attributed run, otherwise draw the run as-is.
                if group.isEmpty {
                    if let attribute {
                        group = [HighlightRun(run: run, attribute: attribute)]
                        continuesFromPreviousLine = false
                        onGroupStartLine = true
                    } else {
                        context.draw(run)
                    }
                    continue
                }

                // Still on the start line: keep collecting adjacent attributed runs.
                if onGroupStartLine, let attribute {
                    group.append(HighlightRun(run: run, attribute: attribute))
                    continue
                }

                // The group is complete, so flush it. On a later line, an attributed first run
                // means the highlight continues, so its trailing corners are cut.
                let continuation = onGroupStartLine ? nil : attribute
                drawHighlight(
                    group,
                    cutLeadingCorners: continuesFromPreviousLine,
                    cutTrailingCorners: continuation != nil,
                    in: context
                )

                if let continuation {
                    // Reopen the highlight on this line with the continuing run.
                    group = [HighlightRun(run: run, attribute: continuation)]
                    continuesFromPreviousLine = true
                    onGroupStartLine = true
                } else {
                    group = []
                    continuesFromPreviousLine = false
                    context.draw(run)
                }
            }

            onGroupStartLine = false
        }

        // Flush a highlight that reaches the end of the text with no trailing plain run.
        if !group.isEmpty {
            drawHighlight(
                group,
                cutLeadingCorners: continuesFromPreviousLine,
                cutTrailingCorners: false,
                in: context
            )
        }
    }


    /// Strokes the capsule behind `group` and draws its glyphs on top. Cut corners produce the flat
    /// edge used where a highlight is split across a line boundary.
    private func drawHighlight(
        _ group: [HighlightRun],
        cutLeadingCorners: Bool,
        cutTrailingCorners: Bool,
        in context: GraphicsContext
    ) {
        guard let bounds = enclosingRect(of: group) else { return }

        let rect = bounds.outset(by: Self.outset)
        let fullRadius = rect.height / 2
        let leadingRadius = cutLeadingCorners ? Self.cutCornerRadius : fullRadius
        let trailingRadius = cutTrailingCorners ? Self.cutCornerRadius : fullRadius

        let shape = UnevenRoundedRectangle(
            topLeadingRadius: leadingRadius,
            bottomLeadingRadius: leadingRadius,
            bottomTrailingRadius: trailingRadius,
            topTrailingRadius: trailingRadius
        )

        context.stroke(shape.path(in: rect), with: .color(strokeColor), style: Self.stroke)

        for element in group {
            context.draw(element.run)
        }
    }


    /// The rect enclosing every run's contribution to the highlight.
    private func enclosingRect(of group: [HighlightRun]) -> CGRect? {
        var rect: CGRect?
        for element in group {
            if rect == nil {
                rect = element.contributingRect
            } else {
                rect?.envelop(element.contributingRect)
            }
        }
        return rect
    }

}


// MARK: - HighlightRun


extension CapsuleHighlightRenderer {

    private struct HighlightRun {
        let run: Text.Layout.Run
        let attribute: Attribute

        /// The rect this run contributes to the highlight. `onlyWidth` runs (e.g. spacer pads)
        /// contribute width but not height, via their zero-height centerline.
        var contributingRect: CGRect {
            attribute.onlyWidth
                ? run.typographicBounds.rect.horizontalBisector
                : run.typographicBounds.rect
        }
    }

}


// MARK: - Attribute


extension CapsuleHighlightRenderer {

    struct Attribute: TextAttribute {
        let onlyWidth: Bool
        init(onlyWidth: Bool = false) {
            self.onlyWidth = onlyWidth
        }
    }

}


// FIXME: move to GeometryAdditions.
extension CGRect {

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
        .customAttribute(CapsuleHighlightRenderer.Attribute(onlyWidth: true))
    let capsuleText = Text("\(String.narrowNbsp)\("Capsule")\(spacer)")
        .customAttribute(CapsuleHighlightRenderer.Attribute())

    Text("Layout \(capsuleImage)\(capsuleText) Title")
    .font(.title)
    .textRenderer(CapsuleHighlightRenderer(strokeColor: .teal))
    .frame(width: fixedWidth)
    .floatingCaption("Title Font", .colorStyle(.yellow), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    Text("Layout  \(capsuleImage)\(capsuleText)  Body")
    .textRenderer(CapsuleHighlightRenderer(strokeColor: .teal)).frame(width: fixedWidth)
    .floatingCaption("Body Font", .colorStyle(.yellow), .alignment(.outerBottomTrailing))
    .padding(.bottom)
}
