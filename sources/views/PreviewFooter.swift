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


// FIXME: in ios when fixed height content pushes the footer out of the view boundaries, triggers an infinite update to currentSafeAreaInset. Issue does not happen in header.
#Preview("Default", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var isFlexible: Bool = false
    @Previewable @State var fixedHeight: Double = 400

    printOnce.view

    PreviewContent.topControls {
        Toggle("Flexible height", isOn: $isFlexible)
        Slider(
            "Fixed Height",
            value: $fixedHeight,
            in: 0...800,
            valueFormat: .arithmeticRoundedInteger)
    }

    Divider()

    Rectangle().fill(.red.tertiary)
        .frame(width: 100, height: fixedHeight)
        .debugOverlay(.hairline, .size)

    Divider()

    PreviewFooter(flexibleHeight: isFlexible)
}


// FIXME: in ios, when using flexible height, if the safeare inset goes under the minimum, a infinite update of currentSafeAreaInset is triggered. Does not happen in header.
#Preview("SafeArea", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var bottomSafeAreaInset: Double = 60
    @Previewable @State var useDeviceSafeArea: Bool = false
    @Previewable @State var isFlexible: Bool = true

    printOnce.view

    PreviewContent.topControls {
        Slider(
            "Bottom SafeArea",
            value: $bottomSafeAreaInset,
            in: 0...100,
            valueFormat: .arithmeticRoundedInteger)
        Text("Bottom SafeArea: \(bottomSafeAreaInset, format: .fractionLength(2))")
            .monospaced()

        Toggle("Use device safe area", isOn: $useDeviceSafeArea)
        Toggle("Flexible height", isOn: $isFlexible)
    }

    Divider()

    PreviewFooter(flexibleHeight: isFlexible)
    .safeAreaInset(edge: .bottom, spacing: 0) {
        Rectangle()
            .fill(.red.opacity(0.1))
            .frame(width: 200, height: bottomSafeAreaInset)
            .debugOverlay(.hairline, .size, .safeAreaInsets)
            .padding(.horizontal, 8)
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
