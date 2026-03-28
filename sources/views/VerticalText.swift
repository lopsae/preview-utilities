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

// TODO: move to its own file.

/// A custom layout that transposes the width and height its subviews.
///
/// This layout swaps the width and height in both the size proposal sent to the child and the
/// resulting size reported back to the parent. This enables a rotated view to participate correctly
/// in the layout system.
///
/// The subviews are arranged in the same manner as a centered ZStack.
nonisolated
private struct TransposeLayout: Layout {

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


#Preview("TransposeLayout", traits: .fixedHeaderFooter, PreviewContent.layout) {
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
        .rotationEffect(.turns(1/4))
        CaptionRectangle(
            "Tall", color: .yellow, size: .init(width: 100, height: tallHeight),
            traits: .alignment(.topTrailing)
        )
        .rotationEffect(.turns(1/4))
    }
    .debugOverlay(.size, .infoAlignment(.outerBottom))
    .maxSizeFrame()
}


#Preview("TransposeLayout-Text", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable let printOnce: PrintOnce = .previewStarted
    @Previewable @State var wordCount: Double = 10
    @Previewable @State var fixedWidth: Double = 200
    @Previewable @State var fixedHeight: Double = 200

    printOnce.print()

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
        .rotationEffect(.turns(1/4))
    }
    .debugOverlay(.size, .infoAlignment(.outerBottom))
    .maxSizeFrame()
}


// TODO: move to its own file.
extension Angle {

    static func turns(_ turns: Double) -> Self {
        .radians(turns * .tau)
    }

}


// TODO: move to its own file.
extension Double {

    /// /// The mathematical constant tau (𝜏), approximately equal to `2*pi`: 6.28318.
    ///
    /// When measuring an angle in radians, 𝜏 is equivalent to a one turn.
    /// https://www.tauday.com
    static var tau: Double { .pi * 2 }

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
