//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct PreviewHeaderView: View {

    @State private var paddedHeight: CGFloat = 0.0
    @State private var fullHeight: CGFloat = 0.0

    let flexibleHeight: Bool

    fileprivate var printsUpdates: Bool = false


    init(flexibleHeight: Bool = true) {
        self.flexibleHeight = flexibleHeight
    }


    var body: some View {
        VStack(spacing: 0) {

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
                .onGeometryChange(of: \.size.height) { newHeight in
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
        VStack {
            Spacer()
            content()
        }
        .maxWidthFrame()
        .concentricSafeAreaBackground(fill: .orange)
    }

}


/// Experimental observable object to print a log message during the first request of views.
@Observable
private final class PrintOnce {

    let message: String
    private(set) var hasPrinted: Bool = false

    init(_ message: String) {
        self.message = message
    }

    var view: EmptyView {
        if !hasPrinted {
            hasPrinted = true
            print(message)
        }
        return EmptyView()
    }

}


#Preview("Default", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var isFlexible: Bool = true

    printOnce.view
    PreviewHeaderView(flexibleHeight: isFlexible)
        .preview_printsUpdates(true)

    Divider()

    PreviewContent.bottomControls {
        Toggle("Flexible height", isOn: $isFlexible)
        Text("Has printed once: \(printOnce.hasPrinted.description)")
            .font(.caption)
    }
}

#Preview("SafeArea", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var topSafeAreaInset: Double = 60.0
    @Previewable @State var useDeviceSafeArea: Bool = false
    @Previewable @State var isFlexible: Bool = false

    printOnce.view

    if !useDeviceSafeArea {
        Text("clear from device safe area")
        .font(.caption)
        .maxWidthFrame()
        .concentricSafeAreaBackground(fill: .orange.tertiary, innerPaddingEdges: .not(.top))
    }

    PreviewHeaderView(flexibleHeight: isFlexible)
    .preview_printsUpdates(true)
    .safeAreaInset(edge: .top, spacing: 0) {
        let roundedHeight = topSafeAreaInset.rounded(.toNearestOrEven)
        Rectangle()
            .fill(.red.opacity(0.1))
            .frame(height: roundedHeight)
            .debugOutline(lineWidth: 1, options: .size, .safeAreaInsets, .infoOutside)
            .padding(.horizontal, 8)
    }

    Divider()

    PreviewContent.bottomControls {
        Slider(
            "Top SafeArea",
            value: $topSafeAreaInset,
            in: 0.0...100.0,
            currentValueFormat: .roundedIntegerToNearestOrEven,
            boundsValueFormat: .roundedIntegerToNearestOrEven
        )
        Text("Top SafeArea: \(topSafeAreaInset, format: .roundedIntegerToNearestOrEven)")
            .monospaced()

        Toggle("Use device safe area", isOn: $useDeviceSafeArea)
        Toggle("Flexible height", isOn: $isFlexible)

        Text("Has printed once: \(printOnce.hasPrinted.description)")
            .font(.caption)
    }

}
