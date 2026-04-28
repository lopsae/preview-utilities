//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct SafeAreaPad<S: ShapeStyle>: View {

    let edge: VerticalEdge
    let showDivider: Bool
    let backgroundFill: S


    init(edge: VerticalEdge, showDivider: Bool = false, fill: S = .orange.tertiary) {
        self.edge = edge
        self.showDivider = showDivider
        self.backgroundFill = fill
    }

    var body: some View {
        if showDivider && edge == .bottom {
            DashedDivider()
        }

        sizingViewWithBackground.overlay {
            GeometryReader { geometry in
                let safeArea = geometry.safeAreaInsets[edge: edge]
                let guidedAlignment: InsettableAlignment = switch edge {
                case .top:    .top
                case .bottom: .bottom
                }
                let alignment: Alignment = .init(
                    horizontal: .center,
                    vertical: guidedAlignment.baseAlignment)

                ZStack(alignment: alignment) {
                    let alignmentInset = textAlignmentInset(
                        containerHeight: geometry.size.height,
                        safeArea: safeArea)

                    Text("Device SafeArea")
                    .font(.caption)
                    .foregroundStyle(.tertiary)
                    .alignmentGuide(guidedAlignment, moveTo: .center, insetBy: alignmentInset)

                    // Safearea indicator.
                    if safeArea > .zero {
                        safeAreaIndicator(safeArea: safeArea)
                        .alignmentGuide(guidedAlignment, insetBy: safeArea)
                    }

                    // This retangle is required to stay true-bottom aligned to allow the other
                    // views to offset their position. Its actual position is at the edge of the
                    // safe area.
                    ClearRectangle(height: 10)
                } // ZStack
                // The ZStack is positioned at the edge of the safeArea to then inset the internal views.
                .alignmentGuide(guidedAlignment, outsetBy: safeArea)
                .frame(size: geometry.size, alignment: alignment)
            } // GeometryReader
        } // overlay

        if showDivider && edge == .top {
            DashedDivider()
        }
    }



    /// Base view that determines the overall size of the view and includes the background extending
    /// into the safe areas. This base view contains a text to determine its height, but the text
    /// remains hidden.
    ///
    /// The height of this view is always: text.height + 2 *defaultpPaddings + 2*halfPaddings
    @ViewBuilder
    private var sizingViewWithBackground: some View {
        Text("SafeAreaPad")
        .font(.caption)
        .hidden()
        .maxWidthFrame()
        // Padding from edge of view, to match background padding.
        .padding(.all)
        // Padding from edge of background.
        .padding(Defaults.padding / 2)
        .background {
            ConcentricRectangle(minimumConcentricRadius: HeaderFooterContainer.minimumConcentricRadius)
            .fill(.orange.tertiary)
            // Padding from edge of view, to match background padding.
            .padding(.all)
            .ignoresSafeArea()
        }
    }


    private func textAlignmentInset(containerHeight: CGFloat, safeArea: CGFloat) -> CGFloat {
        let padding = Defaults.padding

        // Container height, removing the top padding. This is the area
        // where the label can be.
        let unpaddedContainerHeight = containerHeight - padding

        let alignmentInset: CGFloat
        if safeArea > padding {
            // Label is centered in available container area, and pushed up
            // by the entire safeArea.
            alignmentInset = safeArea + unpaddedContainerHeight / 2
        } else {
            // Fraction of safe area bitting into the available container area.
            let remainingPadding = padding - safeArea
            let centerOfContainerHeight = (unpaddedContainerHeight - remainingPadding) / 2
            // Label is always pushed up in this case by 1 padding.
            alignmentInset = centerOfContainerHeight + padding
        }
        return alignmentInset
    }


    @ViewBuilder
    private func safeAreaIndicator(safeArea: CGFloat) -> some View {
        let alignment: HorizontalAlignment = switch edge {
        case .top:    .leading
        case .bottom: .trailing
        }
        VStack(alignment: alignment, spacing: .zero) {
            let divider = DashedDivider(lineWidth: 1)
            let text = Text(safeArea, format: .fractionLength(2))
                .font(.caption.monospaced())
                .foregroundStyle(.tertiary)

            switch edge {
            case .top:
                divider
                text
            case .bottom:
                text
                divider
            }
        }
        .padding(.horizontal)
        .padding(.horizontal)
    }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


#Preview("Defaults", traits: .zeroSpacing, PreviewContent.layout) {
    SafeAreaPad(edge: .top)
    VisibleSpacer()
    SafeAreaPad(edge: .top, showDivider: true)
    VisibleSpacer()
    SafeAreaPad(edge: .bottom, showDivider: true)
    VisibleSpacer()
    SafeAreaPad(edge: .bottom)
}


#Preview("SafeArea", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var safeAreaInset: Double = 60

    Text("Device Edge")
        .font(.caption)
        .foregroundStyle(.tertiary)
        .padding(.bottom, 8)
        .maxWidthFrame()
        .background {
            let padding: CGFloat = 12
            let minorRadius: CGFloat = 4
            let mayorRadius: CGFloat = 55
            UnevenRoundedRectangle(
                topLeadingRadius: mayorRadius,
                bottomLeadingRadius: minorRadius,
                bottomTrailingRadius: minorRadius,
                topTrailingRadius: mayorRadius
            )
            .fill(.gray.quaternary)
            .padding(.init(top: padding, leading: padding, bottom: .zero, trailing: padding))
            .ignoresSafeArea()
        }

    SafeAreaPad(edge: .top)
        .safeAreaInset(edge: .top, spacing: .zero) {
            CaptionRectangle(
                "Top SafeArea", fill: .green.gradient.quaternary,
                width: 100, height: safeAreaInset,
                traits: .height, .alignment(.outerTrailing))
        }

    VisibleSpacer()

    Slider.captioned(
        "SafeArea",
        value: $safeAreaInset,
        in: 0...100,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger
    )
    .padding()

    VisibleSpacer()

    SafeAreaPad(edge: .bottom)
    .safeAreaInset(edge: .bottom, spacing: .zero) {
        CaptionRectangle(
            "Bottom SafeArea", fill: .green.gradient.quaternary,
            width: 100, height: safeAreaInset,
            traits: .height, .alignment(.outerLeading))
    }

    Text("Device Edge")
        .font(.caption)
        .foregroundStyle(.tertiary)
        .padding(.top, 8)
        .maxWidthFrame()
        .background {
            let padding: CGFloat = 12
            let minorRadius: CGFloat = 4
            // There not enough bottom space so shoot it up!
            let mayorRadius: CGFloat = .infinity
            UnevenRoundedRectangle(
                topLeadingRadius: minorRadius,
                bottomLeadingRadius: mayorRadius,
                bottomTrailingRadius: mayorRadius,
                topTrailingRadius: minorRadius
            )
            .fill(.gray.quaternary)
            .padding(.init(top: 0, leading: padding, bottom: padding, trailing: padding))
            .ignoresSafeArea()
        }
}
