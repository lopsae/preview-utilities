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


#Preview("overlay&alignment", traits: .fixedHeaderFooter, PreviewContent.layout) {
    PreviewCaption("""
        Aligning views in an `overlay` will use the alignment guides of the parent view. Views
        positioned outside of the boundaries of the parent do not modify the parents layout.
        """)

    Spacer()

    Text("Large")
    .font(.largeTitle)
    .foregroundStyle(.tertiary)
    .overlay(alignment: .centerLastTextBaseline) {
        CaptionRectangle(
            "Aligned to\nlast baseline", color: .teal,
            traits: .alignment(.bottomTrailing)
        )
        .alignmentGuide(.lastTextBaseline, moveTo: .top)
    }
    .overlay(alignment: .leadingLastTextBaseline) {
        Text("floating at\nlast baseline")
        .font(.caption)
        .fixedSize()
        .alignmentGuide(.leading, moveTo: .trailing, offsetBy: 5)
    }
    .overlay(alignment: .centerLastTextBaseline) {
        Rectangle()
            .fill(.red.secondary)
            .frame(width: 200, height: 2)
    }
    .floatingCaption("Text & overlays", .colorStyle(.blue), .alignment(.outerTrailingAbove))

    Spacer()

    PreviewCaption("""
        Compared to a `ZStack`, offsetting views outside of the first stacked view will impact the
        size of the `ZStack`.
        """)
    .paragraph("""
        Additionally, there is no way for expanding views to inherit the size of a primary (or
        parent) view.
        """)

    Spacer()

    ZStack(alignment: .centerLastTextBaseline) {
        Text("Large")
            .font(.largeTitle)
            .foregroundStyle(.tertiary)

        CaptionRectangle(
            "Aligned to\nlast baseline", color: .teal, size: [100, 50],
            traits: .alignment(.bottomTrailing)
        ).alignmentGuide(.lastTextBaseline, moveTo: .top)

        Text("floating at\nlast baseline")
            .font(.caption)
            .fixedSize()
            .alignmentGuide(.center, moveTo: .trailing, offsetBy: 50)

        Rectangle()
            .fill(.red.secondary)
            .frame(width: 200, height: 2)
    }
    .floatingCaption("ZStack", .colorStyle(.blue), .alignment(.outerTrailingAbove))

    Spacer()
}


#Preview("frame&alignment", traits: .fixedHeaderFooter, PreviewContent.layout) {
    PreviewCaption("""
        Similar behavior can be achieved by using a frame over aligned views. Likely this is the
        way `overlay` arranges its views.
        """)
    .paragraph("""
        However, there is still no way to inherit the size of a parent/primary view like `overlay`
        does automatically.
        """)

    Spacer()

    Text("Realigned to\nTrailing")
        .multilineTextAlignment(.trailing)
        .fixedSize()
        .alignmentGuide(.leading, moveTo: .trailing, offsetBy: 5)
        .frame(squareOf: 100, alignment: .leading)
        .floatingCaption("frame\nleading aligned", .colorStyle(.blue))

    Text("Realigned to\nLast Baseline")
        .fixedSize()
        .alignmentGuide(.trailing, moveTo: .leading, offsetBy: -5)
        .frame(squareOf: 100, alignment: .trailingLastTextBaseline)
        .floatingCaption("frame\ntrailing-baseline\naligned", .colorStyle(.blue))


    Spacer()
}

