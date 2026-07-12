//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Axis {

    @inlinable nonisolated
    var perpendicular: Self {
        switch self {
        case .horizontal: .vertical
        case .vertical:   .horizontal
        }
    }

}
