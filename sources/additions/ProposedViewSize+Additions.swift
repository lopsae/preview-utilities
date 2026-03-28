//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension ProposedViewSize {

    nonisolated
    var debugSizeString: String {
        let widthString = width?.formatted(.fractionLength(1)) ?? "nil"
        let heightString = height?.formatted(.fractionLength(1)) ?? "nil"
        return "(w:\(widthString), h:\(heightString))"
    }

}
