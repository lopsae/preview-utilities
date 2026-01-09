//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct PreviewHeaderView: View {

    @State private var paddedHeight: CGFloat = .zero
    @State private var fullHeight: CGFloat = .zero

    let flexibleHeight: Bool

    fileprivate var printsUpdates: Bool = false


    init(flexibleHeight: Bool = true) {
        self.flexibleHeight = flexibleHeight
    }


    var body: some View {
        VStack(spacing: .zero) {

            Text("Header")
                .foregroundStyle(.tertiary)
                .minimumSafeAreaPadding(.top, minimumInset: textMinimumTopSafeArea, printsUpdates: printsUpdates)
                // Double padding to separate one padding from background,
                // which is padded once from views edge.
                .padding(.bottom)
                .padding(.bottom)
                .maxWidthFrame()

            if flexibleHeight {
                Spacer()
            }

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


    private var textMinimumTopSafeArea: CGFloat {
        let onePadding = (fullHeight - paddedHeight) / 2.0
        return onePadding * 2.0
    }

}


// MARK: - Preview utilities


extension PreviewHeaderView {

    fileprivate func preview_printsUpdates(_ enable: Bool) -> Self {
        var mutableSelf = self
        mutableSelf.printsUpdates = enable
        return mutableSelf
    }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iphoneSize

    @ViewBuilder
    static func bottomControls(@ViewBuilder content: () -> some View) -> some View {
        Text("Flexible")
        .foregroundStyle(.secondary)
        .maxSizeFrame()
        .concentricSafeAreaBackground(fill: .orange, paddingEdges: .not(.bottom))

        VStack {
            content()
        }
        .maxWidthFrame()
        .concentricSafeAreaBackground(fill: .orange)
    }

}


#Preview("Default", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var isFlexible: Bool = true
    @Previewable @State var fixedHeight: Double = 400

    printOnce.view

    PreviewHeaderView(flexibleHeight: isFlexible)
        .preview_printsUpdates(true)

    Divider()

    Rectangle().fill(.red.tertiary)
        .frame(width: 100, height: fixedHeight)
        .debugOutline(.hairline, .size)

    Divider()

    PreviewContent.bottomControls {
        Slider(
            "Fixed Height",
            value: $fixedHeight,
            in: 0...800,
            valueFormat: .roundedIntegerToNearestOrEven)
        Toggle("Flexible height", isOn: $isFlexible)
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

    PreviewHeaderView(flexibleHeight: isFlexible)
    .preview_printsUpdates(true)
    .safeAreaInset(edge: .top, spacing: .zero) {
        Rectangle()
            .fill(.red.opacity(0.1))
            .frame(height: topSafeAreaInset)
            .debugOutline(.hairline, .size, .safeAreaInsets, .outerInfo)
            .padding(.horizontal, 8)
    }

    Divider()

    PreviewContent.bottomControls {
        Slider(
            "Top SafeArea",
            value: $topSafeAreaInset,
            in: 0...100,
            currentValueFormat: .roundedIntegerToNearestOrEven,
            boundsValueFormat: .roundedIntegerToNearestOrEven
        )
        Text("Top SafeArea: \(topSafeAreaInset, format: .fractionLength(2))")
            .monospaced()

        Toggle("Use device safe area", isOn: $useDeviceSafeArea)
        Toggle("Flexible height", isOn: $isFlexible)
    }

}
