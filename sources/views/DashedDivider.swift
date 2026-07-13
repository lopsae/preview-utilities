//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// A divider line with a dashed line style.
public struct DashedDivider: View {

    let axis: Axis
    let lineWidth: CGFloat

    public init(axis: Axis = .horizontal, lineWidth: CGFloat = 1) {
        self.axis = axis
        self.lineWidth = lineWidth
    }

    public var body: some View {
        let strokeStyle = StrokeStyle(
            lineWidth: lineWidth, lineCap: .round,
            dash: [lineWidth*5, lineWidth*6])
        switch axis {
        case .horizontal:
            AxialLine(.horizontal)
            .stroke(.tertiary, style: strokeStyle)
            .frame(length: lineWidth, along: axis.orthogonal)
        case .vertical:
            AxialLine(.vertical)
            .stroke(.tertiary, style: strokeStyle)
            .frame(length: lineWidth, along: axis.orthogonal)
        }

    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    VStack {
        CaptionRectangle("Content", color: .cyan, size: [150, 40])
        DashedDivider()
        CaptionRectangle("Content", color: .cyan, size: [150, 40])
        DashedDivider()
        CaptionRectangle("Content", color: .cyan, size: [150, 40])
    }
    .floatingCaption("VStack", .colorStyle(.cyan), .alignment(.topLeading))

    HStack {
        CaptionRectangle("Content\nfixed height", color: .mint, height: 60)
        DashedDivider(axis: .vertical)
        CaptionRectangle("Content", color: .mint, width: 70)
        DashedDivider(axis: .vertical)
        CaptionRectangle("Content", color: .mint)
    }
    .frame(height: 60)
    .floatingCaption("HStack with fixed height", .colorStyle(.cyan), .alignment(.topLeading))

    HStack {
        CaptionRectangle("Content\nfixed height", color: .mint, height: 60)
        DashedDivider(axis: .vertical)
        CaptionRectangle("Content", color: .red, width: 70)
        DashedDivider(axis: .vertical)
        CaptionRectangle("Content", color: .red)
    }
    .floatingCaption("HStack", .colorStyle(.cyan), .alignment(.topLeading))
}


#Preview("Sizes", traits: .paddingSpacing, .fixedHeader, PreviewContent.layout) {
    VStack(spacing: 32) {
        DashedDivider()
            .floatingCaption("Default", .height, .colorStyle(.brown))
        DashedDivider(lineWidth: 10)
            .floatingCaption("Large", .height, .colorStyle(.brown))
        DashedDivider(lineWidth: 20)
            .floatingCaption("Huge", .height, .colorStyle(.brown))
    }

    DashedDivider()

    HStack(spacing: 32) {
        DashedDivider(axis: .vertical)
            .floatingCaption("Default", .width, .colorStyle(.brown), .alignment(.top))
        DashedDivider(axis: .vertical, lineWidth: 10)
            .floatingCaption("Large", .width, .colorStyle(.brown), .alignment(.center))
        DashedDivider(axis: .vertical, lineWidth: 20)
            .floatingCaption("Huge", .width, .colorStyle(.brown), .alignment(.bottom))
    }
}


#Preview("HStack Height", traits: .fixedHeader, PreviewContent.layout) {
    PreviewCaption("""
        Note that in certain cases where a stack is space constrained, content that expands (like 
        a `DashedDivider`) will use the space that is available to the stack, **NOT** stack final 
        size, which could be larger due to other views in the stack.
        """)
    .paragraph("""
        In those cases, the Stack may need a fixed size to allow views like `DashedDivider` to show
        properly.
        """)

    CaptionRectangle("Fixed Height", color: .brown, size: [150, 20])

    HStack {
        CaptionRectangle("Fixed height\nContent", color: .mint, height: 40)
        DashedDivider(axis: .vertical)
        CaptionRectangle("Expanding\nContent", color: .mint, width: 70)
        DashedDivider(axis: .vertical)
        CaptionRectangle("Expanding\nContent", color: .mint)
    }
    .frame(height: 60)
    .floatingCaption("HStack with fixed height", .colorStyle(.cyan), .alignment(.outerTopLeading))

    HStack {
        CaptionRectangle("Fixed height\nContent", color: .mint, height: 60)
        DashedDivider(axis: .vertical)
        CaptionRectangle("Squished\nContent!", color: .red, width: 70)
        DashedDivider(axis: .vertical)
        CaptionRectangle("Squished\nContent!", color: .red)
    }
    .floatingCaption("HStack", .colorStyle(.cyan), .alignment(.outerBottomLeading))
}


#Preview("Space Distribution", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var fixedHeight: Double = 200

    PreviewCaption("""
        Seems `HStack` (and likely also `VStack`) will resize an internal view that is trying to
        expand with the size the `HStack` is allowed to have, even if content
        inside is making it larger.
        """)

    Slider.captioned(
        "Fixed Height",
        value: $fixedHeight, in: 0...500,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)

    VStack {
        VStack {
            CaptionRectangle("Fixed Height", color: .brown, size: [150, fixedHeight])

            HStack {
                CaptionRectangle("Fixed Size", color: .mint, size: [100, 100])
                DashedDivider(axis: .vertical)
                CaptionRectangle("Squished\nMax Height", color: .red, width: 100)
            }
            .floatingCaption("HStack", .colorStyle(.cyan), .alignment(.topLeading))
        }
        .floatingCaption("VStack", .colorStyle(.orange), .alignment(.bottom))

        VisibleSpacer()
    }
    .floatingCaption("VStack", .colorStyle(.gray), .alignment(.bottomTrailing))
}
