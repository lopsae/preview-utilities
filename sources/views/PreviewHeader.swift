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
        VStack(spacing: .zero) {
            Text("Header")

            if flexibleHeight {
                ClearRectangle()
            }
        }  // VStack
        .foregroundStyle(.tertiary)
        .maxWidthFrame()
        .concentricSafeAreaBackground(
            fill: HeaderFooterContainer.backgroundStyle,
            contentPaddingEdges: contentPaddingEdges,
            safeAreaPaddingEdges: .not(.top))
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeForcedLayout

    /// Representative of behaviour used in ``HeaderFooterPreviewModifier``, where the header is
    /// always displayed in a preview where in iOS there is a top and bottom safe-area.
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

    DashedDivider()

    CaptionRectangle(
        "Fixed Content", color: .red,
        width: 150, height: fixedHeight,
        traits: .height)

    DashedDivider()

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


#Preview("Paddings", traits: .zeroSpacing, PreviewContent.layout) {
    PreviewHeader(enableTopPadding: PreviewContent.platformEnableTopPadding, flexibleHeight: false)
        .floatingCaption(
            "Platform padding: **`\(PreviewContent.platformEnableTopPadding.description)`**",
            .alignment(.inner(.bottomLeading)),
            .padding(22))
        .debugOverlay(.bordersWidth(2))

    VisibleSpacer()

    PreviewHeader(enableTopPadding: false, flexibleHeight: false)
        .floatingCaption("**Disabled** padding", .alignment(.inner(.bottomLeading)), .padding(22))
        .debugOverlay(.bordersWidth(2))

    VisibleSpacer()

    PreviewHeader(enableTopPadding: true, flexibleHeight: false)
        .floatingCaption("**Enabled** padding", .alignment(.inner(.bottomLeading)), .padding(22))
        .debugOverlay(.bordersWidth(2))

    VisibleSpacer()

    PreviewContent.bottomControls {
        Text(
            "In iOS, when displayed against the preview frame, the header should NOT use top " +
            "padding. In macOS, padding is added to prevent the header text from touching the" +
            "bottom of the window."
        )
        .fixedSize(horizontal: false, vertical: true)
        .maxWidthFrame(alignment: .leading)
    }
}


#Preview("SafeArea", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var topSafeAreaInset: Double = 60
    @Previewable @State var useDeviceSafeArea: Bool = false
    @Previewable @State var enableTopPadding: Bool = PreviewContent.platformEnableTopPadding
    @Previewable @State var isFlexible: Bool = true

    if !useDeviceSafeArea {
        SafeAreaPad(edge: .top, showDivider: true)
    }

    PreviewHeader(enableTopPadding: enableTopPadding, flexibleHeight: isFlexible)
    .safeAreaInset(edge: .top, spacing: .zero) {
        CaptionRectangle(
            "Top SafeArea", fill: .green.gradient.quaternary,
            width: 100, height: topSafeAreaInset,
            traits: .height, .alignment(.outerTrailing))
    }

    Divider()

    PreviewContent.bottomControls {
        Slider.captioned(
            "Top SafeArea",
            value: $topSafeAreaInset,
            in: 0...100,
            currentValueFormat: .fractionLength(2),
            boundsValueFormat: .arithmeticRoundedInteger)

        Toggle("Use device safe area", isOn: $useDeviceSafeArea)
        Toggle("Flexible Height", isOn: $isFlexible)
        Toggle("Enable Top Padding", isOn: $enableTopPadding)
        Text("Platform default: \(PreviewContent.platformEnableTopPadding.description)")
            .font(.caption.monospaced())
    }

}
