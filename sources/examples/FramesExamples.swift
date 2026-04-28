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


#Preview("Eg: MinFrame", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var contentLength: Double = 150
    @Previewable @State var minFrameLength: Double = 100
    @Previewable @State var fixedFrameLength: Double = 200

    PreviewCaption("""
        A `.frame` with a minimum size will grow larger along the content, but no larger than
        the size provided by a fixed frame.
        """)
    .paragraph("""
        Notice that the frame with a minimum will keep the size of its content, unless pushed
        into a smaller size by the fixed frame.
        """)

    Slider.captioned(
        "Content Size",
        value: $contentLength,
        in: 0...400,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)

    Slider.captioned(
        "Min Frame Size",
        value: $minFrameLength,
        in: 0...400,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)

    Slider.captioned(
        "Fixed Frame Size",
        value: $fixedFrameLength,
        in: 0...400,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)

    CaptionRectangle("Fixed Size Content", color: .pink, size: .square(of: contentLength), traits: .size)
    .frame(minWidth: minFrameLength, minHeight: minFrameLength, alignment: .center)
    .floatingCaption("Min Frame", .size, .colorStyle(.blue), .alignment(.bottomLeading))
    .frame(width: fixedFrameLength, height: fixedFrameLength, alignment: .center)
    .floatingCaption("Fixed Frame", .size, .colorStyle(.mint), .alignment(.outerBottomTrailing))
}


#Preview("Eg: MinMaxFrame", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var contentLength: Double = 150
    @Previewable @State var minFrameLength: Double = 100
    @Previewable @State var maxFrameLength: Double = 200
    @Previewable @State var fixedFrameLength: Double = 250

    PreviewCaption("""
        A `.frame` with a minimum & maximum size will expand to its maximum, the size of the
        content is practically ignored.
        """)
    .paragraph("""
        Notice that the frame with a maximum will not grow larger that the size provided by an
        external frame.
        """)

    Slider.captioned(
        "Content Size",
        value: $contentLength,
        in: 0...400,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)

    Slider.captioned(
        "Min Frame Size",
        value: $minFrameLength,
        in: 0...400,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)

    Slider.captioned(
        "Max Frame Size",
        value: $maxFrameLength,
        in: 0...400,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)

    Slider.captioned(
        "Fixed Frame Size",
        value: $fixedFrameLength,
        in: 0...400,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)

    CaptionRectangle("Fixed Size Content", color: .pink, size: .square(of: contentLength), traits: .size)
    .frame(minWidth: minFrameLength, maxWidth: maxFrameLength, minHeight: minFrameLength, maxHeight: maxFrameLength, alignment: .center)
    .floatingCaption("MinMax Frame", .size, .colorStyle(.blue), .alignment(.bottomLeading))
    .overlay {
        ClearRectangle(size: .square(of: minFrameLength))
        .floatingCaption("Min Size", .size, .colorStyle(.purple), .alignment(.topLeading))
    }
    .frame(width: fixedFrameLength, height: fixedFrameLength, alignment: .center)
    .floatingCaption("Fixed Frame", .size, .colorStyle(.mint), .alignment(.outerBottomTrailing))
}
