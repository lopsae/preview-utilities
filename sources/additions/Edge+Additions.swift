//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Edge {

    /// Returns a `GeometryProxy` keypath to the `safeAreaInset` of this edge.
    var geometryProxySafeAreaInsetKeyPath: KeyPath<GeometryProxy, CGFloat> & Sendable {
        switch self {
        case .top:      \.safeAreaInsets.top
        case .leading:  \.safeAreaInsets.leading
        case .bottom:   \.safeAreaInsets.bottom
        case .trailing: \.safeAreaInsets.trailing
        }
    }


    var geometryProxySafeAreaInsetTransform: @Sendable (GeometryProxy) -> CGFloat {
        switch self {
        case .top:      \.safeAreaInsets.top
        case .leading:  \.safeAreaInsets.leading
        case .bottom:   \.safeAreaInsets.bottom
        case .trailing: \.safeAreaInsets.trailing
        }
    }

}


extension Edge.Set {

    @inlinable
    static func not(_ edges: Edge.Set) -> Edge.Set {
        .all.subtracting(edges)
    }

}
