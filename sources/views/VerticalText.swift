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
    HStack {
        VerticalText("Downwards: \(Strings.loremIpsum(words: 10))")
        .floatingCaption("Downwards Text", .colorStyle(.red), .alignment(.outerTrailingTop))

        CaptionRectangle("Fixed Content", color: .red, size: [200, 100])
    }

    HStack {
        VerticalText("Upwards: \(Strings.loremIpsum(words: 10))", direction: .upwards)
        .floatingCaption("Upwards Text", .colorStyle(.blue), .alignment(.outerTrailingTop))

        CaptionRectangle("Fixed Content", color: .blue, size: [200, 100])
    }
}


#Preview("VStack", traits: .fixedHeader, PreviewContent.layout) {
    VStack {
        VerticalText(verbatim: Strings.loremIpsum(words: 10))
        Text(verbatim: Strings.loremIpsum(words: 10))
        CaptionRectangle("Fixed Content", color: .yellow, size: [100, 100])
    }
    .frame(maxWidth: .infinity)
    .floatingCaption("VStack", .colorStyle(.orange), .alignment(.outerBottomTrailing))
}


#Preview("HStack", traits: .fixedHeader, PreviewContent.layout) {
    HStack {
        VerticalText(verbatim: Strings.loremIpsum(words: 10))
        Text(verbatim: Strings.loremIpsum(words: 10))
        CaptionRectangle("Fixed Content", color: .yellow, size: [100, 100])
    }
    .frame(maxWidth: .infinity)
    .floatingCaption("VStack", .colorStyle(.orange), .alignment(.outerBottomTrailing))
}
