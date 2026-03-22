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


#Preview("Eg:MinFrame", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var contentLength: Double = 150
    @Previewable @State var minFrameLength: Double = 100
    @Previewable @State var fixedFrameLength: Double = 200

    PreviewCaption("""
        A `.frame` with a minimum size will grow larger along the content, but no larger than
        the size provided by a fixed frame.
        """
    ).paragraph("""
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
