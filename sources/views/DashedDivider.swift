//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


public struct DashedDivider: View {

    let axis: Axis
    let lineWidth: CGFloat


    public init(axis: Axis = .horizontal, lineWidth: CGFloat = 1) {
        self.axis = axis
        self.lineWidth = lineWidth
    }


    struct HorizontalLine: Shape {
        let lineWidth: CGFloat
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.moveTo(x: .zero, y: lineWidth/2)
            path.addLineTo(x: rect.width, y: lineWidth/2)
            return path
        }
    }


    struct VerticalLine: Shape {
        let lineWidth: CGFloat
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.moveTo(x: lineWidth/2, y: .zero)
            path.addLineTo(x: lineWidth/2, y: rect.height)
            return path
        }
    }


    public var body: some View {
        let strokeStyle = StrokeStyle(
            lineWidth: lineWidth, lineCap: .round,
            dash: [lineWidth*5, lineWidth*6])
        switch axis {
        case .horizontal:
            HorizontalLine(lineWidth: lineWidth)
            .stroke(.tertiary, style: strokeStyle)
            .frame(height: lineWidth)
        case .vertical:
            VerticalLine(lineWidth: lineWidth)
            .stroke(.tertiary, style: strokeStyle)
            .frame(width: lineWidth)
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
