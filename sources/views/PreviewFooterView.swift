//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct PreviewFooterView: View {

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
                .onGeometryChange(of: \.size.height) { newHeight in
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


extension PreviewFooterView {

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
    static func topControls(@ViewBuilder content: () -> some View) -> some View {
        VStack {
            content()
        }
        .maxWidthFrame()
        .concentricSafeAreaBackground(fill: .orange, innerPaddingEdges: .not(.top))

        Text("Flexible")
        .foregroundStyle(.secondary)
        .maxSizeFrame()
        .concentricSafeAreaBackground(fill: .orange, paddingEdges: .not(.top))
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


// FIXME: in ios when fixed height content pushes the footer out of the view boundaries, triggers an infinite update to currentSafeAreaInset.
#Preview("Default", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var isFlexible: Bool = true
    @Previewable @State var fixedHeight: Double = 400.0

    printOnce.view

    PreviewContent.topControls {
        Toggle("Flexible height", isOn: $isFlexible)
        Slider(
            "Fixed Height",
            value: $fixedHeight,
            in: 0.0...800.0,
            valueFormat: .roundedIntegerToNearestOrEven)
        Text("Has printed once: \(printOnce.hasPrinted.description)")
            .font(.caption)
    }

    Divider()

    Rectangle().fill(.red.tertiary)
        .frame(width: 100, height: fixedHeight)
        .debugOutline(lineWidth: 1, options: .size)

    Divider()

    PreviewFooterView(flexibleHeight: isFlexible)
        .preview_printsUpdates(true)
}


// FIXME: in ios, when using flexible height, if the safeare inset goes under the minimum, a infinite update of currentSafeAreaInset is triggered
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
            valueFormat: .roundedIntegerToNearestOrEven)
        Text("Bottom SafeArea: \(bottomSafeAreaInset, format: .fractionLength(2))")
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
        Rectangle()
            .fill(.red.opacity(0.1))
            .frame(width: 200, height: bottomSafeAreaInset)
            .debugOutline(lineWidth: 1, options: .size, .safeAreaInsets)
    }

    if !useDeviceSafeArea {
        Text("clear from device safe area")
        .font(.caption)
        .maxWidthFrame()
        .concentricSafeAreaBackground(fill: .orange.tertiary)
    }

}


struct ConcentricSafeareaBackgroundModifier<S: ShapeStyle>: ViewModifier {

    let fill: S
    let innerPaddingEdges: Edge.Set
    let backgroundPaddingEdges: Edge.Set

    func body(content: Content) -> some View {
        content
        // One padding always for content.
        .padding()
        // One padding from the background edge.
        .padding(innerPaddingEdges)
        .background {
            ConcentricRectangle(minimumConcentricRadius: HeaderFooterContainerView.minimumConcentricRadius)
                .fill(fill)
                .padding(backgroundPaddingEdges)
                .ignoresSafeArea()
        }
    }

}


extension View {

    func concentricSafeAreaBackground(
        fill: some ShapeStyle,
        innerPaddingEdges: Edge.Set = .all,
        backgroundPaddingEdges: Edge.Set = .all,
    ) -> some View {
        let backgroundModifier = ConcentricSafeareaBackgroundModifier(
            fill: fill,
            innerPaddingEdges: innerPaddingEdges,
            backgroundPaddingEdges: backgroundPaddingEdges
        )
        return modifier(backgroundModifier)
    }


    func concentricSafeAreaBackground(
        fill: some ShapeStyle,
        paddingEdges: Edge.Set
    ) -> some View {
        let backgroundModifier = ConcentricSafeareaBackgroundModifier(
            fill: fill,
            innerPaddingEdges: paddingEdges,
            backgroundPaddingEdges: paddingEdges
        )
        return modifier(backgroundModifier)
    }

}


// FIXME: add similar previews with fixed size for Header view
// FIXME: add similar previews with fixed size for HeaderFooter
