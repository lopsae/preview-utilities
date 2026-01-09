//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Experimental modifier to add a minimum safe area padding to an edge of a view.
///
/// Adds safe area to the current padding up to `minimumInset`; if the view has a safe area of at
/// least `minimumInset` no padding is added.
struct MinimumSafeAreaPaddingModifier: ViewModifier {

    /// Last tracked safe area inset reported by `onGeometryChange`. This value is updated only
    /// when change is over a given threshold.
    @State private var safeAreaInset: CGFloat = .zero

    /// Edge to which the minimum safe area padding is applied.
    let edge: Edge
    /// Minimum safe area inset to allow the content view to have.
    let minimumInset: CGFloat

    /// When `true`, prints all updates to `safeAreaInset`.
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
        let insetDifference = minimumInset - safeAreaInset
        let additionalInset = insetDifference.clamped(to: 0...)

        content
        .safeAreaPadding(.init(edge), additionalInset)
        // TODO: reevaluate if keeping this approach for logging.
        .onGeometryChange(
            keyPath: edge.geometryProxySafeAreaInsetKeyPath,
            binding: $safeAreaInset.onSet { newValue in
                if printsUpdates {
                    print("updated currentSafeAreaInset: \(newValue)")
                }
            },
            transform: { [safeAreaInset] newEdgeInset in
                safeAreaInset.stabilizedValue(newEdgeInset, threshold: 0.5)
            }
        )

        // Previously currentSafeAreaInset was updated on EVERY change of the geometry proxy property
        // this resulted on issues in the iOS Default preview. Code is retained for future testing.
        // Previous issue:
        // Using the device safe area, and reducing the add'l safe area enough that the total safe
        // area is under minimal padding (80) would trigger an infinite update to
        // currentSafeAreaInset.
//        .onGeometryChange(keyPath: edge.geometryProxySafeAreaInsetKeyPath, binding: $safeAreaInset.onSet { newValue in
//            if printsUpdates {
//                print("[deprecated] updated safeAreaInset:\(newValue)")
//            }
//        })
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


#Preview("Default", traits: .zeroSpacing, .iPhoneProSizeLayout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var topContentHeight: Double = 300
    @Previewable @State var addlSafeArea: Double = 60
    @Previewable @State var useDeviceSafeArea: Bool = true

    let minimumInset: Double = 80

    printOnce.view

    VStack {
        Slider(
            "Top Content Height",
            value: $topContentHeight,
            in: 200...1000,
            valueFormat: .arithmeticRoundedInteger)
        Text("Top Content Height: \(topContentHeight, format: .fractionLength(2))")
            .monospaced()

        Slider(
            "Add'l SafeArea",
            value: $addlSafeArea,
            in: 0...100,
            valueFormat: .arithmeticRoundedInteger)

        Text("Add'l SafeArea: \(addlSafeArea, format: .fractionLength(2))")
            .monospaced()
        Toggle("Use device safe area", isOn: $useDeviceSafeArea)
    }
    .padding()

    Divider()

    Rectangle().fill(.green.tertiary)
        .frame(width: 120, height: topContentHeight)
        .previewCaption("Top Content", .height, .border)


    Rectangle().fill(.gray.tertiary)
        .frame(width: 50)
        .previewCaption("Spacer")

    VStack {
        Text("Padded Content")
        Text("Minimum Inset: \(minimumInset, format: .fractionLength(2))")
            .font(.caption.monospaced())
    }
    .maxWidthFrame()
    .minimumSafeAreaPadding(.bottom, minimumInset: minimumInset, printsUpdates: true)
    .debugOverlay(.safeAreaInsets)
    .padding(.horizontal)
    .safeAreaInset(edge: .bottom, spacing: .zero) {
        Rectangle().fill(.red.tertiary)
            .frame(width: 150, height: addlSafeArea)
            .previewCaption("Add'l SafeArea", .height, .border)
    }

    if !useDeviceSafeArea {
        Text("clear from device safe area")
        .font(.caption)
        .maxWidthFrame()
        .concentricSafeAreaBackground(fill: .orange.tertiary)
    }

}


extension View {

    /// Experimental labeling for interactive preview elements, specially rectangles.
    func previewCaption(_ key: LocalizedStringKey, _ options: PreviewCaptionOptions...) -> some View {
        self.overlay {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    VStack(spacing: .zero) {
                        Text(key)
                            .foregroundStyle(.secondary)
                            .font(.caption)
                            .fixedSize()
                        if options.contains(.height) {
                            Text("height: \(geometry.size.height, format: .fractionLength(2))")
                                .foregroundStyle(.secondary)
                                .font(.caption.monospaced())
                                .fixedSize()
                        }
                    } // VStack
                } // ZStack
                .frame(size: geometry.size, alignment: .center)
                .border(.quaternary, width: options.contains(.border) ? 1 : .zero)
            } // GeometryReader
        } // Overlay
    }

}


enum PreviewCaptionOptions {
    case border
    case height
}
