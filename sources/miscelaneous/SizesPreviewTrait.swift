//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension PreviewTrait where T == Preview.ViewTraits {

    /// Returns a fixed layout preview trait with the approximate size , `400x800`, of the iPhone
    /// Pro safe area.
    ///
    /// The actual reported size of the safe area in the iPhone 17 Pro simulator is `402x778`.
    public static var iphoneSize: PreviewTrait {
        return .fixedLayout(width: 400, height: 800)
    }

}


// MARK: - Previews


#Preview(traits: .iphoneSize) {
    ClearRectangle()
        .debugOutline(options: .size)
}
