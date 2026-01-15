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
            Divider()
        }

        sizingViewWithBackground
        .overlay {
            GeometryReader { geometry in
                let containerHeight = geometry.size.height
                let safeArea = geometry.safeAreaInsets[edge: edge]
                let guidedAlignment: VerticalAlignment = switch edge {
                case .top:    .top
                case .bottom: .bottom
                }
                let alignment: Alignment = .init(horizontal: .center, vertical: guidedAlignment)

                ZStack(alignment: alignment) {
                    Text("centered, safeArea: \(safeArea, format: .fractionLength(2))")
                    .font(.caption)
                    .monospacedDigit()
                    .alignmentGuide(guidedAlignment) { dimentions in
                        let padding = Defaults.padding

                        // Container height, removing the top padding. This is the area
                        // where the label can be.
                        let unpaddedContainerHeight = containerHeight - padding

                        let distanceFromBottom: CGFloat
                        if safeArea > padding {
                            // Label is centered in available container area, and pushed up
                            // by the entire safeArea.
                            distanceFromBottom = safeArea + unpaddedContainerHeight / 2
                        } else {
                            // Fraction of safe area bitting into the available container area.
                            let remainingPadding = padding - safeArea
                            let centerOfContainerHeight = (unpaddedContainerHeight - remainingPadding) / 2
                            // Label is always pushed up in this case by 1 padding.
                            distanceFromBottom = centerOfContainerHeight + padding
                        }

                        return dimentions[.verticalCenter] + distanceFromBottom
                    }

                    // Safearea indicator
                    if safeArea > 0 {
                        safeAreaIndicator
                        .alignmentGuide(guidedAlignment) { dimentions in
                            return dimentions[guidedAlignment] + safeArea
                        }
                    }

                    // This retangle is required to stay true-bottom aligned to allow the other
                    // views to offset their position.
                    ClearRectangle(height: 10)
                }
//                    .border(.red, width: 2)
                // TODO: convenience func: .alignmenGuide(alignment, offset: value)
                .alignmentGuide(guidedAlignment) { $0[guidedAlignment] - safeArea }
                .frame(size: geometry.size, alignment: alignment)
            } // GeometryReader
//                .border(.green, width: 2)
        } // overlay

        if showDivider && edge == .top {
            Divider()
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


    @ViewBuilder
    private var safeAreaIndicator: some View {
        let lineWidth: CGFloat = 1
        GeometryReader { geometry in
            let strokeStyle = StrokeStyle(
                lineWidth: lineWidth, lineCap: .round, dash: [lineWidth * 5, lineWidth * 5])
            Path { path in
                path.move(to: CGPoint(x: 0, y: lineWidth / 2))
                path.addLine(to: CGPoint(x: geometry.size.width, y: lineWidth / 2))
            }
            .stroke(.tertiary, style: strokeStyle)

        }
        .frame(height: lineWidth)
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
    SafeAreaPad(edge: .top)
    VisibleSpacer()
    SafeAreaPad(edge: .bottom)
    VisibleSpacer()
    SafeAreaPad(edge: .bottom)
}


#Preview("Bottom SafeArea", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var bottomSafeAreaInset: Double = 60

    SafeAreaPad(edge: .top)

    Slider.captioned(
        "Bottom SafeArea",
        value: $bottomSafeAreaInset,
        in: 0...100,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger
    )
    .padding()

    VisibleSpacer()

    SafeAreaPad(edge: .bottom)
    .safeAreaInset(edge: .bottom, spacing: 0) {
        CaptionRectangle(
            "Bottom SafeArea", fill: .green.gradient.quaternary,
            width: 100, height: bottomSafeAreaInset,
            traits: .height, .alignment(.outerTrailing))
    }

    Text("Device Edge")
        .font(.caption)
        .foregroundStyle(.tertiary)
        .padding(.top, 8)
        .maxWidthFrame()
        .background {
            let padding: CGFloat = 12
            UnevenRoundedRectangle(topLeadingRadius: 4, bottomLeadingRadius: .infinity, bottomTrailingRadius: .infinity, topTrailingRadius: 4, style: .continuous)
                .fill(.quaternary)
                .padding(.init(top: 0, leading: padding, bottom: padding, trailing: padding))
                .ignoresSafeArea()
        }
}
