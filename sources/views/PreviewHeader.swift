//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Experimental modifier to add a minimum safe area padding to a view.
///
/// If the view already if affected by a safe-area greater that `minimumInset`, no additional
/// safe-area is added, otherwise enough safe area padding is added up to `minimumInset`.
struct MinimumSafeAreaModifier: ViewModifier {

    @State var currentSafeAreaInset: CGFloat = 0.0

    let edge: Edge
    let minimumInset: CGFloat

    public func body(content: Content) -> some View {
        // TODO: extension of Edge
        let edgeKeyPath: KeyPath<GeometryProxy, CGFloat> = switch edge {
        case .top:
            \.safeAreaInsets.top
        case .leading:
            \.safeAreaInsets.leading
        case .bottom:
            \.safeAreaInsets.bottom
        case .trailing:
            \.safeAreaInsets.trailing
        }
        content
        .safeAreaPadding(.init(edge), additionalInset)
        // TODO: enable printing of updates, similar to PreviewHeader
        .onGeometryChange(of: edgeKeyPath, binding: $currentSafeAreaInset)
    }


    private var additionalInset: CGFloat {
        return max(0, minimumInset - currentSafeAreaInset)
    }

}


extension EdgeInsets {

    subscript(edge edge: Edge) -> CGFloat {
        switch edge {
        case .top:      top
        case .leading:  leading
        case .bottom:   bottom
        case .trailing: trailing
        @unknown default: fatalError()
        }
    }

}


struct PreviewHeader: View {

    @State private var paddedHeight: CGFloat = 0.0
    @State private var fullHeight: CGFloat = 0.0

    let flexibleHeight: Bool

    // TODO: revert to gray when replacement is done.
    private let backgroundStyle: some ShapeStyle = .pink.tertiary // .gray.tertiary

    fileprivate var printsUpdates: Bool = false


    init(flexibleHeight: Bool = true) {
        self.flexibleHeight = flexibleHeight
    }


    var body: some View {
        VStack(spacing: 0) {

            Text("Header")
                .foregroundStyle(.tertiary)
            // TODO: define convenience view extension call.
//                .minSafeArea(.top, textTopPadding)
                .modifier(MinimumSafeAreaModifier(edge: .top, minimumInset: minimumTextTopSafeArea))
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
            ConcentricRectangle(minimumConcentricRadius: HeaderFooterPreview<EmptyView>.minimumConcentricRadius)
                .fill(backgroundStyle)
                // TODO: reevaluate if using this approach is worthwhile
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


    private var minimumTextTopSafeArea: CGFloat {
        let onePadding = (fullHeight - paddedHeight) / 2.0
        return onePadding * 1.5
    }

}


extension Binding {

    func onSet(action: @escaping (Value) -> ()) -> Self {
        return .init {
            self.wrappedValue
        } set: { newValue in
            action(newValue)
            self.wrappedValue = newValue
        }
    }

}


// MARK: - Preview utilities.

extension PreviewHeader {

    fileprivate func preview_printsUpdates() -> Self {
        var mutableSelf = self
        mutableSelf.printsUpdates = true
        return mutableSelf
    }

}


// MARK: - Previews.


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .fixedLayout(width: 400, height: 600)

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


#Preview(traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var isFlexible: Bool = true

    printOnce.view
    PreviewHeader(flexibleHeight: isFlexible)
        .preview_printsUpdates()

    Divider()

    ConcentricRectangle(minimumConcentricRadius: HeaderFooterPreview<EmptyView>.minimumConcentricRadius)
    .fill(.orange)
    .overlay(alignment: .bottom) {
        VStack {
            Toggle("Flexible height", isOn: $isFlexible)
            Text("Has printed once: \(printOnce.hasPrinted)")
                .font(.caption)
        }
        .padding()
    } // overlay
    .padding()
    .ignoresSafeArea()
}

#Preview("SafeArea", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .init("✴️ Preview start")
    @Previewable @State var topSafeAreaInset: Double = 60.0
    @Previewable @State var useDeviceSafeArea: Bool = false
    @Previewable @State var isFlexible: Bool = false

    let sliderRange: ClosedRange<Double> = 0.0...100.0

    if !useDeviceSafeArea {
        Text("clear from device safe area")
        .font(.caption)
        .maxWidthFrame()
        .padding(.bottom)
        .padding(.bottom)
        .background {
            ConcentricRectangle(minimumConcentricRadius: HeaderFooterPreview<EmptyView>.minimumConcentricRadius)
                .fill(.orange.tertiary)
                .padding()
                .ignoresSafeArea()
        }
    }

    printOnce.view
    PreviewHeader(flexibleHeight: isFlexible)
    .preview_printsUpdates()
    .safeAreaInset(edge: .top, spacing: 0) {
        let roundedHeight = topSafeAreaInset.rounded(.toNearestOrEven)
        Rectangle()
            .fill(.red.opacity(0.1))
            .frame(height: roundedHeight)
            .debugOutline(options: .size, .safeAreaInsets, .infoOutside)
    }

    Divider()

    ConcentricRectangle(minimumConcentricRadius: HeaderFooterPreview<EmptyView>.minimumConcentricRadius)
    .fill(.orange)
    .overlay(alignment: .bottom) {
        VStack {
            Slider(
                "Top SafeArea",
                value: $topSafeAreaInset,
                in: sliderRange
            ) {
                Text(topSafeAreaInset, format: .roundedIntegerToNearestOrEven)
            } boundsValueLabel: { boundValue in
                Text(boundValue, format: .roundedIntegerToNearestOrEven)
                    .monospaced()
            }
            Text("Top SafeArea: \(topSafeAreaInset, format: .roundedIntegerToNearestOrEven)")
                .monospaced()

            Toggle("Use device safe area", isOn: $useDeviceSafeArea)
            Toggle("Flexible height", isOn: $isFlexible)

            Text("Has printed once: \(printOnce.hasPrinted)")
                .font(.caption)
        }
        .padding()
    } // overlay
    .padding()
    .ignoresSafeArea()
}
