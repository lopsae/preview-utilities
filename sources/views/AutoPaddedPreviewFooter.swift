//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Previous implementation of PreviewFooter that uses an experimental approach to automatically
/// pad itself depending on the current safe-areas around the view.
///
/// This aproach involves using `GeometryReaders` to measure the current padding, and using that
/// value as a minimal safe-area padding, which means, changes to the padding or safe area produce
/// a view state change that could produce further changes to the padding or safe area. This is
/// prone to infinite view update loops and this discouraged.
///
/// See ``MinimumSafeAreaPaddingModifier`` for more details on the found issues.
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
                .fill(.purple.tertiary)
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


// When MinimumSafeAreaPaddingModifier used not-stabilized updates (using all updates to safe-areas)
// this preview ran into issues:
// + In iOS, when the fixed content pushes the footer out of the view boundaries:
// + An infinite update to safeAreaInset occurrs, oscilating between very close double values.
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

    AutoPaddedPreviewFooter(flexibleHeight: isFlexible)
        .preview_printsUpdates(true)
}


// When MinimumSafeAreaPaddingModifier used not-stabilized updates (using all updates to safe-areas)
// this preview ran into issues:
// + In iOS, using flexible height, when the safe area inset goes under the minimum:
// + An infinite update to safeAreaInset occurrs, oscilating between very close double values.
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

    AutoPaddedPreviewFooter(flexibleHeight: isFlexible)
    .preview_printsUpdates(true)
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
            "The main issue this implementation was solving is that in some platforms (like macOS) " +
            "and some previews formats there is no safe area at the bottom, where `minSafeAreaPadding` " +
            "would insert padding automatically to keep visual consistency."
        )
        Text(
            "Otherwise, the _Footer_ label ends up touching the bottom of the view."
        )
    }
    .font(.caption)
    AutoPaddedPreviewFooter(flexibleHeight: false)
        .debugOverlay(.hairline)
    Divider()
    AutoPaddedPreviewFooter(flexibleHeight: false)
        .debugOverlay(.hairline)
}
