//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct PreviewFooter: View {

    let enableBottomPadding: Bool
    let flexibleHeight: Bool


    init(enableBottomPadding: Bool, flexibleHeight: Bool = true) {
        self.enableBottomPadding = enableBottomPadding
        self.flexibleHeight = flexibleHeight
    }


    var body: some View {
        let paddingEdges: Edge.Set = enableBottomPadding
            ? .all
            : .not(.bottom)
        VStack {
            if flexibleHeight {
                Spacer()
            }

            Text("Footer")
            Image(systemName: "shoeprints.fill")
        }  // VStack
        .foregroundStyle(.tertiary)
        .maxWidthFrame()
        .concentricSafeAreaBackground(
            fill: HeaderFooterContainerView.backgroundStyle,
            contentPaddingEdges: paddingEdges,
            safeAreaPaddingEdges: paddingEdges)
    }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    /// Representative of settings used in ``HeaderFooterPreviewModifier``, where the footer is
    /// always displayed in a preview, and in iOS there is a bottom safe-area present.
    static var platformEnableBottomPadding: Bool {
        #if os(macOS)
        true
        #else
        false
        #endif
    }

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
    @Previewable @State var enableBottomPadding: Bool = PreviewContent.platformEnableBottomPadding
    @Previewable @State var isFlexible: Bool = true
    @Previewable @State var fixedHeight: Double = 400

    printOnce.view

    PreviewContent.topControls {
        Toggle("Flexible Height", isOn: $isFlexible)
        Toggle("Enable Bottom Padding", isOn: $enableBottomPadding)
        Text("Platform default: \(PreviewContent.platformEnableBottomPadding.description)")
            .font(.caption.monospaced())

        Slider.captioned(
            "Fixed Content Height",
            value: $fixedHeight,
            in: 0...800,
            currentValueFormat: .fractionLength(2),
            boundsValueFormat: .arithmeticRoundedInteger)
    }

    Divider()

    Rectangle().fill(.red.tertiary)
        .frame(width: 150, height: fixedHeight)
        .floatingCaption("Fixed Content Height", .height, .border)

    Divider()

    PreviewFooter(enableBottomPadding: enableBottomPadding, flexibleHeight: isFlexible)
}


#Preview("Paddings", traits: .zeroSpacing, PreviewContent.layout) {
    PreviewContent.topControls {
        Text(
            "In iOS, when displayed against the preview frame, the footer should NOT use bottom " +
            "bottom padding. In macOS, padding is added to prevent the footer text of touching " +
            "the bottom of the window."
        )
        Text(
            "There is no current way to add this conditional padding without introducing issues."
        )
    }
    .font(.caption)

    PreviewFooter(enableBottomPadding: true, flexibleHeight: false)
        .floatingCaption("**Enabled** padding", .alignment(.inner(.topLeading)), .padding(25))
        .debugOverlay(.bordersWidth(2))

    Spacer()

    PreviewFooter(enableBottomPadding: false, flexibleHeight: false)
        .floatingCaption("**Disabled** padding", .alignment(.inner(.topLeading)), .padding(25))
        .debugOverlay(.bordersWidth(2))

    Spacer()

    PreviewFooter(enableBottomPadding: PreviewContent.platformEnableBottomPadding, flexibleHeight: false)
        .floatingCaption(
            "Platform padding: **`\(PreviewContent.platformEnableBottomPadding.description)`**",
            .alignment(.inner(.topLeading)),
            .padding(25))
        .debugOverlay(.bordersWidth(2))
}


#Preview("SafeArea", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var bottomSafeAreaInset: Double = 60
    @Previewable @State var useDeviceSafeArea: Bool = false
    @Previewable @State var enableBottomPadding: Bool = PreviewContent.platformEnableBottomPadding
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
        Toggle("Enable Bottom Padding", isOn: $enableBottomPadding)
        Text("Platform default: \(PreviewContent.platformEnableBottomPadding.description)")
            .font(.caption.monospaced())
    }

    Divider()

    PreviewFooter(enableBottomPadding: enableBottomPadding, flexibleHeight: isFlexible)
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


// FIXME: add similar previews with fixed size for Header view
// FIXME: add similar previews with fixed size for HeaderFooter
