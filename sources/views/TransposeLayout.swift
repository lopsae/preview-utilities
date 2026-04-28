//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// A custom layout that transposes the width and height of its subviews.
///
/// This layout swaps the width and height in both the size proposal sent to the subvies and the
/// resulting size reported back to the parent. This enables the geometry of the rotated view to
/// participate with the layout system.
///
/// This layout does not modify how the views are presented. Apply the `.rotationEffect` modifier to
/// visually rotate the views.
///
/// The subviews are arranged in the same manner as a centered `ZStack`.
nonisolated
struct TransposeLayout: Layout {

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let transposedProposal = proposal.transposed
        var containerSize: CGSize = .zero
        for subview in subviews {
            let size = subview.sizeThatFits(transposedProposal)
            containerSize.envelop(size)
        }
        // Transpose the container size so the parent sees the rotated dimensions.
        return containerSize.transposed
    }


    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        // Place the child centered in the bounds with a transposed proposal.
        let transposedProposal = ProposedViewSize(bounds.size.transposed)
        for subview in subviews {
            subview.place(
                at: bounds.center,
                anchor: .center,
                proposal: transposedProposal)
        }
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var wideWidth: Double = 200
    @Previewable @State var tallHeight: Double = 200

    Slider.captioned(
        "Wide Width",
        value: $wideWidth,
        in: 0...400,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)
    Slider.captioned(
        "Tall Heigth",
        value: $tallHeight,
        in: 0...400,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)

    TransposeLayout {
        CaptionRectangle(
            "Wide", color: .brown, size: .init(width: wideWidth, height: 100),
            traits: .alignment(.topLeading))
        CaptionRectangle(
            "Tall", color: .yellow, size: .init(width: 100, height: tallHeight),
            traits: .alignment(.topTrailing))
    }
    .debugOverlay(.size, .infoAlignment(.outerBottom))
    .maxSizeFrame()

    DashedDivider()
    Text.caption("Transposed View")

    TransposeLayout {
        CaptionRectangle(
            "Wide", color: .brown, size: .init(width: wideWidth, height: 100),
            traits: .alignment(.topLeading)
        )
        .rotationEffect(.turn(1/4))
        CaptionRectangle(
            "Tall", color: .yellow, size: .init(width: 100, height: tallHeight),
            traits: .alignment(.topTrailing)
        )
        .rotationEffect(.turn(1/4))
    }
    .debugOverlay(.size, .infoAlignment(.outerBottom))
    .maxSizeFrame()
}


#Preview("Text", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var wordCount: Double = 10
    @Previewable @State var fixedWidth: Double = 200
    @Previewable @State var fixedHeight: Double = 200

    Slider.captioned(
        "Word count",
        value: $wordCount,
        in: 0...100,
        valueFormat: .arithmeticRoundedInteger)
    Slider.captioned(
        "Fixed Width",
        value: $fixedWidth,
        in: 0...400,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)
    Slider.captioned(
        "Fixed Heigth",
        value: $fixedHeight,
        in: 0...400,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)

    let textString = Strings.loremIpsum(words: wordCount.rounded().asInt)
    TransposeLayout {
        Text(verbatim: textString)
    }
    .debugOverlay(.size, .infoAlignment(.outerBottom))
    .maxSizeFrame()

    DashedDivider()
    Text.caption("Transposed Text")

    TransposeLayout {
        Text(verbatim: textString)
        .rotationEffect(.turn(1/4))
    }
    .debugOverlay(.size, .infoAlignment(.outerBottom))
    .maxSizeFrame()
}


#Preview("Interactive", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var string: String = Strings.loremIpsum(words: 5)

    PreviewCaption("""
        `.rotationEffect` actually rotates the hit-testing areas of the rotated content. Text views
        and buttons behave correctly when transposed and rotated.
        """)

    let view = Group {
        HStack {
            TextField("Text Field", text: $string)
            Button("Button", systemImage: "ladybug") {
                print("Button tapped")
            }
            .buttonStyle(.borderedProminent)
        }
    }

    TransposeLayout {
        view
    }
    .debugOverlay(.size, .infoAlignment(.outerBottom))
    .maxSizeFrame()

    DashedDivider()
    Text.caption("Transposed Views")

    TransposeLayout {
        view
        .rotationEffect(.turn(1/4))
    }
    .debugOverlay(.size, .infoAlignment(.outerBottom))
    .maxSizeFrame()
}
