//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// FUTURE: could this be abstracted into a modifier that uses `Edge`? parent.stack(on: .top) { ... }


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


struct StackBelowModifier<BelowContent: View>: ViewModifier {

    let spacing: CGFloat?
    let belowContent: () -> BelowContent


    init(
        spacing: CGFloat?,
        @ViewBuilder content: @escaping () -> BelowContent
    ) {
        self.spacing = spacing
        self.belowContent = content
    }


    func body(content: Content) -> some View {
        VStack(spacing: spacing) {
            content
            belowContent()
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


    func stackBelow<Content: View>(
        spacing: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        let stackModifier = StackBelowModifier(spacing: spacing, content: content)
        return modifier(stackModifier)
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("StackAbove", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    CaptionRectangle("Parent", color: .brown, size: .square(of: 100))
    .stackAbove {
        Text("Stacked above (default)")
    }

    CaptionRectangle("Parent", color: .brown, size: .square(of: 100))
        .stackAbove(spacing: .zero) {
        Text("Stacked above (zero)")
    }
}


#Preview("StackBelow", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    CaptionRectangle("Parent", color: .brown, size: .square(of: 100))
    .stackBelow {
        Text("Stacked below (default)")
    }

    CaptionRectangle("Parent", color: .brown, size: .square(of: 100))
        .stackBelow(spacing: .zero) {
        Text("Stacked below (zero)")
    }
}
