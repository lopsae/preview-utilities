//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import GeometryAdditions
import SwiftUI


#if canImport(UIKit)
import UIKit
#endif


extension LocalizedStringKey.StringInterpolation {

    mutating func appendInterpolation(systemImage name: String, label: String, useNbsp: Bool = true) {
        var label = " \(label)"
        if useNbsp {
            label = label.replacingOccurrences(of: " ", with: String.nbsp)
        }
        appendInterpolation(Image(systemName: name))
        appendInterpolation(label)
    }

    mutating func appendInterpolation(image resource: ImageResource, label: String, useNbsp: Bool = true) {
        var label = " \(label)"
        if useNbsp {
            label = label.replacingOccurrences(of: " ", with: String.nbsp)
        }
        appendInterpolation(Image(resource))
        appendInterpolation(label)
    }


    mutating func appendInterpolation(nonBreaking label: String) {
        let label = label.replacingOccurrences(of: " ", with: String.nbsp)
        appendInterpolation(label)
    }


    mutating func appendInterpolation(
        button systemImage: String,
        label: String,
        color: Color = .accentColor
    ) {
        let capsule = CapsuleText(systemImage: systemImage, label: label, color: color)

        if let inlineText = capsule.inlineText() {
            appendInterpolation(inlineText)
        } else {
            // Fallback if rendering fails.
            appendInterpolation(Image(systemName: systemImage))
            appendInterpolation(label)
        }
    }

}


private struct CapsuleText: View {

    let systemImage: String
    let label: String
    let color: Color

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: Defaults.padding / 3) {
            Image(systemName: systemImage)
            Text(label)
        }
        .font(.body)
        .foregroundStyle(color)
        .padding(.horizontal, Defaults.padding / 2)
        .padding(.vertical, Defaults.padding / 4)
        .background {
            Capsule()
            .strokeBorder(color, style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))
        }
    }


    /// Renders the capsule to an image and returns it as inline `Text`.
    func inlineText(scale: CGFloat = 3) -> Text? {
        let baseline = BaselineBox()
        let renderer = ImageRenderer(content: FirstBaselineReader(baseline: baseline) { self })
        renderer.scale = scale

        guard let cgImage = renderer.cgImage else { return nil }

        let height = CGFloat(cgImage.height) / scale
        let baselineFromBottom = height - (baseline.fromTop ?? height)

        return Text(Image(decorative: cgImage, scale: scale))
            .baselineOffset(-baselineFromBottom)
    }


    #if canImport(UIKit)
    /// Renders the capsule to an image whose text baseline is baked in, so it aligns inline like an
    /// `Image(systemName:)` without the caller applying a `baselineOffset`.
    ///
    /// UIKit only: `UIImage` can carry baseline metadata via `withBaselineOffset(fromBottom:)`,
    /// which SwiftUI honors for inline images. `NSImage` has no equivalent, so on macOS use
    /// ``inlineText(scale:)`` instead.
    func baselinedImage(scale: CGFloat = 3) -> Image? {
        let baseline = BaselineBox()
        let renderer = ImageRenderer(content: FirstBaselineReader(baseline: baseline) { self })
        renderer.scale = scale

        guard let uiImage = renderer.uiImage else { return nil }

        // `uiImage.size` is already in points, and a positive offset places the baseline that far
        // up from the bottom edge — exactly the capsule's baseline-from-bottom.
        let baselineFromBottom = uiImage.size.height - (baseline.fromTop ?? uiImage.size.height)

        return Image(uiImage: uiImage.withBaselineOffset(fromBottom: baselineFromBottom))
    }
    #endif

}


/// Lays out a single view unchanged while capturing its first text baseline, measured from the top,
/// so a view about to be rasterized can expose the baseline it would use in a live layout.
private struct FirstBaselineReader: Layout {

    let baseline: BaselineBox

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        subviews[0].sizeThatFits(proposal)
    }

    // TODO: If there is more that one image, ZStack them and still save the baseline measurement.
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let size = ProposedViewSize(bounds.size)
        baseline.fromTop = subviews[0].dimensions(in: size)[.firstTextBaseline]
        subviews[0].place(at: bounds.origin, proposal: size)
    }

}


/// Carries the measured baseline out of ``FirstBaselineReader``'s layout pass, which runs
/// synchronously on the main thread during rendering.
private final class BaselineBox {
    nonisolated(unsafe) var fromTop: CGFloat?
}


