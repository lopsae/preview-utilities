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

    @State private var currentSafeAreaInset: CGFloat = 0.0

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
