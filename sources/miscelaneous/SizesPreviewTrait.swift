//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension PreviewTrait where T == Preview.ViewTraits {

    /// Aproximate size of an iPhone Pro safe area: `400x800`.
    ///
    /// The actual reported size of the safe area in the iPhone 17 Pro simulator is `402x778`.
    public static var iPhoneProSize: CGSize { .init(width: 400, height: 800) }


    /// Returns a fixed layout preview trait with a given size.
    public static func fixedLayout(size: CGSize) -> PreviewTrait {
        return .fixedLayout(width: size.width, height: size.height)
    }


    /// Returns a fixed layout preview trait with the approximate size of the iPhone Pro safe area:
    /// `400x800`.
    public static var iPhoneProSizeLayout: PreviewTrait {
        return .fixedLayout(size: iPhoneProSize)
    }

}


// MARK: - Previews


#Preview(traits: .iPhoneProSizeLayout) {
    ClearRectangle()
        .debugOverlay(.size)
}
