//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct CapsuleAttribute: TextAttribute {
    let onlyWidth: Bool
    init(onlyWidth: Bool = false) {
        self.onlyWidth = onlyWidth
    }
}

struct CapsuleRenderer: TextRenderer {
  let strokeColor: Color

  func draw(layout: Text.Layout, in context: inout GraphicsContext) {
      var capsuleRuns: [(run: Text.Layout.Run, attr: CapsuleAttribute)] = []
      for line in layout {
          for run in line {
              if let attr = run[CapsuleAttribute.self] {
                  // Collect all adjacent attributed runs.
                  capsuleRuns.append((run: run, attr: attr))
                  continue
              }

              // Draw all collected runs together.
              if let capsuleRun = capsuleRuns.first {
                  var capsuleRect = capsuleRun.attr.onlyWidth
                    ? capsuleRun.run.typographicBounds.rect.horizontalBisector
                    : capsuleRun.run.typographicBounds.rect

                  for (run, attr) in capsuleRuns {
                      let rectToEnvelop: CGRect
                      if attr.onlyWidth {
                          rectToEnvelop = run.typographicBounds.rect.horizontalBisector
                      } else {
                          rectToEnvelop = run.typographicBounds.rect
                      }
                      capsuleRect.envelop(rectToEnvelop)
                  }

                  // Draw capsule path.
                  let copy = context
                  let padding = Defaults.padding/4
                  let capsulePath = Capsule().path(in: capsuleRect.outset(by: padding))
                  copy.stroke(
                    capsulePath,
                    with: .color(strokeColor),
                    style: StrokeStyle(lineWidth: 1.5, dash: [4, 4])
                  )

                  // Draw runs on top.
                  for capsuleRun in capsuleRuns {
                      // let runRect: CGRect = capsuleRun.run.typographicBounds.rect
                      // copy.stroke(Rectangle().path(in: runRect), with: .color(.red))
                      copy.draw(capsuleRun.run)

                  }
              }

              // Draw the current run.
              context.draw(run)
          }
      }
  }
}


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


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    let spacer = Text(String.narrowNbsp)//.tracking(2)
    let capsuleImage = Text("\(spacer)\(Image(ImageResource.moduleCatalog(.envelopeOffcenterBadgeBottomTrailing)))")
        .customAttribute(CapsuleAttribute(onlyWidth: true))
    let capsuleText = Text("\(String.nbsp)\("Capsule")\(spacer)")
        .customAttribute(CapsuleAttribute())

    Text("Layout \(capsuleImage)\(capsuleText) Title")
        .font(.title)
        .textRenderer(CapsuleRenderer(strokeColor: .teal))

    Text("Layout  \(capsuleImage)\(capsuleText)  Body")
        .textRenderer(CapsuleRenderer(strokeColor: .teal))
}
