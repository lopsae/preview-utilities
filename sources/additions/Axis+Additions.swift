//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Axis {

    @inlinable nonisolated
    var orthogonal: Self {
        switch self {
        case .horizontal: .vertical
        case .vertical:   .horizontal
        }
    }

    /// A size with a value of `1` along the length of the axis, and `zero` across.
    var unitSize: CGSize {
        switch self {
        case .horizontal: .init(width: CGFloat.one,  height: .zero)
        case .vertical:   .init(width: CGFloat.zero, height: .one)
        }
    }

}