#Preview("CapsuleText", traits: .headerFooter, PreviewContent.layout) {
    HStack(alignment: .firstTextBaseline) {
        Text("First")
        CapsuleText(systemImage: "ladybug", label: "View", color: .cyan)
            .debugAlignmentGuide(vertical: .firstTextBaseline, .extendedLength(150))
        Text("Baseline")
    }

    DashedDivider()

    HStack(alignment: .firstTextBaseline) {
        Text("First")
        CapsuleText(systemImage: "ladybug", label: "Text", color: .cyan)
            .inlineText()
            .debugAlignmentGuide(vertical: .firstTextBaseline, .extendedLength(150))
        Text("Baseline")
    }

    DashedDivider()

    HStack(alignment: .firstTextBaseline) {
        Text("First")
        CapsuleText(systemImage: "ladybug", label: "Image", color: .cyan)
            .baselinedImage()
            .debugAlignmentGuide(vertical: .firstTextBaseline, .extendedLength(150))
        Text("Baseline")
    }
}


struct CapsuleAttribute: TextAttribute {}

struct CapsuleRenderer: TextRenderer {
  let strokeColor: Color

  func draw(layout: Text.Layout, in context: inout GraphicsContext) {
      var capsuleRuns: [Text.Layout.Run] = []
      for line in layout {
          for run in line {
              if run[CapsuleAttribute.self] != nil {
                  capsuleRuns.append(run)
                  continue
              }

              // If there are capsule runs, draw them together
              if !capsuleRuns.isEmpty {
                  var capsuleRect: CGRect = capsuleRuns.first!.typographicBounds.rect
                  for capsuleRun in capsuleRuns {
                      let runRect = capsuleRun.typographicBounds.rect
                      capsuleRect.envelop(runRect)
                  }
                  let copy = context
                  let padding = Defaults.padding/4
                  let capsulePath = Capsule().path(in: capsuleRect.outset(by: padding))
                  copy.stroke(
                    capsulePath,
                    with: .color(strokeColor),
                    style: StrokeStyle(lineWidth: 1.5, dash: [4, 3])
                  )


                  for capsuleRun in capsuleRuns {
                      var runRect: CGRect = capsuleRun.typographicBounds.rect
                      copy.stroke(Rectangle().path(in: runRect), with: .color(.red))
                      copy.draw(capsuleRun)

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

}



#Preview("Renderer", traits: .headerFooter, PreviewContent.layout) {
    let capsuleText = Text("\(systemImage: "ladybug", label: "Capsule")")
        .customAttribute(CapsuleAttribute())
    Text("Layout \(capsuleText) Text")
        .font(.title)
        .textRenderer(CapsuleRenderer(strokeColor: .teal))
}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var fixedWidth: Double = 400

    Slider.captioned("Fixed Width", value: $fixedWidth, in: 0...400, valueFormat: .arithmeticRoundedInteger)

    DashedDivider()

    Text("Test before \(systemImage: "ladybug", label: "Ladybug image yes nbsp") after interpolation")
    .frame(width: fixedWidth)
    .floatingCaption("Image+Label+YesNbsp", .colorStyle(.yellow), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    Text("Test before \(systemImage: "ladybug", label: "Ladybug image no nbsp", useNbsp: false) after interpolation")
    .frame(width: fixedWidth)
    .floatingCaption("Image+Label+NoNbsp", .colorStyle(.yellow), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    Text("Test before \(image: .moduleCatalog(.envelopeOffcenterBadgeTopTrailing), label: "Envelope Image") after interpolation")
    .frame(width: fixedWidth)
    .floatingCaption("ImageResource+Label+YesNbsp", .colorStyle(.yellow), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    Text("Test before \(nonBreaking: "Non breaking text") after interpolation")
    .frame(width: fixedWidth)
    .floatingCaption("String+NonBreaking", .colorStyle(.yellow), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    Text("Tap \(button: "plus.circle", label: "Add Item", color: .orange) to insert a new row")
    .frame(width: fixedWidth)
    .floatingCaption("Button+DashedCapsule", .colorStyle(.yellow), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    DashedDivider()

    let capsuleText = Text("\(systemImage: "ladybug", label: "Capsule Renderer")")
        .customAttribute(CapsuleAttribute())
    Text("Layout \(capsuleText) Text")
    .textRenderer(CapsuleRenderer(strokeColor: .teal))
    .frame(width: fixedWidth)
    .floatingCaption("CapsuleRenderer", .colorStyle(.yellow), .alignment(.outerBottomTrailing))
    .padding(.bottom)

    Spacer()
}
