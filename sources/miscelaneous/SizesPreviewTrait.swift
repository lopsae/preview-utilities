//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


extension PreviewTrait where T == Preview.ViewTraits {

    /// Approximate size of an iPhone Pro safe area: `400x800`.
    ///
    /// The actual reported size of the safe area in the iPhone 17 Pro simulator is `402x778`.
    /// The width of the iPhone 17 Pro screen is 6.5 cm, approximately 6.185 points per mm.
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


#Preview("Default", traits: .iPhoneProSizeLayout) {
    ClearRectangle()
    .debugOverlay(.size)
}


#Preview("Fixed", traits: .iPhoneProSizeLayout) {
    CaptionRectangle(
        "In macOS the fixed \n size of this view will \n override the preview \n size.",
        color: .teal, size: .square(of: 120)
    )
}


#Preview("Forced", traits: .iPhoneProSizeForcedLayout) {
    CaptionRectangle("Fixed Size", color: .teal, size: .square(of: 120))
}
