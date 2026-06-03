//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension VStack {

    /// Creates a `VStack` using the specified alignment, wrapped in a frame that expands to use
    /// the available width.
    ///
    /// The resulting stack will expand to use all available width with its content still aligned
    /// to the specified alignment.
    public static func maxWidth(
        alignment: HorizontalAlignment,
        spacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: alignment, spacing: spacing, content: content)
            .maxWidthFrame(alignment: .init(horizontal: alignment, vertical: .center))
    }

}
