//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// FIXME: generalize to both width and height

nonisolated
struct ExtendedWidthLayout: Layout {

    let extend: CGFloat

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        var containerSize: CGSize = .zero
        for subview in subviews {
            let size = subview.sizeThatFits(proposal)
            containerSize.envelop(size)
        }
        let extended = containerSize.adding(width: extend)
        return extended
    }


    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        for subview in subviews {
            var extended = proposal
            if let width = extended.width {
                extended.width = width + extend
            }
            subview.place(
                at: bounds.center,
                anchor: .center,
                proposal: extended
            )
        }
    }

}

nonisolated
struct ExtendedHeightLayout: Layout {

    let extend: CGFloat

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        var containerSize: CGSize = .zero
        for subview in subviews {
            let size = subview.sizeThatFits(proposal)
            containerSize.envelop(size)
        }
        let extended = containerSize.adding(height: extend)
        return extended
    }


    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        for subview in subviews {
            var extended = proposal
            if let height = extended.height {
                extended.height = height + extend
            }
            subview.place(
                at: bounds.center,
                anchor: .center,
                proposal: extended
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


#Preview("Width", traits: .fixedHeader, PreviewContent.layout) {
    VStack(alignment: .leading) {
        ExtendedWidthLayout(extend: 50) {
            Rectangle()
            .fill(.indigo)
            .frame(height: 20)
        }
        .alignmentGuide(.leading, offsetBy: 20)

        ExtendedWidthLayout(extend: 50) {
            Rectangle()
            .fill(.indigo)
            .frame(height: 20)
        }
        // FIXME: try to use debugAlignmentGuide
        .overlay(alignment: .leading) {
            Rectangle()
            .fill(.red.secondary)
            .frame(width: 4, height: 100)
        }

        ExtendedWidthLayout(extend: 50) {
            Rectangle()
            .fill(.indigo)
            .frame(height: 20)
        }
        .alignmentGuide(.leading, offsetBy: -20)
    }
    .floatingCaption("VStack", .colorStyle(.purple), .alignment(.outerBottomTrailing))
    .frame(squareOf: 100, alignment: .leading)
    .debugOverlay(.hairline)
}


#Preview("Height", traits: .fixedHeader, PreviewContent.layout) {
    HStack(alignment: .top) {
        ExtendedHeightLayout(extend: 50) {
            Rectangle()
            .fill(.indigo)
            .frame(width: 20)
        }
        .alignmentGuide(.top, offsetBy: 20)

        ExtendedHeightLayout(extend: 50) {
            Rectangle()
            .fill(.indigo)
            .frame(width: 20)
        }
        // FIXME: try to use debugAlignmentGuide
        .overlay(alignment: .top) {
            Rectangle()
            .fill(.red.secondary)
            .frame(width: 100, height: 4)
        }

        ExtendedHeightLayout(extend: 50) {
            Rectangle()
            .fill(.indigo)
            .frame(width: 20)
        }
        .alignmentGuide(.top, offsetBy: -20)
    }
    .floatingCaption("HStack", .colorStyle(.purple), .alignment(.outerTrailingBottom))
    .frame(squareOf: 100, alignment: .top)
    .debugOverlay(.hairline)
}
