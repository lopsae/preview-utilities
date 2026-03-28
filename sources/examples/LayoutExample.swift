//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Simplified example implementation of a ZStack with center alignment.
private struct DummyZStack: Layout {

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        print("❎ sizeThatFits:")
        print(" ┗ proposal: \(proposal.debugSizeString) ")

        var containerSize: CGSize = .zero
        for subview in subviews {
            let size = subview.sizeThatFits(proposal)
            containerSize.envelop(size)
        }
        return containerSize
    }


    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        print("🔡 placeSubviews:")
        print(" ┗ bounds: +:\(bounds.origin) ◻:\(bounds.size) ")
        print(" ┗ proposal: ◻\(proposal.debugSizeString) ")

        let childProposal = ProposedViewSize(bounds.size)
        for subview in subviews {
            subview.place(
                at: bounds.center,
                anchor: .center,
                proposal: childProposal
            )
        }
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("DummyZStack", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable let printOnce: PrintOnce = .previewStarted
    @Previewable @State var wideWidth: Double = 200
    @Previewable @State var tallHeight: Double = 200

    printOnce.print()

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

    DummyZStack {
        CaptionRectangle(
            "Wide", color: .brown, size: .init(width: wideWidth, height: 100),
            traits: .alignment(.topLeading))
        CaptionRectangle(
            "Tall", color: .yellow, size: .init(width: 100, height: tallHeight),
            traits: .alignment(.topTrailing))
    }
    .debugOverlay(.size, .infoAlignment(.outerBottom))
}
