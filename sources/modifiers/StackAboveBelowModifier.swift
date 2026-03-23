//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct StackAbove<AboveContent: View>: ViewModifier {
    let spacing: CGFloat?
    let aboveContent: () -> AboveContent
//    init(spacing: Double) {
//        self.spacing = spacing
//    }
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
        let stackModifier = StackAbove(spacing: spacing, aboveContent: content)
        return modifier(stackModifier)
    }

}
