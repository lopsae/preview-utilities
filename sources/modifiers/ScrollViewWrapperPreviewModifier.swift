//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Wraps the preview content in a `ScrollView`.
struct ScrollViewWrapperPreviewModifier: PreviewModifier {

    func body(content: Content, context _: ()) -> some View {
        ScrollView {
            content
        }
    }

}


extension PreviewTrait where T == Preview.ViewTraits {

    /// Wraps the preview content in a `VStack` with zero spacing.
    public static var scrollViewWrap: PreviewTrait {
        .modifier(ScrollViewWrapperPreviewModifier())
    }

}


// MARK: - Previews


#Preview("Default", traits: .scrollViewWrap) {
    ForEach(0..<10) { index in
        Text(Strings.loremIpsum)
        CaptionRectangle("Fixed Content", color: .brown, size: .square(of: 100))
    }
}


#Preview("HeaderFooter", traits: .scrollViewWrap, .headerFooter(.fixed, .showDividers)) {
    ForEach(0..<10) { index in
        Text(Strings.loremIpsum)
        CaptionRectangle("Fixed Content", color: .brown, size: .square(of: 100))
    }
}
