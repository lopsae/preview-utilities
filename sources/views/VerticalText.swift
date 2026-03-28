//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Experimental view that displays a vertical text, reading either upwards or downwards.
///
/// This view wraps a SwiftUI `Text` view, rotates it, and uses a custom layout to negotiate its
/// vertical size.
struct VerticalText: View {

    let content: Text
    let direction: Direction

    /// The direction in which the text reads.
    enum Direction: Sendable {
        /// Text reads from bottom to top (rotated 270 degrees counter-clockwise).
        case upwards
        /// Text reads from top to bottom (rotated 90 degrees clockwise).
        case downwards

        var angle: Angle {
            switch self {
            case .upwards:   .degrees(-90)
            case .downwards: .degrees(90)
            }
        }
    }


    init(_ content: Text, direction: Direction = .upwards) {
        self.content = content
        self.direction = direction
    }


    init(_ key: LocalizedStringKey, direction: Direction = .upwards) {
        self.content = Text(key)
        self.direction = direction
    }


    init(verbatim: String, direction: Direction = .upwards) {
        self.content = Text(verbatim: verbatim)
        self.direction = direction
    }


    var body: some View {
        TransposeLayout {
            content
            .fixedSize()
            .rotationEffect(direction.angle)
        }
    }

}


// MARK: - TransposeLayout


/// A custom layout that transposes the width and height of its single child.
///
/// This layout swaps the width and height in both the size proposal sent to the child and the
/// resulting size reported back to the parent. This enables a rotated view to participate correctly
/// in the layout system.
nonisolated
private struct TransposeLayout: Layout {

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        // Propose with swapped dimensions so the child measures as if unrotated.
        let transposedProposal = ProposedViewSize(
            width: proposal.height,
            height: proposal.width
        )
        let size = subviews.first?.sizeThatFits(transposedProposal) ?? .zero
        // Swap the resulting size so the parent sees the rotated dimensions.
        return CGSize(width: size.height, height: size.width)
    }


    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        // Place the child centered in the bounds with a transposed proposal.
        let transposedProposal = ProposedViewSize(
            width: bounds.height,
            height: bounds.width
        )
        subviews.first?.place(
            at: CGPoint(x: bounds.midX, y: bounds.midY),
            anchor: .center,
            proposal: transposedProposal
        )
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeader, PreviewContent.layout) {
    HStack {
        VerticalText("Upwards Label", direction: .upwards)
            .border(.tertiary)

        Rectangle()
            .fill(.cyan.gradient.tertiary)
            .frame(width: 200, height: 100)
    }

    HStack {
        VerticalText("Downwards Label", direction: .downwards)
            .border(.tertiary)

        Rectangle()
            .fill(.mint.gradient.tertiary)
            .frame(width: 200, height: 100)
    }
}


#Preview("TransposeLayout", traits: .fixedHeader, PreviewContent.layout) {
    HStack {
        VerticalText("Upwards Label", direction: .upwards)
            .border(.tertiary)

        Rectangle()
            .fill(.cyan.gradient.tertiary)
            .frame(width: 200, height: 100)
    }

    HStack {
        VerticalText("Downwards Label", direction: .downwards)
            .border(.tertiary)

        Rectangle()
            .fill(.mint.gradient.tertiary)
            .frame(width: 200, height: 100)
    }
}


#Preview("In Containers", traits: .fixedHeader, PreviewContent.layout) {
    VStack {
        VerticalText("Vertical in VStack", direction: .upwards)
            .border(.tertiary)
    }
    .frame(maxWidth: .infinity)
    .border(.quaternary)

    HStack(alignment: .center) {
        VerticalText("Left", direction: .upwards)
            .border(.tertiary)
        ClearRectangle(width: 100, height: 150, fill: .indigo.gradient.tertiary)
        VerticalText("Right", direction: .downwards)
            .border(.tertiary)
    }
}
