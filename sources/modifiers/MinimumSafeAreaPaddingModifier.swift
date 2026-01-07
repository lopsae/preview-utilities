//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Experimental modifier to add a minimum safe area padding to a view.
///
/// If the view already is affected by a safe-area greater that `minimumInset`, no additional
/// safe-area is added, otherwise enough safe area padding is added up to `minimumInset`.
struct MinimumSafeAreaPaddingModifier: ViewModifier {

    @State private var currentSafeAreaInset: CGFloat = .zero

    let edge: Edge
    let minimumInset: CGFloat

    fileprivate var printsUpdates: Bool


    init(edge: Edge, minimumInset: CGFloat) {
        self.init(edge: edge, minimumInset: minimumInset, printsUpdates: false)
    }


    internal init(edge: Edge, minimumInset: CGFloat, printsUpdates: Bool) {
        self.edge          = edge
        self.minimumInset  = minimumInset
        self.printsUpdates = printsUpdates
    }


    func body(content: Content) -> some View {
        content
        .safeAreaPadding(.init(edge), additionalInset)
        // TODO: reevaluate if keeping this approach for logging.
        // TODO: could absolute distance of 1 be used instead of floor?
        .onGeometryChange(
            keyPath: edge.geometryProxyKeyPath,
            binding: $currentSafeAreaInset.onSet { newValue in
                if printsUpdates {
                    print("updated currentSafeAreaInset: \(newValue)")
                }
            },
            transform: floor
        )
        // Previously currentSafeAreaInset was updated on EVERY change of the geometry proxy property
        // this resulted on issues in the iOS Default preview. Code is retained for future testing.
        // Previous issue:
        // Using the device safe area, and reducing the bottom safe enough that the total safe area
        // is under minimal padding (50) would trigger an infinite update to currentSafeAreaInset.
//        .onGeometryChange(keyPath: edge.geometryProxyKeyPath, binding: $currentSafeAreaInset.onSet { newValue in
//            if printsUpdates {
//                print("[deprecated] updated currentSafeAreaInset:\(newValue)")
//            }
//        })
    }


    private var additionalInset: CGFloat {
        // TODO: value.clamp(lowest: 0) or value.bound(lowest: 0), comparable already has clamped
        return max(0, minimumInset - currentSafeAreaInset)
    }

}


// MARK: - View Extension


extension View {

    func minimumSafeAreaPadding(_ edge: Edge, minimumInset: CGFloat) -> some View {
        modifier(
            MinimumSafeAreaPaddingModifier(edge: edge, minimumInset: minimumInset)
        )
    }


    internal func minimumSafeAreaPadding(_ edge: Edge, minimumInset: CGFloat, printsUpdates: Bool) -> some View {
        modifier(
            MinimumSafeAreaPaddingModifier(edge: edge, minimumInset: minimumInset, printsUpdates: printsUpdates)
        )
    }

}


// MARK: - Previews


// FIXME: in ios, agains the device safearea, reducing the bottom safe are so that the total safe are is less that the minimal padding will trigger an infinite update to currentSafeAreaInset
#Preview(traits: .iPhoneProSizeLayout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var topContentHeight: Double = 100.0
    @Previewable @State var bottomSafeAreaInset: Double = 60.0
    @Previewable @State var useDeviceSafeArea: Bool = true

    printOnce.view

    Slider(
        "Top Content Height",
        value: $topContentHeight,
        in: 0.0...1000.0,
        valueFormat: .arithmeticRoundedInteger)
    Text("Top Content Height: \(topContentHeight, format: .fractionLength(2))")
        .monospaced()

    Slider(
        "Bottom SafeArea",
        value: $bottomSafeAreaInset,
        in: 0.0...100.0,
        valueFormat: .arithmeticRoundedInteger)

    Text("Bottom SafeArea: \(bottomSafeAreaInset, format: .fractionLength(2))")
        .monospaced()
    Toggle("Use device safe area", isOn: $useDeviceSafeArea)

    Spacer()

    Rectangle().fill(.green.tertiary)
        .frame(width: 100, height: topContentHeight)
        .debugOutline(lineWidth: 1, options: .size)

    Text("Padded Content")
        .maxWidthFrame()
        .minimumSafeAreaPadding(.bottom, minimumInset: 50.0, printsUpdates: true)
        .debugOutline(options: .safeAreaInsets)
        .padding(.horizontal)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Rectangle().fill(.red.tertiary)
                .frame(width: 100, height: bottomSafeAreaInset)
        }

    if !useDeviceSafeArea {
        Text("clear from device safe area")
        .font(.caption)
        .maxWidthFrame()
        .concentricSafeAreaBackground(fill: .orange.tertiary)
    }

}
