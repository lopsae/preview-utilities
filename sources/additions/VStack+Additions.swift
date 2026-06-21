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


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    let content = Group {
        CaptionRectangle("First", color: .mint, size: [100, 50])
        CaptionRectangle("Second", color: .mint, size: [200, 50])
        CaptionRectangle("Third", color: .mint, size: [150, 50])
    }

    VStack.maxWidth(alignment: .leading) {
        content
    }
    .floatingCaption("VStack.maxWidth", .colorStyle(.orange), .alignment(.topTrailing))

    DashedDivider()

    VStack(alignment: .leading) {
        content
    }
    .floatingCaption("VStack", .colorStyle(.orange), .alignment(.topTrailing))
}
