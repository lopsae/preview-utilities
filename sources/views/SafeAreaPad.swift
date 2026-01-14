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
                            .padding(2)
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
                            Rectangle()
                                .fill(.tertiary)
                                .padding(.horizontal)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, maxHeight: 1)
                                .alignmentGuide(.bottom) { dimentions in
                                    return dimentions[.bottom] + bottomSafeArea
                                }
                        }

                        // This retangle remains aligned to the bottom, allowing the other views to
                        // offset their position.
                        ClearRectangle(height: 10)
                    }
                    .border(.red, width: 2)
                    .alignmentGuide(.bottom) { $0[.bottom] - bottomSafeArea }
                    .frame(size: geometry.size, alignment: .bottom)
                } // GeometryReader
                .border(.green, width: 2)
            }

        if (bottomDivider) {
            Divider()
        }
    }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


#Preview("Defaults", traits: PreviewContent.layout) {
    SafeAreaPad()
        .debugOverlay(.bordersWidth(2))

    VisibleSpacer()

    SafeAreaPad()
        .debugOverlay(.bordersWidth(2))

    VisibleSpacer()

    SafeAreaPad()
        .debugOverlay(.bordersWidth(2), .size)
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

    Divider()
}
