//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


extension Edge {

    nonisolated
    var axis: Axis {
        switch self {
        case .top, .bottom:       .vertical
        case .leading, .trailing: .horizontal
        }
    }


    nonisolated
    var opposite: Self {
        switch self {
        case .top:      .bottom
        case .leading:  .trailing
        case .bottom:   .top
        case .trailing: .leading
        }
    }

    // Rotates towards the trailing edge.
    //
    // Clockwise in left-to-right layout direction.
    //
    // top → trailing → bottom → leading → top
    nonisolated
    var rotated: Self {
        switch self {
        case .top:      .trailing
        case .trailing: .bottom
        case .bottom:   .leading
        case .leading:  .top
        }
    }


    // Rotates towards the leading edge.
    //
    // Counter-clockwise in left-to-right layout direction.
    //
    // top → leading → bottom → trailing → top
    nonisolated
    var counterRotated: Self {
        switch self {
        case .top:      .leading
        case .leading:  .bottom
        case .bottom:   .trailing
        case .trailing: .top
        }
    }


    nonisolated
    var set: Edge.Set { .init(self) }


    nonisolated
    var orthogonalSet: Edge.Set {
        switch self {
        case .top:      .horizontal
        case .leading:  .vertical
        case .bottom:   .horizontal
        case .trailing: .vertical
        }
    }


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


    static let led: Self = .leading
    static let bot: Self = .bottom
    static let tra: Self = .trailing

}


extension Edge.Set {

    @inlinable public static
    func not(_ edges: Edge.Set) -> Edge.Set {
        .all.subtracting(edges)
    }

}
