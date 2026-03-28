//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Angle {

    // TODO: rename to turn, since it would read `1/4 of a turn`, not `1/4 of a turns`.
    static func turns(_ turns: Double) -> Self {
        .radians(turns * .tau)
    }

}
