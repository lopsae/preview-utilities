//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


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

        for subview in subviews {
            subview.place(
                at: bounds.center,
                anchor: .center,
                proposal: proposal
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


#Preview("DummyZStack", traits: .headerFooter, PreviewContent.layout) {
    @Previewable let printOnce: PrintOnce = .previewStarted

    printOnce.print()
    DummyZStack {
        CaptionRectangle(
            "Tall", color: .yellow, size: .init(width: 200, height: 100),
            traits: .alignment(.topLeading))
        CaptionRectangle(
            "Wide", color: .brown, size: .init(width: 100, height: 200),
            traits: .alignment(.topTrailing))
    }
    .debugOverlay(.size, .infoAlignment(.outerBottom))
}
