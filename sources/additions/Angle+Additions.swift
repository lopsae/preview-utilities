//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Angle {

    static func turns(_ turns: Double) -> Self {
        .radians(turns * .tau)
    }

}
