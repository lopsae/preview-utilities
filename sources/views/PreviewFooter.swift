//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct PreviewFooter: View {

    let flexibleHeight: Bool


    init(flexibleHeight: Bool = true) {
        self.flexibleHeight = flexibleHeight
    }


    var body: some View {
        VStack {
            if flexibleHeight {
                Spacer()
            }

            Text("Footer")
            Image(systemName: "shoeprints.fill")
        }  // VStack
        .foregroundStyle(.tertiary)
        .maxWidthFrame()
        #if os(macOS)
        // Keep bottom paddins, since macOS does not have a bottom safe area.
        .concentricSafeAreaBackground(
            fill: HeaderFooterContainerView.backgroundStyle)
        #else
        .concentricSafeAreaBackground(
            fill: HeaderFooterContainerView.backgroundStyle,
            contentPaddingEdges: .not(.bottom),
            safeAreaPaddingEdges: .not(.bottom))
        #endif
    }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    @ViewBuilder
    static func topControls(@ViewBuilder content: () -> some View) -> some View {
        VStack {
            content()
        }
        .maxWidthFrame()
        .concentricSafeAreaBackground(fill: .orange, contentPaddingEdges: .not(.top))

        Text("Flexible")
        .foregroundStyle(.secondary)
        .maxSizeFrame()
        .concentricSafeAreaBackground(fill: .orange, paddingEdges: .not(.top))
    }

}


#Preview("Default", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var isFlexible: Bool = true
    @Previewable @State var fixedHeight: Double = 400

    printOnce.view

    PreviewContent.topControls {
        Toggle("Flexible Height", isOn: $isFlexible)
        Slider.captioned(
            "Fixed Content Height",
            value: $fixedHeight,
            in: 0...800,
            currentValueFormat: .fractionLength(2),
            boundsValueFormat: .arithmeticRoundedInteger)
    }

    Divider()

    Rectangle().fill(.red.tertiary)
        .frame(width: 200, height: fixedHeight)
        .floatingCaption("Fixed Content Height", .height, .border)

    Divider()

    PreviewFooter(flexibleHeight: isFlexible)
}


#Preview("SafeArea", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var bottomSafeAreaInset: Double = 60
    @Previewable @State var useDeviceSafeArea: Bool = false
    @Previewable @State var isFlexible: Bool = true

    printOnce.view

    PreviewContent.topControls {
        Slider.captioned(
            "Bottom SafeArea",
            value: $bottomSafeAreaInset,
            in: 0...100,
            currentValueFormat: .fractionLength(2),
            boundsValueFormat: .arithmeticRoundedInteger)

        Toggle("Use device safe area", isOn: $useDeviceSafeArea)
        Toggle("Flexible Height", isOn: $isFlexible)
    }

    Divider()

    PreviewFooter(flexibleHeight: isFlexible)
    .safeAreaInset(edge: .bottom, spacing: 0) {
        Rectangle()
            .fill(.green.quaternary)
            .frame(width: 200, height: bottomSafeAreaInset)
            .floatingCaption("Bottom SafeArea", .height, .border)
    }

    if !useDeviceSafeArea {
        Text("clear from device safe area")
        .font(.caption)
        .maxWidthFrame()
        .concentricSafeAreaBackground(fill: .orange.tertiary)
    }

}


#Preview("Comparison", traits: .zeroSpacing, PreviewContent.layout) {
    PreviewContent.topControls {
        Text(
            "In situations where there is no safe-area, the footer will display touching the bottom " +
            "of the view."
        )
        Text(
            "There is no current way to add this conditional padding without introducing issues."
        )
    }
    .font(.caption)
    PreviewFooter(flexibleHeight: false)
        .debugOverlay(.hairline)
    Divider()
    PreviewFooter(flexibleHeight: false)
        .debugOverlay(.hairline)
}


// FIXME: add similar previews with fixed size for Header view
// FIXME: add similar previews with fixed size for HeaderFooter
