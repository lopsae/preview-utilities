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
        CaptionRectangle("Content", color: .cyan, size: [150, 50])
        DashedDivider()
        CaptionRectangle("Content", color: .cyan, size: [150, 50])
        DashedDivider()
        CaptionRectangle("Content", color: .cyan, size: [150, 50])
    }
    .floatingCaption("VStack", .colorStyle(.cyan), .alignment(.topLeading))

    HStack {
        CaptionRectangle("Content", color: .mint, height: 50)
        DashedDivider(axis: .vertical)
        CaptionRectangle("Content", color: .mint, width: 70)
        DashedDivider(axis: .vertical)
        CaptionRectangle("Content", color: .mint)
    }
    .frame(height: 50)
    .floatingCaption("HStack with fixed height", .colorStyle(.cyan), .alignment(.topLeading))

    HStack {
        CaptionRectangle("Content", color: .mint, height: 50)
        DashedDivider(axis: .vertical)
        CaptionRectangle("Content", color: .mint, width: 70)
        DashedDivider(axis: .vertical)
        CaptionRectangle("Content", color: .mint)
    }
//    .frame(height: 50)
    .floatingCaption("HStack", .colorStyle(.cyan), .alignment(.topLeading))
}


#Preview("Space Distribution", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var fixedHeight: Double = 100

    PreviewCaption("""
        Seems `HStack` (and likely also `VStack`) will resize an internal view that is trying to
        expand its height with the size the `HStack` is allowed to have, even if content
        inside is making it larger.
        """)
    .font(.caption)

    Slider.captioned(
        "Fixed Height",
        value: $fixedHeight, in: 0...500,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)

    VStack {
        VStack {
            VStack {
                CaptionRectangle("Fixed Height", color: .brown, size: [150, fixedHeight])
                DashedDivider()
                CaptionRectangle("Content", color: .cyan, size: [150, 30])
            }
            .floatingCaption("VStack", .colorStyle(.cyan), .alignment(.topLeading))

            HStack {
                CaptionRectangle("Content", color: .mint, size: [70, 30])
                DashedDivider(axis: .vertical)
                CaptionRectangle("Content", color: .mint, size: [70, 30])
                DashedDivider(axis: .vertical)
                CaptionRectangle("Max Size", color: .mint, width: 70)
            }
            .frame(height: 70)
            .floatingCaption("HStack with Set Height", .colorStyle(.cyan), .alignment(.topLeading))

            HStack {
                CaptionRectangle("Content", color: .mint, size: [70, 30])
                DashedDivider(axis: .vertical)
                CaptionRectangle("Content", color: .mint, size: [70, 30])
                DashedDivider(axis: .vertical)
                CaptionRectangle("Squished\nMax Size", color: .red, width: 70)
            }
            .floatingCaption("HStack", .colorStyle(.cyan), .alignment(.topLeading))
        }

        VisibleSpacer()
    }
}
