//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// Experimental Layout. Reports the size that contains all subviews multiplied by `scale`.
// All subviews are placed centered and unscaled in the layout. Apply `scaleEffect` to the content
// or to the layout to display the scaled content.
private struct ScaledLayout: Layout {
    let scale: CGFloat

    // Proposal for the subviews, in unscaled coordinate space.
    private func unscaled(_ proposal: ProposedViewSize) -> ProposedViewSize {
        ProposedViewSize(
            width: proposal.width.map { $0 / scale },
            height: proposal.height.map { $0 / scale }
        )
    }

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let unscaledProposal = unscaled(proposal)
        let size: CGSize = subviews.reduce(into: .zero) { size, subview in
            let subviewSize = subview.sizeThatFits(unscaledProposal)
            size.envelop(subviewSize)
        }
        return size.multiplying(by: scale)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let unscaledProposal = unscaled(proposal)
        let center = bounds.centerPoint
        for subview in subviews {
            subview.place(at: center, anchor: .center, proposal: unscaledProposal)
        }
    }
}

extension View {

    /// Scales the view and makes it occupy its scaled size in layout.
    func scaledLayout(_ scale: CGFloat) -> some View {
        ScaledLayout(scale: scale) {
            self
        }.scaleEffect(scale)
    }

}


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing) {
    Image(systemName: "guidepoint.horizontal")
    .scaledLayout(4)
    .border(.orange.secondary, width: 2)

    Image(systemName: "guidepoint.vertical")
    .scaledLayout(3)
    .border(.orange.secondary, width: 2)

    ScaledLayout(scale: 3) {
        Image(systemName: "guidepoint.vertical")
        Image(systemName: "circle")
        Image(systemName: "guidepoint.horizontal")
    }
    .scaleEffect(3)
    .border(.orange.secondary, width: 2)
}


// MARK: Text
#Preview("Text", traits: .fixedHeaderFooter) {
    @Previewable @State var fixedWidth: CGFloat = 400

    Slider.captioned(
        "Fixed Width", value: $fixedWidth, in: 10...400,
        currentValueFormat: .twoFractionals,
        boundsValueFormat: .arithmeticRoundedInteger
    )

    VisibleSpacer()

    VStack {
        Text("Sphinx of Black Quartz,")
        Text("Judge my vow.")
    }
    .scaledLayout(2.5)
    .frame(width: fixedWidth)
    .border(.orange.secondary, width: 2)
    .layoutPriority(1)

    VisibleSpacer()
}
