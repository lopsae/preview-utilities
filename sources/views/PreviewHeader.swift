//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct PreviewHeader: View {

    let enableTopPadding: Bool
    let flexibleHeight: Bool


    init(enableTopPadding: Bool, flexibleHeight: Bool = true) {
        self.enableTopPadding = enableTopPadding
        self.flexibleHeight = flexibleHeight
    }


    var body: some View {
        let contentPaddingEdges: Edge.Set = enableTopPadding
            ? .all
            : .not(.top)
        VStack(spacing: 0) {
            Text("Header")

            if flexibleHeight {
                ClearRectangle()
            }
        }  // VStack
        .foregroundStyle(.tertiary)
        .maxWidthFrame()
        .concentricSafeAreaBackground(
            fill: HeaderFooterContainerView.backgroundStyle,
            contentPaddingEdges: contentPaddingEdges,
            safeAreaPaddingEdges: .not(.top))
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    /// Representative of behaviour used in ``HeaderFooterPreviewModifier``, where the header is
    /// always displayed in a preview, and in iOS there is a bottom safe-area present.
    static var platformEnableTopPadding: Bool {
        #if os(macOS)
        true
        #else
        false
        #endif
    }

    @ViewBuilder
    static func bottomControls(@ViewBuilder content: () -> some View) -> some View {
        Text("Flexible")
        .foregroundStyle(.secondary)
        .font(.caption)
        .maxSizeFrame()
        .concentricSafeAreaBackground(fill: .orange, paddingEdges: .not(.bottom))

        VStack {
            content()
        }
        .maxWidthFrame()
        .concentricSafeAreaBackground(fill: .orange)
    }

}


// MARK: - Previews


#Preview("Default", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var enableTopPadding: Bool = PreviewContent.platformEnableTopPadding
    @Previewable @State var isFlexible: Bool = true
    @Previewable @State var fixedHeight: Double = 400

    PreviewHeader(enableTopPadding: enableTopPadding, flexibleHeight: isFlexible)

    Divider()

    Rectangle().fill(.red.tertiary)
        .frame(width: 150, height: fixedHeight)
        .floatingCaption("Fixed Content Height", .height, .border)

    Divider()

    PreviewContent.bottomControls {
        Slider.captioned(
            "Fixed Height",
            value: $fixedHeight,
            in: 0...800,
            currentValueFormat: .fractionLength(2),
            boundsValueFormat: .arithmeticRoundedInteger)

        Toggle("Flexible height", isOn: $isFlexible)
        Toggle("Enable Top Padding", isOn: $enableTopPadding)
        Text("Platform default: \(PreviewContent.platformEnableTopPadding.description)")
            .font(.caption.monospaced())
    }
}


#Preview("SafeArea", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var topSafeAreaInset: Double = 60
    @Previewable @State var useDeviceSafeArea: Bool = false
    @Previewable @State var isFlexible: Bool = true

    printOnce.view
    if !useDeviceSafeArea {
        Text("clear from device safe area")
        .font(.caption)
        .maxWidthFrame()
        .concentricSafeAreaBackground(fill: .orange.tertiary, contentPaddingEdges: .not(.top))
    }

    PreviewHeader(enableTopPadding: true, flexibleHeight: isFlexible)
    .safeAreaInset(edge: .top, spacing: .zero) {
        Rectangle()
            .fill(.red.opacity(0.1))
            .frame(height: topSafeAreaInset)
            .debugOverlay(.hairline, .size, .safeAreaInsets, .outerInfo)
            .padding(.horizontal, 8)
    }

    Divider()

    PreviewContent.bottomControls {
        Slider(
            "Top SafeArea",
            value: $topSafeAreaInset,
            in: 0...100,
            currentValueFormat: .arithmeticRoundedInteger,
            boundsValueFormat: .arithmeticRoundedInteger
        )
        Text("Top SafeArea: \(topSafeAreaInset, format: .fractionLength(2))")
            .monospaced()

        Toggle("Use device safe area", isOn: $useDeviceSafeArea)
        Toggle("Flexible height", isOn: $isFlexible)
    }

}
