//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Experimental view that displays a vertical text, reading either upwards or downwards.
///
/// This view wraps a SwiftUI `Text` view, rotates it, and uses a `TransposeLayout` to negotiate its
/// size.
struct VerticalText: View {

    static let defaultDirection: Direction = .downwards

    let content: Text
    let direction: Direction

    /// The direction in which the text reads.
    enum Direction: Sendable {
        /// Text reads from bottom to top, rotated 1/4 of a turn counter-clockwise.
        case upwards
        /// Text reads from top to bottom, rotated 1/4 of a turn clockwise.
        case downwards

        var angle: Angle {
            switch self {
            case .upwards:   .turn(-1/4)
            case .downwards: .turn(1/4)
            }
        }
    }


    init(_ content: Text, direction: Direction = Self.defaultDirection) {
        self.content = content
        self.direction = direction
    }


    init(_ key: LocalizedStringKey, direction: Direction = Self.defaultDirection) {
        self.content = Text(key)
        self.direction = direction
    }


    init(verbatim: String, direction: Direction = Self.defaultDirection) {
        self.content = Text(verbatim: verbatim)
        self.direction = direction
    }


    var body: some View {
        TransposeLayout {
            content
            .rotationEffect(direction.angle)
        }
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var wordCount: Double = 10

    Slider.captioned(
        "Word count",
        value: $wordCount,
        in: 0...100,
        valueFormat: .arithmeticRoundedInteger)

    let string = Strings.loremIpsum(words: wordCount.arithmeticRoundedInt)
    HStack {
        VerticalText(verbatim: string)
        .floatingCaption("Downwards Text", .colorStyle(.red), .alignment(.outerTrailingTop))

        CaptionRectangle("Fixed Content", color: .red, size: [200, 100])
    }

    DashedDivider()

    HStack {
        VerticalText(verbatim: string, direction: .upwards)
        .floatingCaption("Upwards Text", .colorStyle(.blue), .alignment(.outerTrailingTop))

        CaptionRectangle("Fixed Content", color: .blue, size: [200, 100])
    }
}


#Preview("VStack", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var verticalWordCount: Double = 20
    @Previewable @State var horizontalWordCount: Double = 20

    Slider.captioned(
        "Vertical word count",
        value: $verticalWordCount,
        in: 0...100,
        valueFormat: .arithmeticRoundedInteger)
    Slider.captioned(
        "Horizontal word count",
        value: $horizontalWordCount,
        in: 0...100,
        valueFormat: .arithmeticRoundedInteger)

    VStack {
        VerticalText(verbatim: Strings.loremIpsum(words: verticalWordCount.arithmeticRoundedInt))
        Text(verbatim: Strings.loremIpsum(words: horizontalWordCount.arithmeticRoundedInt))
        CaptionRectangle("Fixed Content", color: .yellow, size: [100, 100])
    }
    .font(.caption)
    .floatingCaption("VStack", .colorStyle(.orange), .alignment(.outerBottomTrailing))
}


#Preview("HStack", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var verticalWordCount: Double = 30
    @Previewable @State var horizontalWordCount: Double = 30

    Slider.captioned(
        "Vertical word count",
        value: $verticalWordCount,
        in: 0...100,
        valueFormat: .arithmeticRoundedInteger)
    Slider.captioned(
        "Horizontal word count",
        value: $horizontalWordCount,
        in: 0...100,
        valueFormat: .arithmeticRoundedInteger)

    HStack {
        VerticalText(verbatim: Strings.loremIpsum(words: verticalWordCount.arithmeticRoundedInt))
        Text(verbatim: Strings.loremIpsum(words: horizontalWordCount.arithmeticRoundedInt))
        CaptionRectangle("Fixed Content", color: .yellow, size: [100, 100])
    }
    .font(.caption)
    .floatingCaption("VStack", .colorStyle(.orange), .alignment(.outerBottomTrailing))
}
