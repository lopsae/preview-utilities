//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//

import SwiftUI

struct PreviewHeader: View {

    @State private var heightPadded: Double = 0
    @State private var heightComplete: Double = 0
    @State private var headerTopPadding: Double = 0

    let flexibleSize: Bool = true

    var body: some View {
        VStack(spacing: 0) {

            Text("Header")
                .foregroundStyle(.tertiary)
                // Double padding to separate one padding from background,
                // which is padded once from views edge.
                .padding(.top, headerTopPadding)
                .padding(.bottom)
                .padding(.bottom)
                .maxWidthFrame()
                // TODO: possible utility?
                .onGeometryChange(for: Double.self) { geometry in
                    geometry.safeAreaInsets.top
                } action: { newTopSafeArea in
                    let topPadding = minHeaderTopPadding - newTopSafeArea
                    headerTopPadding = max(0, topPadding)
                }

            if flexibleSize {
                Spacer()
            }

        }  // VStack
        .background {
            ConcentricRectangle(corners: .concentric(minimum: .fixed(HeaderFooterPreview<EmptyView>.minConcentricRoundedCornerRadius)))
                .fill(.gray.tertiary)
                // TODO: possible utility? .onGeometryChange(\.size.height) { ... }
                .onGeometryChange(for: Double.self) { geometry in
                    geometry.size.height
                } action: { newHeight in
                    heightPadded = newHeight
                }
                .padding()
                // TODO: possible utility? .onGeometryChange(\.size.height) { $0 - heightPadded } : { padding = $0 }
                .onGeometryChange(for: Double.self) { geometry in
                    geometry.size.height
                } action: { newHeight in
                    heightComplete = newHeight
                }
                .ignoresSafeArea()
        }  // background
    }

    private var minHeaderTopPadding: Double {
        (heightComplete - heightPadded) * 1.5 / 2.0
    }

}

// MARK: - Previews.


@MainActor
private struct PreviewContent {

     static let previewLayout: PreviewTrait<Preview.ViewTraits> = .fixedLayout(width: 400, height: 600)

}


#Preview(traits: .zeroSpacing, PreviewContent.previewLayout) {
    PreviewHeader()
    Divider()
    ConcentricRectangle(corners: .concentric(minimum: 12))
        .fill(.orange)
        .padding()
        .ignoresSafeArea()
}

#Preview("SafeArea", traits: .zeroSpacing, PreviewContent.previewLayout) {

    @Previewable @State var topSafeAreaInset: Double = 60.0
    let sliderRange: ClosedRange<Double> = 0.0...100.0

    PreviewHeader()
    .safeAreaInset(edge: .top, spacing: 0) {
        let roundedHeight = topSafeAreaInset.rounded(.toNearestOrEven)
        Rectangle()
            .fill(.red.opacity(0.2))
            .frame(height: roundedHeight)
            .debugOutline(options: .size, .safeAreaInsets, .infoOutside)
    }

    Divider()

    ConcentricRectangle(corners: .concentric(minimum: .fixed(HeaderFooterPreview<EmptyView>.minConcentricRoundedCornerRadius)))
        .fill(.orange)
        .overlay(alignment: .top) {
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

            }
            .padding()
        } // overlay
        .padding()
        .ignoresSafeArea()

}
