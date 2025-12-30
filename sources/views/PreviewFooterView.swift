//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct PreviewFooterView: View {

    @State private var paddedHeight: CGFloat = 0.0
    @State private var fullHeight: CGFloat = 0.0

    let flexibleHeight: Bool

    private let backgroundStyle: some ShapeStyle = .gray.tertiary

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
            ConcentricRectangle(minimumConcentricRadius: HeaderFooterContainerView<EmptyView>.minimumConcentricRadius)
                .fill(backgroundStyle)
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


    private var textMinimumBottomSafeArea: CGFloat {
        let onePadding = (fullHeight - paddedHeight) / 2.0
        return onePadding * 2.0
    }

}


// MARK: - Preview utilities


extension PreviewFooterView {

    fileprivate func preview_printsUpdates(_ enable: Bool) -> Self {
        var mutableSelf = self
        mutableSelf.printsUpdates = enable
        return mutableSelf
    }

}


// MARK: - Previews


private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .fixedLayout(width: 400, height: 600)

    @ViewBuilder
    static func topControls(@ViewBuilder content: () -> some View) -> some View {
        VStack {
            content()
            Spacer()
        }
        .maxWidthFrame()
        .padding()
        .padding([.horizontal, .bottom])
        .background {
            ConcentricRectangle(minimumConcentricRadius: HeaderFooterContainerView<EmptyView>.minimumConcentricRadius)
            .fill(.orange)
            .padding()
            .ignoresSafeArea()
        }
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

    PreviewContent.topControls {
        Toggle("Flexible height", isOn: $isFlexible)
        Text("Has printed once: \(printOnce.hasPrinted.description)")
            .font(.caption)
    }

    Divider()

    PreviewFooterView(flexibleHeight: isFlexible)
        .preview_printsUpdates(true)
}

#Preview("SafeArea", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var bottomSafeAreaInset: Double = 60.0
    @Previewable @State var useDeviceSafeArea: Bool = false
    @Previewable @State var isFlexible: Bool = false

    printOnce.view

    PreviewContent.topControls {
        Slider(
            "Bottom SafeArea",
            value: $bottomSafeAreaInset,
            in: 0.0...100.0,
            currentValueFormat: .roundedIntegerToNearestOrEven,
            boundsValueFormat: .roundedIntegerToNearestOrEven
        )
        Text("Bottom SafeArea: \(bottomSafeAreaInset, format: .roundedIntegerToNearestOrEven)")
            .monospaced()

        Toggle("Use device safe area", isOn: $useDeviceSafeArea)
        Toggle("Flexible height", isOn: $isFlexible)

        Text("Has printed once: \(printOnce.hasPrinted.description)")
            .font(.caption)
    }

    Divider()

    PreviewFooterView(flexibleHeight: isFlexible)
    .preview_printsUpdates(true)
    .safeAreaInset(edge: .bottom, spacing: 0) {
        let roundedHeight = bottomSafeAreaInset.rounded(.toNearestOrEven)
        Rectangle()
            .fill(.red.opacity(0.1))
            .frame(height: roundedHeight)
            .debugOutline(options: .size, .safeAreaInsets)
    }

    if !useDeviceSafeArea {
        Text("clear from device safe area")
        .font(.caption)
        .maxWidthFrame()
        .padding(.vertical)
        .padding(.vertical)
        .background {
            ConcentricRectangle(minimumConcentricRadius: HeaderFooterContainerView<EmptyView>.minimumConcentricRadius)
                .fill(.orange.tertiary)
                .padding()
                .ignoresSafeArea()
        }
    }

}
