//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Experimental modifier to add a minimum safe area padding to a view.
///
/// If the view already if affected by a safe-area greater that `minimumInset`, no additional
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
        .onGeometryChange(of: edge.geometryProxyTransform, binding: $currentSafeAreaInset.onSet { newValue in
            if printsUpdates {
                print("update currentSafeAreaInset:\(newValue)")
            }
        })
    }


    private var additionalInset: CGFloat {
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
    @Previewable @State var topContentHeight: Double = 100.0
    @Previewable @State var bottomSafeAreaInset: Double = 60.0
    @Previewable @State var useDeviceSafeArea: Bool = true

    Slider(
        "Top Content Height",
        value: $topContentHeight,
        in: 0.0...1000.0,
        currentValueFormat: .arithmeticRoundedInteger,
        boundsValueFormat: .arithmeticRoundedInteger
    )
    Text("Top Content Height: \(topContentHeight, format: .fractionLength(2))")
        .monospaced()

    Slider(
        "Bottom SafeArea",
        value: $bottomSafeAreaInset,
        in: 0.0...100.0,
        currentValueFormat: .arithmeticRoundedInteger,
        boundsValueFormat: .arithmeticRoundedInteger
    )
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
