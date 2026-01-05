//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Edge {

    // TODO: could not be used because KeyPath was not sendable. replaced with geometryProxyTransform
    // Evaluate if to keep it.
    var geometryProxyKeyPath: KeyPath<GeometryProxy, CGFloat> {
        switch self {
        case .top:      \.safeAreaInsets.top
        case .leading:  \.safeAreaInsets.leading
        case .bottom:   \.safeAreaInsets.bottom
        case .trailing: \.safeAreaInsets.trailing
        }
    }


    var geometryProxyTransform: @Sendable (GeometryProxy) -> CGFloat {
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
