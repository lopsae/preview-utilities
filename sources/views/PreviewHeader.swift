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


#Preview("Paddings", traits: .zeroSpacing, PreviewContent.layout) {
    PreviewHeader(enableTopPadding: PreviewContent.platformEnableTopPadding, flexibleHeight: false)
        .floatingCaption(
            "Platform padding: **`\(PreviewContent.platformEnableTopPadding.description)`**",
            .alignment(.inner(.bottomLeading)),
            .padding(22))
        .debugOverlay(.bordersWidth(2))

    ClearRectangle(height: 40)

    PreviewHeader(enableTopPadding: false, flexibleHeight: false)
        .floatingCaption("**Disabled** padding", .alignment(.inner(.bottomLeading)), .padding(22))
        .debugOverlay(.bordersWidth(2))

    ClearRectangle(height: 40)

    PreviewHeader(enableTopPadding: true, flexibleHeight: false)
        .floatingCaption("**Enabled** padding", .alignment(.inner(.bottomLeading)), .padding(22))
        .debugOverlay(.bordersWidth(2))

    PreviewContent.bottomControls {
        Text(
            "In iOS, when displayed against the preview frame, the header should NOT use top " +
            "padding. In macOS, padding is added to prevent the header text from touching the" +
            "bottom of the window."
        ).maxWidthFrame(alignment: .leading)
        Text(
            "There is no known way to add this conditional padding automatically without introducing issues."
        ).maxWidthFrame(alignment: .leading)
    }
}


#Preview("SafeArea", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var topSafeAreaInset: Double = 60
    @Previewable @State var useDeviceSafeArea: Bool = false
    @Previewable @State var enableTopPadding: Bool = PreviewContent.platformEnableTopPadding
    @Previewable @State var isFlexible: Bool = true

    if !useDeviceSafeArea {
        Text("clear from device safe area")
            .font(.caption)
            .maxWidthFrame()
            .concentricSafeAreaBackground(fill: .orange.tertiary, contentPaddingEdges: .not(.top))
        Divider()
    }

    PreviewHeader(enableTopPadding: enableTopPadding, flexibleHeight: isFlexible)
    .safeAreaInset(edge: .top, spacing: .zero) {
        Rectangle()
            .fill(.green.quaternary)
            .frame(width: 100, height: topSafeAreaInset)
            .floatingCaption("Top SafeArea", .height, .border, .alignment(.outer(.trailingCenter)))
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
