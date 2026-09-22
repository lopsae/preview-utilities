//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


extension ImageRenderer {

    /// Creates a renderer object with a given content view at the specified scale.
    ///
    /// Convenience initializer that renders the content closure at the specified scale.
    ///
    /// - Parameter scale: The scale at which to render the image.
    /// - Parameter content: The content to render.
    public convenience init(scale: CGFloat, @ViewBuilder content: () -> Content) {
        self.init(content: content())
        self.scale = scale
    }

}
