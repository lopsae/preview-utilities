//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct CapsuleHighlightRenderer: TextRenderer {
  let strokeColor: Color

  func draw(layout: Text.Layout, in context: inout GraphicsContext) {
      var capsuleRuns: [(run: Text.Layout.Run, attr: Attribute)] = []
      var highlightOpen = false
      var runsInSingleLine = true
      for line in layout {
          for run in line {
              let pendingAttr = run[Attribute.self]
              if capsuleRuns.isEmpty, let attr = pendingAttr {
                  // Start run collection on single line.
                  highlightOpen = false
                  runsInSingleLine = true
                  capsuleRuns.append((run: run, attr: attr))
                  continue
              }

              var attrOnNewLine: Attribute?
              if runsInSingleLine {
                  if let attr = pendingAttr {
                      // Collect all adjacent attributed runs.
                      capsuleRuns.append((run: run, attr: attr))
                      continue
                  } else {
                      // Continue to draw collected runs to highlight.
                  }
              } else {
                  // Different line, save pendingAttr.
                  attrOnNewLine = pendingAttr
                  // And continue to draw collected runs to highlight.
              }

              // Draw all collected runs together.
              if let capsuleRun = capsuleRuns.first {
                  var highlightRunsRect = capsuleRun.attr.onlyWidth
                    ? capsuleRun.run.typographicBounds.rect.horizontalBisector
                    : capsuleRun.run.typographicBounds.rect

                  for (run, attr) in capsuleRuns {
                      let rectToAdd: CGRect
                      if attr.onlyWidth {
                          rectToAdd = run.typographicBounds.rect.horizontalBisector
                      } else {
                          rectToAdd = run.typographicBounds.rect
                      }
                      highlightRunsRect.envelop(rectToAdd)
                  }

                  // Draw capsule path.

                  let shapeRect = highlightRunsRect.outset(by: 3)
                  let cutHighlightRadius: CGFloat = 3

                  let leadingRadius = highlightOpen
                    ? cutHighlightRadius
                    : shapeRect.height/2

                  let trailingRadius = attrOnNewLine == nil
                    ? shapeRect.height/2
                    : cutHighlightRadius

                  let shape = UnevenRoundedRectangle(
                    topLeadingRadius: leadingRadius,
                    bottomLeadingRadius: leadingRadius,
                    bottomTrailingRadius: trailingRadius,
                    topTrailingRadius: trailingRadius
                  )


                  let localContext = context
                  localContext.stroke(
                    shape.path(in: shapeRect),
                    with: .color(strokeColor),
                    style: StrokeStyle(lineWidth: 1.5, dash: [5, 4])
                  )

                  // Draw runs on top.
                  for capsuleRun in capsuleRuns {
                      // let runRect: CGRect = capsuleRun.run.typographicBounds.rect
                      // copy.stroke(Rectangle().path(in: runRect), with: .color(.red))
                      localContext.draw(capsuleRun.run)
                  }

                  // Reset collected runs.
                  highlightOpen = false
                  capsuleRuns = []
                  if let attrOnNewLine {
                      highlightOpen = true
                      runsInSingleLine = true
                      capsuleRuns.append((run: run, attr: attrOnNewLine))
                      continue
                  }

              }

              // Draw the current run.
              context.draw(run)
          } // for run

          runsInSingleLine = false

      } // for line
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
