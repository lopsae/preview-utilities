//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


#Preview("Example: .overlay", traits: .headerFooter) {
    PreviewCaption("""
        `overlay` allows its content to overflow around the owner view, without modifying the owner
        position or size.
        """)

    CaptionRectangle("Parent\nContent", color: .blue, size: .square(of: 150), traits: .size)
    .overlay(alignment: .bottomTrailing) {
        Text("Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.")
        .fixedSize()
        .floatingCaption("`overlay` content",
            .style(.brown), .alignment(.outerTopTrailing))
    }
    .debugOverlay(.size, .infoAlignment(.outerBottomLeading))
}


#Preview("Example: ZStack", traits: .headerFooter) {
    PreviewCaption("""
        `ZStack` of the same elements, which grows to accomodate the size of all contained elements.
        """)

    ZStack(alignment: .bottomTrailing) {
        CaptionRectangle("Parent\nContent", color: .blue, size: .square(of: 150), traits: .size)
        Text("Lorem ipsum dolor sit amet,\nconsectetur adipiscing elit.")
            .fixedSize()
            .floatingCaption("`overlay` content",
                .style(.brown), .alignment(.outerTopTrailing))
    }
    .debugOverlay(.size, .infoAlignment(.outerBottomLeading))
}


#Preview("Overlay+GeometryReader alignment", traits: .headerFooter(.fixed)) {
    PreviewCaption("""
        `GeometryReader` takes the size of its container, even if the content is bigger. Bigger
        content is always aligned `topLeading` with no possible way to modify it through
        `GeometryReader` api's.
        """)

    VisibleSpacer()

    CaptionRectangle("Parent\nContent", color: .blue, size: .square(of: 150), traits: .size)
    .overlay(alignment: .bottomTrailing) {
        // Geometry reader will remain the size of its container, even if content is bigger.
        GeometryReader { geometry in
            ClearRectangle(size: geometry.size.multiplying(by: 1.5))
            .floatingCaption("Large content\nin `GeometryReader`",
                .style(.orange), .alignment(.outerBottomTrailing), .size)
        } // GeometryReader
        .floatingCaption("`GeometryReader`",
            .style(.brown), .alignment(.outerTopTrailing), .size)
    }
    .debugOverlay(.size, .infoAlignment(.outerBottom))

    VisibleSpacer()

}


// TODO: add example repositioning with a Frame using geometry size.
