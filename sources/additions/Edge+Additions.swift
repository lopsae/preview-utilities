//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Edge {

    var geometryProxyKeyPath: KeyPath<GeometryProxy, CGFloat> {
        switch self {
        case .top:      \.safeAreaInsets.top
        case .leading:  \.safeAreaInsets.leading
        case .bottom:   \.safeAreaInsets.bottom
        case .trailing: \.safeAreaInsets.trailing
        }
    }

}
