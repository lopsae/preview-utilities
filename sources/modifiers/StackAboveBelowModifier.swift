//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct StackAboveModifier<AboveContent: View>: ViewModifier {

    let spacing: CGFloat?
    let aboveContent: () -> AboveContent


    init(
        spacing: CGFloat?,
        @ViewBuilder content: @escaping () -> AboveContent
    ) {
        self.spacing = spacing
        self.aboveContent = content
    }


    func body(content: Content) -> some View {
        VStack(spacing: spacing) {
            aboveContent()
            content
        }
    }

}


extension View {

    func stackAbove<Content: View>(
        spacing: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        let stackModifier = StackAboveModifier(spacing: spacing, content: content)
        return modifier(stackModifier)
    }

}
