//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Eg: Overlay", traits: .headerFooter, PreviewContent.layout) {
    PreviewCaption("""
        `overlay` allows its content to overflow around the owner view, without modifying the owner
        position or size and providing alignment options.
        """)

    CaptionRectangle("Parent Content", color: .blue, size: .square(of: 200), traits: .size)
    .overlay(alignment: .bottomTrailing) {
        Text("Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.")
        .font(.title3)
        .fixedSize()
        .floatingCaption("`overlay` content",
            .style(.brown), .alignment(.outerTopTrailing))
    }
    .debugOverlay(.caption("overlay"), .size, .infoAlignment(.outerBottomTrailing))
}


#Preview("Eg: ZStack", traits: .headerFooter, PreviewContent.layout) {
    PreviewCaption("""
        `ZStack` of the same elements, which grows to accomodate the size of all contained elements.
        """)

    ZStack(alignment: .bottomTrailing) {
        CaptionRectangle("Parent Content", color: .blue, size: .square(of: 200), traits: .size)
        Text("Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.")
        .font(.title3)
        .fixedSize()
        .floatingCaption("`overlay` content",
            .style(.brown), .alignment(.outerTopTrailing))
    }
    .debugOverlay(.caption("ZStack"), .size, .infoAlignment(.outerBottomTrailing))
}


#Preview("Overlay+GeometryReader alignment", traits: .fixedHeaderFooter) {
    PreviewCaption("""
        `GeometryReader` takes the size of its container, even if the content is bigger. Bigger
        content is always aligned `topLeading` with no possible way to modify it through
        `GeometryReader` alone.
        """)

    VisibleSpacer()

    CaptionRectangle("Parent Content", color: .blue, size: .square(of: 150), traits: .size)
    .overlay(alignment: .bottomTrailing) {
        // Geometry reader will remain the size of its container, even if content is bigger.
        // And the content inside will always be topLeading aligned, with no way to configure.
        GeometryReader { geometry in
            ClearRectangle(size: geometry.size.multiplying(by: 1.5), fill: .orange.quinary)
            .floatingCaption("Large content\nin `GeometryReader`",
                .style(.orange), .alignment(.outerBottomTrailing), .size)
        } // GeometryReader
        .floatingCaption("`GeometryReader`",
            .style(.brown), .alignment(.outerTopTrailing), .size)
    }
    .debugOverlay(.caption("overlay"), .size, .infoAlignment(.outerBottomTrailing))

    VisibleSpacer()
}


#Preview("GeometryReader+Frame alignment", traits: .fixedHeaderFooter) {
    PreviewCaption("""
        `GeometryReader` takes the size of its container, even if the content is bigger. Using a
        to wrap the `GeometryReader` content can provide alignment support.
        """)

    VisibleSpacer()

    CaptionRectangle("Parent Content", color: .blue, size: .square(of: 150), traits: .size)
    // The overlay alignment is irrelevant, since the content will always take the available space.
    .overlay(alignment: .bottom) {
        GeometryReader { geometry in
            ClearRectangle(size: geometry.size.multiplying(by: 1.5), fill: .orange.quinary)
            .floatingCaption("Large content\nin `GeometryReader`",
                .style(.orange), .alignment(.outerBottomTrailing), .size
            )
            .frame(size: geometry.size, alignment: .top)

        } // GeometryReader
        .floatingCaption("`GeometryReader`",
            .style(.brown), .alignment(.outerTopTrailing), .size)
    }
    .debugOverlay(.caption("overlay"), .size, .infoAlignment(.outerBottomTrailing))

    VisibleSpacer()
}
