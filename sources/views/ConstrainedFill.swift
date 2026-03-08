//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// View that expands to the available space and displays the given content aligned within its
/// frame. The view uses only the available space even when the content is larger, it does not
/// expand. Content larger that the available space will overflow outside of the view in accordance
/// with the given alignment.
///
/// The content is internally added to an `overlay`, which uses an implicit `ZStack`. Providing
/// more that one view will stack them on top of each other, the last view that you list appears at
/// the front of the stack.
///
/// This view provides a behaviour that `.frame` is unable to support: using a `.frame` that expands
/// to occupy all available space (with `.infinity` for width and height) will behave the same while
/// the content is smaller that the available space. However, if the content is larger, then the
/// size of the frame will expand to the size of the content. This view ALWAYS contrains the content
/// to the available size.
struct ConstrainedFill<Content>: View where Content : View {
    let alignment: Alignment
    let content: () -> Content

    init(
        alignment: Alignment = .center,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.content = content
    }

    var body: some View {
        Rectangle()
        .hidden()
        .allowsHitTesting(false)
        .overlay(alignment: alignment) {
            content()
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
        .floatingCaption("ConstrainedFill", .size, .alignment(.bottomTrailing), .style(.blue))
        Text.caption("Bottom")
    }
    .frame(height: fixedHeight)
    .floatingCaption("VStack with Fixed Height", .size, .alignment(.outerBottomTrailing), .style(.red))

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
