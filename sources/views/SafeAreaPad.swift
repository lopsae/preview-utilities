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

        SizingView()
        .background {
            ConcentricBackground(fill: .orange.tertiary)
            .ignoresSafeArea()
        }
        .overlay {
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
                // FIXME: Add geometry reader extension that aligns with a frame.
                .frame(size: geometry.size, alignment: alignment)
            } // GeometryReader
        } // overlay

        if showDivider && edge == .top {
            DashedDivider()
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


// MARK: - SizingView


/// Base that determines the overall size of the `SafeAreaPad`.
///
/// This view is used only to determine the size the `SafeAreaPad` will use, without displaying
/// anything on its own. Backgrounds and overlays are applied to to draw content.
///
/// The height is determined by a hidden text and enough paddings to allow a minimum amount of
/// background around the text displayed in `SafeAreaPad`.
///
/// The height of this view is always: text.height + 2*defaultPaddings + 2*halfPaddings
private struct SizingView: View {
    var body: some View {
        Text("SafeAreaPad")
        .font(.caption)
        .hidden()
        .expandingWidthFrame()
        // Padding from edge of view, to match background padding.
        .padding(.all)
        // Padding from edge of background.
        .padding(Defaults.padding / 2)
    }
}


// MARK: - ConcentricBackground


private struct ConcentricBackground<Style: ShapeStyle>: View {
    let fill: Style
    let padding: CGFloat?

    init(fill: Style, padding: CGFloat? = nil) {
        self.fill = fill
        self.padding = padding
    }

    var body: some View {
        ConcentricRectangle(minimumConcentricRadius: HeaderFooterContainer.minimumConcentricRadius)
        .fill(fill)
        .padding(.all, padding)
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
            let majorRadius: CGFloat = 55
            UnevenRoundedRectangle(
                topLeadingRadius: majorRadius,
                bottomLeadingRadius: minorRadius,
                bottomTrailingRadius: minorRadius,
                topTrailingRadius: majorRadius
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
            let majorRadius: CGFloat = .infinity
            UnevenRoundedRectangle(
                topLeadingRadius: minorRadius,
                bottomLeadingRadius: majorRadius,
                bottomTrailingRadius: majorRadius,
                topTrailingRadius: minorRadius
            )
            .fill(.gray.quaternary)
            .padding(.init(top: 0, leading: padding, bottom: padding, trailing: padding))
            .ignoresSafeArea()
        }
}


#Preview("Sizing", traits: .spacing(8), PreviewContent.layout) {
    SizingView()
    .background {
        ConcentricBackground(fill: .orange.tertiary, padding: 8)
        .ignoresSafeArea()
    }
    .floatingCaption("SizingView", .alignment(.outerBottomTrailing), .colorStyle(.orange))

    VisibleSpacer()

    SizingView()
    .background {
        ConcentricBackground(fill: .orange.tertiary, padding: 8)
        .ignoresSafeArea()
    }
    .floatingCaption("SizingView", .alignment(.outerBottomTrailing), .colorStyle(.orange))

    VisibleSpacer()

    SizingView()
    .background {
        ConcentricBackground(fill: .orange.tertiary, padding: 8)
        .ignoresSafeArea()
    }
    .floatingCaption("SizingView", .alignment(.outerTopTrailing), .colorStyle(.orange))
}


// FIXME: Move to own file.


extension GeometryReader {

    init<AlignedContent: View>(
        alignment: Alignment,
        @ViewBuilder content: @escaping (GeometryProxy) -> AlignedContent
    )
    where Content == Framed<AlignedContent>
    {
        self.init { geometry in
            Framed(alignment: alignment, size: geometry.size) {
                content(geometry)
            }
        }
    }

}


struct Framed<Content> : View
    where Content: View
{
    let alignment: Alignment
    let size: CGSize
    @ViewBuilder let content: Content

    var body: some View {
        content
        .frame(size: size, alignment: alignment)
    }
}


#Preview("GeoReader", traits: .spacing(100), PreviewContent.layout) {
    GeometryReader(alignment: .topLeading) { geometry in
        CaptionRectangle("Fixed Size", color: .brown, size: .square(of: 120), traits: .alignment(.outerBottomTrailing))
        CaptionRectangle("Geometry Size", color: .indigo, size: geometry.size, traits: .size, .alignment(.leading))
    }
    .frame(squareOf: 100)

    GeometryReader(alignment: .bottomTrailing) { geometry in
        CaptionRectangle("Fixed Size", color: .brown, size: .square(of: 120), traits: .alignment(.outerBottomTrailing))
        CaptionRectangle("Geometry Size", color: .indigo, size: geometry.size, traits: .size, .alignment(.leading))
    }
    .frame(squareOf: 100)

    GeometryReader(alignment: .bottom) { geometry in
        CaptionRectangle("Fixed Size", color: .brown, size: .square(of: 120), traits: .alignment(.outerBottomTrailing))
        CaptionRectangle("Geometry Size", color: .indigo, size: geometry.size, traits: .size, .alignment(.leading))
    }
    .frame(squareOf: 100)
}
