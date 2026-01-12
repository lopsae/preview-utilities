//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct AutoPaddedPreviewFooter: View {

    @State private var paddedHeight: CGFloat = 0.0
    @State private var fullHeight: CGFloat = 0.0

    let flexibleHeight: Bool

    fileprivate var printsUpdates: Bool = false


    init(flexibleHeight: Bool = true) {
        self.flexibleHeight = flexibleHeight
    }


    var body: some View {
        VStack(spacing: 0) {
            if flexibleHeight {
                Spacer()
            }

            Text("Footer")
                .foregroundStyle(.tertiary)
                // Double padding to separate one padding from background,
                // which is padded once from views edge.
                .padding(.top)
                .padding(.top)
                .minimumSafeAreaPadding(.bottom, minimumInset: textMinimumBottomSafeArea, printsUpdates: printsUpdates)
                .maxWidthFrame()
        }  // VStack
        .background {
            ConcentricRectangle(minimumConcentricRadius: HeaderFooterContainerView.minimumConcentricRadius)
                .fill(HeaderFooterContainerView.backgroundStyle)
                // TODO: reevaluate if keeping this approach for logging.
                .onGeometryChange(of: \.size.height, binding: $paddedHeight.onSet { newValue in
                    if printsUpdates {
                        print("update paddedHeight:\(newValue)")
                    }
                })
                .padding()
                .onGeometryChange(keyPath: \.size.height) { newHeight in
                    if printsUpdates {
                        print("update fullHeight:\(newHeight)")
                    }
                    fullHeight = newHeight
                }
                .ignoresSafeArea()
        }  // background
    }


    // FIXME: also implement prevent small updates to this, keep it in integers
    private var textMinimumBottomSafeArea: CGFloat {
        let onePadding = (fullHeight - paddedHeight) / 2.0
        return onePadding * 2.0
    }

}


// MARK: - Preview utilities


extension AutoPaddedPreviewFooter {

    fileprivate func preview_printsUpdates(_ enable: Bool) -> Self {
        var mutableSelf = self
        mutableSelf.printsUpdates = enable
        return mutableSelf
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
    @Previewable @State var isFlexible: Bool = true
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

    AutoPaddedPreviewFooter(flexibleHeight: isFlexible)
        .preview_printsUpdates(true)
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

    AutoPaddedPreviewFooter(flexibleHeight: isFlexible)
    .preview_printsUpdates(true)
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
