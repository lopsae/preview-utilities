//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// View that expands to the available space and displays the given content constrained and aligned
/// to the available space. The view uses only the available space even when the content is larger.
///
/// Content larger that the available space will overflow outside of the view while still respecting
/// the given alignment. Each view in the content is constrained individually, even if one view
/// overflows over the available space, all other views will resize themselves to the available
/// space.
///
/// Views in content are placed in an implicit `ZStack`. Providing more that one view will stack
/// them on top of each other, the last view provided appears at the front of the stack.
///
/// Internally, each view in content is individually constrained to a `frame` sized to the available
/// space.
///
/// This view provides a behaviour that `.frame` is unable to support: using a `.frame` that expands
/// to occupy all available space (with `.infinity` for width and height) will behave the same while
/// the content is smaller that the available space. However, if the content is larger, then the
/// size of the frame will expand to the size of the content. This view **always** contrains the content
/// to the available space.
public struct ConstrainedFill<Content>: View where Content : View {
    let alignment: Alignment
    let content: () -> Content

    public init(
        alignment: Alignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.content = content
    }

    public var body: some View {
        GeometryReader { proxy in
            Group {
                content()
            }
            .frame(size: proxy.size, alignment: alignment)
        }
    }
}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var fixedHeight: Double = 150
    @Previewable let image = SyncImageGenerator.generateImage(
        with: "Huge", caption: "500x300",
        size: .init(width: 500, height: 300),
        border: true)

    PreviewCaption("""
        Using `ContrainedFill` with an image configured with `.scaledToFill` will allow the image
        to scale as needed, while using only the available space.
        """)

    Slider.captioned("Fixed Height", value: $fixedHeight, in: 0...800, valueFormat: .fractionLength(2))

    VisibleSpacer()
    VStack {
        Text.caption("Top")
        ConstrainedFill(alignment: .bottom) {
            image
            .resizable()
            .scaledToFill()
            .opacity(0.7)
        }
        .floatingCaption(
            "ConstrainedFill", .size, .alignment(.bottomTrailing),
            .style(.blue), .borderWidth(3), .padding(5))
        Text.caption("Bottom")
    }
    .frame(height: fixedHeight)
    .floatingCaption("VStack with Fixed Height", .size, .alignment(.outerBottomTrailing), .style(.red))

    VisibleSpacer()
}


// TODO: Move to own file.
enum SwiftHorizontalAlignment: String, SelfIdentifiable, CaseIterable {

    case leading, center, traling

    var alignment: HorizontalAlignment {
        switch self {
        case .leading: .leading
        case .center:  .center
        case .traling: .trailing
        }
    }

}


enum SwiftVerticalAlignment: String, SelfIdentifiable, CaseIterable {

    case top, center, bottom
    case firstTextBaseline, lastTextBaseline

    var alignment: VerticalAlignment {
        switch self {
        case .top:    .top
        case .center: .center
        case .bottom: .bottom
        case .firstTextBaseline: .firstTextBaseline
        case .lastTextBaseline:  .lastTextBaseline
        }
    }

}


#Preview("Alignments", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var horizontalAlignment: SwiftHorizontalAlignment = .center
    @Previewable @State var verticalAlignment: SwiftVerticalAlignment = .center

    Picker(
        "Horizontal",
        selection: $horizontalAlignment,
        caseFormat: .rawValueCapitalized()
    ).pickerStyle(.segmented)

    Picker(
        "Vertical",
        selection: $verticalAlignment,
        caseFormat: .rawValueCapitalized()
    ).pickerStyle(.segmented)

    VisibleSpacer()
    HStack {
        VisibleSpacer(axis: .horizontal)
        let alignment: Alignment = .init(
            horizontal: horizontalAlignment.alignment,
            vertical: verticalAlignment.alignment)
        ConstrainedFill(alignment: alignment) {
            CaptionRectangle(
                "Fixed Size", color: .red, size: .init(squareOf: 300),
                traits: .size, .alignment(.topLeading))
            CaptionRectangle("Rectangle", color: .green)
            Text(Strings.sphinxOfBlackQuartz)
        }
        .floatingCaption("ContrainedFill", .colorStyle(.blue), .alignment(.outerBottomTrailing))

        VisibleSpacer(axis: .horizontal)
    }
    VisibleSpacer()
}


#Preview("Example-ScaledToFit/Fill", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var fixedHeight: Double = 150
    @Previewable @State var fitOrFill: String = "fit"
    @Previewable let image = SyncImageGenerator.generateImage(
        with: "Huge", caption: "500x300",
        size: .init(width: 500, height: 300),
        border: true)

    PreviewCaption("""
        Shows the different behaviours of a resizable image configured to **fit** or to **fill**
        its available space.
        """)
    .paragraph("**Fit** will respect both axis.")
    .paragraph("**Fill** will break one of the axis and may pushing elements outward.")

    Slider.captioned("Fixed Height", value: $fixedHeight, in: 0...800, valueFormat: .fractionLength(2))
    Picker(
        "Fit or Fill",
        selection: $fitOrFill,
        collection: ["fit", "fill"],
        id: \.self,
        elementFormat: .capitalized
    ).pickerStyle(.segmented)

    VisibleSpacer()
    VStack {
        Text.caption("Top")
        switch fitOrFill {
        case "fit":  image.resizable().scaledToFit().opacity(0.7)
        case "fill": image.resizable().scaledToFill().opacity(0.7)
        default: Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
        }
        Text.caption("Bottom")
    }
    .frame(height: fixedHeight)
    .floatingCaption("VStack with Fixed Height", .size, .alignment(.outerBottomTrailing), .style(.red))

    VisibleSpacer()
}
