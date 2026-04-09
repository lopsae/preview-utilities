//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Experimental view that displays the given content overlaid a parent view that is hidden.
///
/// The parent content is hidden visually and for accessibility, even so for layout it uses the same
/// space it would use if visible.
///
/// The parent content determines the space that will be used. The overlaid content is centered in
/// this space. Overlaid content larger that the parent content does not modify the size occupied by
/// the parent content, the overlaid content just overflows.
///
/// This has the practical result of displaying the overlaid content centered in the space occupied
/// by the parent view, irregardless of the size of the overlaid content.
public struct HiddenParentOverlay<Parent: View, Content: View>: View {
    @ViewBuilder let parent: Parent
    @ViewBuilder let content: Content
    public var body: some View {
        parent
            .hidden()
            .accessibilityHidden(true)
            .overlay(alignment: .center) {
                content
            }
    }
}
