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


#Preview("Stacks", traits: .fixedHeader, PreviewContent.layout) {
    VStack {
        VerticalText("Vertical in VStack", direction: .upwards)
            .border(.tertiary)
    }
    .frame(maxWidth: .infinity)
    .border(.quaternary)

    HStack(alignment: .center) {
        VerticalText("Left", direction: .upwards)
            .border(.tertiary)
        ClearRectangle(width: 100, height: 150, fill: .indigo.gradient.tertiary)
        VerticalText("Right", direction: .downwards)
            .border(.tertiary)
    }
}
