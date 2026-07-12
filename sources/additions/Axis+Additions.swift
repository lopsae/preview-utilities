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

}
