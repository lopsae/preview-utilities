//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct SafeAreaPad<S: ShapeStyle>: View {

    let topDivider: Bool
    let bottomDivider: Bool
    let backgroundFill: S


    init(topDivider: Bool = false, bottomDivider: Bool = false, fill: S = .orange.tertiary) {
        self.topDivider = topDivider
        self.bottomDivider = bottomDivider
        self.backgroundFill = fill
    }

    var body: some View {
        if (topDivider) {
            Divider()
        }

        // This first Text sets the minimum height of the view, but it remains invisible.
        // The height of the view is text.height + 2 default-paddings + 2 half-paddings
        Text("SafeAreaPad")
            .foregroundStyle(.quaternary)
            .font(.caption)

            .hidden()
            .maxWidthFrame()
            // Padding from edge of view, to match background padding.
            .padding(.all)
            // Padding from edge of background.
            .padding(DefaultPaddings.both / 2)
            .background {
                ConcentricRectangle(minimumConcentricRadius: HeaderFooterContainer.minimumConcentricRadius)
                .fill(.orange.tertiary)
                .padding(.all)
                .ignoresSafeArea()
            }
            .overlay {
                GeometryReader { geometry in
                    let containerHeight = geometry.size.height
                    let bottomSafeArea = geometry.safeAreaInsets.bottom
                    ZStack(alignment: .bottom) {
                        Text("centered, bottomSafeArea: \(geometry.safeAreaInsets.bottom, format: .fractionLength(2))")
                            .font(.caption)
                            .monospacedDigit()
                            .alignmentGuide(.bottom) { dimentions in
                                let defaultPadding = DefaultPaddings.vertical

                                // Container height, removing the top padding. This is the area
                                // where the label can be.
                                let unpaddedContainerHeight = containerHeight - defaultPadding

                                let distanceFromBottom: CGFloat
                                if bottomSafeArea > defaultPadding {
                                    // Label is centered in available container area, and pushed up
                                    // by the entire safeArea.
                                    distanceFromBottom = bottomSafeArea + unpaddedContainerHeight / 2
                                } else {
                                    // Fraction of safe area bitting into the available container area.
                                    let remainingPadding = defaultPadding - bottomSafeArea
                                    let centerOfContainerHeight = (unpaddedContainerHeight - remainingPadding) / 2
                                    // Label is always pushed up in this case by 1 padding.
                                    distanceFromBottom = centerOfContainerHeight + defaultPadding
                                }

                                return dimentions[.verticalCenter] + distanceFromBottom
                            }

                        // Safearea indicator
                        if bottomSafeArea > 0 {
                            safeAreaIndicator
                            .alignmentGuide(.bottom) { dimentions in
                                return dimentions[.bottom] + bottomSafeArea
                            }
                        }

                        // This retangle remains aligned to the bottom, allowing the other views to
                        // offset their position.
                        ClearRectangle(height: 10)
                    }
//                    .border(.red, width: 2)
                    .alignmentGuide(.bottom) { $0[.bottom] - bottomSafeArea }
                    .frame(size: geometry.size, alignment: .bottom)
                } // GeometryReader
//                .border(.green, width: 2)
            }

        if (bottomDivider) {
            Divider()
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
    SafeAreaPad()
    VisibleSpacer()
    SafeAreaPad()
    VisibleSpacer()
    SafeAreaPad()
}


#Preview("Bottom SafeArea", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var bottomSafeAreaInset: Double = 60

    SafeAreaPad()

    Slider.captioned(
        "Bottom SafeArea",
        value: $bottomSafeAreaInset,
        in: 0...100,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger
    )
    .padding()

    VisibleSpacer()

    SafeAreaPad()
    .safeAreaInset(edge: .bottom, spacing: 0) {
        Rectangle()
            .fill(.green.quaternary)
            .frame(width: 100, height: bottomSafeAreaInset)
            .floatingCaption("Bottom SafeArea", .height, .border, .alignment(.outerTrailingCenter))
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
