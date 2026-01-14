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

        Text("SafeAreaPad")
            .foregroundStyle(.quaternary)
            .font(.caption)
            // This first Text sets the minimum size of the view, but it remains invisible.
            .hidden()
            .maxWidthFrame()
            // Padding from edge of view, to match background padding.
            .padding(.all)
            // Padding from edge of background.
            .padding(8)
            .background {
                ConcentricRectangle(minimumConcentricRadius: HeaderFooterContainer.minimumConcentricRadius)
                .fill(.orange.tertiary)
                .padding(.all)
                .ignoresSafeArea()
            }
            .overlay {
                GeometryReader { geometry in
                    ZStack(alignment: .bottom) {
                        Text("centered, bottomSafeArea: \(geometry.safeAreaInsets.bottom, format: .fractionLength(2))")
                            .font(.caption)
                            .monospacedDigit()
                            .padding(2)
                            .alignmentGuide(VerticalAlignment.bottom) { dimentions in
                                let minDistanceFromBottom: CGFloat = (geometry.size.height - dimentions.height) / 2
                                return dimentions[.bottom] + max(minDistanceFromBottom, geometry.safeAreaInsets.bottom)
                            }

                        if geometry.safeAreaInsets.bottom > 0 {
                            Rectangle()
                                .fill(.tertiary)
                                .padding(.horizontal)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity, maxHeight: 1)
                                .alignmentGuide(VerticalAlignment.bottom) { dimentions in
                                    return dimentions[.bottom] + geometry.safeAreaInsets.bottom
                                }
                        }

                        // This retangle remains aligned to the bottom, allowing the other views to
                        // offset their position.
                        ClearRectangle(height: 10)
                    }
                    .alignmentGuide(VerticalAlignment.bottom) { $0[.bottom] - geometry.safeAreaInsets.bottom }
                    .frame(width: geometry.size.width, height: geometry.size.height, alignment: .bottom)
                    .ignoresSafeArea(edges: .bottom)
                } // GeometryReader
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

    Spacer()

    SafeAreaPad()
        .debugOverlay(.bordersWidth(2))

    Spacer()

    SafeAreaPad()
        .debugOverlay(.bordersWidth(2))
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
            .floatingCaption("Bottom SafeArea", .height, .border, .alignment(.outer(.trailingCenter)))
    }

    Divider()
}
