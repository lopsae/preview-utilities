//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Angle {

    // TODO: add turn property to read angle in turn.

    /// Creates an angle with the given turn value.
    static func turn(_ turn: Double) -> Self {
        .radians(turn * .tau)
    }

}
