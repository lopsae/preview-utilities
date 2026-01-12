//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


#if os(macOS)

/// Wraps the preview content in a `VStack` and a `.frame` with a given size to force the preview
/// size. Intended to fix layout issues in macOS previews.
///
/// Previews in macOS are able to override the size of the window even when `.fixedLayout` trait is
/// used. This trait simply wraps the content to a given frame size, forcing the content to use that
/// size.
///
/// This modifier was built to fix issues with multiline `Text` views using `fixedSize`, which in
/// macOS cause issues with other flexible views. In general this modifier is not necessary unless
/// `Text` with `fixedSize` can influence the size of the preview, for example, when using
/// ``PreviewCaption``.
///
/// See example previews for more details.
struct MacOSForcedSizeLayoutPreviewModifier: PreviewModifier {

    let size: CGSize


    init(size: CGSize) {
        self.size = size
    }


    func body(content: Content, context _: ()) -> some View {
        VStack(spacing: .zero) {
            content
        }.frame(size: size)
    }

}
#endif


extension PreviewTrait where T == Preview.ViewTraits {

    /// In macOS, applies a forced size modifier and the `.iPhoneProSizeLayout` trait; in other
    /// platforms this returns only the `.iPhoneProSizeLayout` trait.
    ///
    /// In general this trait is not necessary unless `Text` with `fixedSize` can influence the size
    /// of the preview, for example, when using ``PreviewCaption``. Use `.iPhoneProSizeLayout`
    /// directly unless the forced size is needed.
    public static var iPhoneProSizeForcedLayout: PreviewTrait {
        #if os(macOS)
        return .init(
            .modifier(MacOSForcedSizeLayoutPreviewModifier(size: iPhoneProSize)),
            .iPhoneProSizeLayout
        )
        #else
        return .iPhoneProSizeLayout
        #endif
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    struct TextWithFixedHeight: View {
        var caption: LocalizedStringKey
        @Binding var wordCount: Double
        @Binding var isFixedHeight: Bool

        var body: some View {
            VStack {
                Text(caption)
                    .maxWidthFrame(alignment: .leading)
                    .padding(8)
                    .background(.gray.tertiary)
                    .containerShape(.rect(cornerRadius: 8))
                Slider(
                    "Word count",
                    value: $wordCount,
                    in: 0...100,
                    valueFormat: .arithmeticRoundedInteger)
                Text("Word Count: \(wordCount.arithmeticRoundedInt)")
                    .monospaced().font(.caption)
                Toggle("Is Fixed Height", isOn: $isFixedHeight)

                Divider()

                Text(Strings.loremIpsum(words: wordCount.rounded().asInt))
                    // This `fixedSize` is the culprit of the sizing issues.
                    .fixedSize(horizontal: false, vertical: isFixedHeight)
                Rectangle().fill(.red.tertiary)
            }
            .padding()
            .debugOverlay(.size)
        }
    }

}


// MARK: - Previews


#Preview("ForcedLayout", traits: .iPhoneProSizeForcedLayout) {
    @Previewable @State var wordCount: Double = 20
    @Previewable @State var isFixedHeight: Bool = true

    PreviewContent.TextWithFixedHeight(
        caption: "`ForcedLayout` keeps the size of the view in macOS.",
        wordCount: $wordCount, isFixedHeight: $isFixedHeight)
}


#Preview("No ForcedLayout", traits: .iPhoneProSizeLayout) {
    @Previewable @State var wordCount: Double = 20
    @Previewable @State var isFixedHeight: Bool = true

    PreviewContent.TextWithFixedHeight(
        caption: "Without forced size, window height explodes in macOS.",
        wordCount: $wordCount, isFixedHeight: $isFixedHeight)
}


#Preview("Multiple Views", traits: .iPhoneProSizeForcedLayout) {
    Text("Several texts to ascertain that size is applied to all content as a whole.")
    Text("One")
    Text("Two")
    Text("Three")
    Text("Four")
}


// MARK: - Examples


#Preview("Example: Basic", traits: .fixedLayout(width: 400, height: 300)) {
    VStack {
        Text("Using a `Text` with `fixedLayout` in a macOS preview causes the preview height to explode.")

        Divider()

        // When fixedSize is used and the text is multiline, the rectangles expand masively in size.
        Text(Strings.loremIpsum)
            .fixedSize(horizontal: false, vertical: true)
        Rectangle().fill(.red.tertiary)
    }
    .padding()
    .debugOverlay(.size)
}


#Preview("Example: fixedHeight false", traits: .fixedLayout(width: 400, height: 300)) {
    @Previewable @State var wordCount: Double = 20
    @Previewable @State var isFixedHeight: Bool = false

    PreviewContent.TextWithFixedHeight(
        caption: "`fixedLayout` is respected when preview starts with `fixedHeight` to `false`.",
        wordCount: $wordCount, isFixedHeight: $isFixedHeight)
}


#Preview("Example: fixedHeight true", traits: .fixedLayout(width: 400, height: 300)) {
    @Previewable @State var wordCount: Double = 20
    @Previewable @State var isFixedHeight: Bool = true

    PreviewContent.TextWithFixedHeight(
        caption: "`fixedLayout` fails and height explodes when preview **starts** with `fixedHeight` to `true`.",
        wordCount: $wordCount, isFixedHeight: $isFixedHeight)
}


#Preview("Example: with frame", traits: .fixedLayout(width: 400, height: 300)) {
    @Previewable @State var wordCount: Double = 20
    @Previewable @State var isFixedHeight: Bool = true

    PreviewContent.TextWithFixedHeight(
        caption: "`frame` overrides the `fixedLayout` preview trait entirely, and forces the view to size.",
        wordCount: $wordCount, isFixedHeight: $isFixedHeight
    )
    .frame(width: 400, height: 300)
}


#Preview("Example: with sized content", traits: .fixedLayout(width: 400, height: 300)) {
    Text("In macOS, if root content defines its own size,\nit will override the `fixedLayout` preview trait.")

    Rectangle()
        .fill(.red.tertiary)
        .frame(square: 100)
        .floatingCaption("Fixed Size", .height)
}


#Preview("Example: top-most frame", traits: .fixedLayout(width: 400, height: 300)) {
    Text("In macOS, at **top most frame** can keep the window size.")
        .padding(.top)

    Rectangle()
        .fill(.red.tertiary)
        .frame(square: 100)
        .floatingCaption("Fixed Size", .height)
        .frame(width: 400, height: 300)
}
