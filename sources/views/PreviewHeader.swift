//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct PreviewHeader: View {

    @State private var paddedHeight: Double = 0
    @State private var fullHeight: Double = 0
    @State private var topSafeArea: Double = 0

    let flexibleHeight: Bool

    fileprivate var printsUpdates: Bool = false


    init(flexibleHeight: Bool = true) {
        self.flexibleHeight = flexibleHeight
    }


    var body: some View {
        VStack(spacing: 0) {

            Text("Header")
                .foregroundStyle(.tertiary)
                .padding(.top, textTopPadding)
                // Double padding to separate one padding from background,
                // which is padded once from views edge.
                .padding(.bottom)
                .padding(.bottom)
                .maxWidthFrame()
                .onGeometryChange(of: \.safeAreaInsets.top) { newTopSafeArea in
                    if printsUpdates {
                        print("update topSafeArea:\(newTopSafeArea)")
                    }
                    topSafeArea = newTopSafeArea
                }

            if flexibleHeight {
                Spacer()
            }

        }  // VStack
        .background {
            ConcentricRectangle(minimumConcentricRadius: HeaderFooterPreview<EmptyView>.minConcentricRoundedCornerRadius)
                .fill(.gray.tertiary)
                .onGeometryChange(of: \.size.height) { newHeight in
                    if printsUpdates {
                        print("update paddedHeight:\(newHeight)")
                    }
                    paddedHeight = newHeight
                }
                .padding()
                .onGeometryChange(of: \.size.height) { newHeight in
                    if printsUpdates {
                        print("update fullHeight:\(newHeight)")
                    }
                    fullHeight = newHeight
                }
                .ignoresSafeArea()
        }  // background
    }


    private var textTopPadding: Double {
        let onePadding = (fullHeight - paddedHeight) / 2.0
        let minPadding = onePadding * 1.5
        let possiblePadding = minPadding - topSafeArea
        return max(0, possiblePadding)

    }

}


// MARK: - Preview utilities.

extension PreviewHeader {

    fileprivate func preview_printsUpdates() -> Self {
        var mutableSelf = self
        mutableSelf.printsUpdates = true
        return mutableSelf
    }

}


// MARK: - Previews.


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .fixedLayout(width: 400, height: 600)

}


#Preview(traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var isFlexible: Bool = true

    PreviewHeader(flexibleHeight: isFlexible)
        .preview_printsUpdates()

    Divider()

    ConcentricRectangle(minimumConcentricRadius: HeaderFooterPreview<EmptyView>.minConcentricRoundedCornerRadius)
    .fill(.orange)
    .overlay(alignment: .bottom) {
        VStack {
            Toggle("Flexible height", isOn: $isFlexible)
        }
        .padding()
    } // overlay
    .padding()
    .ignoresSafeArea()
}

#Preview("SafeArea", traits: .zeroSpacing, PreviewContent.layout) {

    @Previewable @State var topSafeAreaInset: Double = 60.0
    @Previewable @State var useDeviceSafeArea: Bool = false
    @Previewable @State var isFlexible: Bool = false

    let sliderRange: ClosedRange<Double> = 0.0...100.0

    if !useDeviceSafeArea {
        Text("clear from device safe area")
        .font(.caption)
        .maxWidthFrame()
        .padding(.bottom)
        .padding(.bottom)
        .background {
            ConcentricRectangle(minimumConcentricRadius: HeaderFooterPreview<EmptyView>.minConcentricRoundedCornerRadius)
                .fill(.orange.tertiary)
                .padding()
                .ignoresSafeArea()
        }
    }

    PreviewHeader(flexibleHeight: isFlexible)
    .preview_printsUpdates()
    .safeAreaInset(edge: .top, spacing: 0) {
        let roundedHeight = topSafeAreaInset.rounded(.toNearestOrEven)
        Rectangle()
            .fill(.red.opacity(0.1))
            .frame(height: roundedHeight)
            .debugOutline(options: .size, .safeAreaInsets, .infoOutside)
    }

    Divider()

    ConcentricRectangle(minimumConcentricRadius: HeaderFooterPreview<EmptyView>.minConcentricRoundedCornerRadius)
    .fill(.orange)
    .overlay(alignment: .bottom) {
        VStack {
            Slider(
                "Top SafeArea",
                value: $topSafeAreaInset,
                in: sliderRange
            ) {
                Text(topSafeAreaInset, format: .roundedIntegerToNearestOrEven)
            } boundsValueLabel: { boundValue in
                Text(boundValue, format: .roundedIntegerToNearestOrEven)
                    .monospaced()
            }
            Text("Top SafeArea: \(topSafeAreaInset, format: .roundedIntegerToNearestOrEven)")
                .monospaced()

            Toggle("Use device safe area", isOn: $useDeviceSafeArea)
            Toggle("Flexible height", isOn: $isFlexible)

        }
        .padding()
    } // overlay
    .padding()
    .ignoresSafeArea()

}
