//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// FIXME: Publicize.
extension ImageRenderer {

    /// Convenience initializer that renders the given content at the specified scale.
    convenience init(scale: CGFloat, @ViewBuilder content: () -> Content) {
        self.init(content: content())
        self.scale = scale
    }

}
