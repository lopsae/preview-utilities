//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension ProposedViewSize {

    @inlinable nonisolated
    var debugSizeString: String {
        let widthString = width?.formatted(.fractionLength(1)) ?? "nil"
        let heightString = height?.formatted(.fractionLength(1)) ?? "nil"
        return "(w:\(widthString), h:\(heightString))"
    }


    @inlinable nonisolated
    var transposed: Self {
        .init(width: height, height: width)
    }

}
