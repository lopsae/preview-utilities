//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// TODO: test with more that one element, since its unclear how frame will apply to content not wrapped in a container like VStack.


#if os(macOS)

/// Wraps the preview content `.frame` with a given size forcing the preview. Intended to fix layout
/// issues in macOS previews.
///
/// Previews in macOS are able to override the size of the window even when `.fixedLayout` trait is
/// used. In some cases, like multiline `Text` views using `fixedSize` this can completely render
/// the preview unusable. This trait simply wraps the content to a given frame size, forcing the
/// content to use that size.
struct MacOSForcedSizeLayoutPreviewModifier: PreviewModifier {

    let size: CGSize


    init(size: CGSize) {
        self.size = size
    }


    func body(content: Content, context _: ()) -> some View {
        content.frame(size: size)
    }

}
#endif


extension PreviewTrait where T == Preview.ViewTraits {

    public static var iPhoneProSizeForcedLayout: PreviewTrait {
        #if os(macOS)
        .init(
            .modifier(MacOSForcedSizeLayoutPreviewModifier(size: iPhoneProSize)),
            .fixedLayout(size: iPhoneProSize)
        )
        #else
        return .fixedLayout(size: iPhoneProSize)
        #endif
    }

}


// MARK: - Previews


#Preview("ForcedLayout", traits: .iPhoneProSizeForcedLayout) {
    @Previewable @State var wordCount: Double = 20
    @Previewable @State var isFixedHeight: Bool = true

    VStack {
        Text("Forced Layout keeps the size of the view in macOS.")
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
        // When fixedSize is used and the text is multiline, the rectangles expand masively in size.
            .fixedSize(horizontal: false, vertical: isFixedHeight)
        Rectangle().fill(.red.tertiary)
    }
    .padding()
    .debugOutline(options: .size)
}


#Preview("No ForcedLayout", traits: .iPhoneProSizeLayout) {
    @Previewable @State var wordCount: Double = 20
    @Previewable @State var isFixedHeight: Bool = true

    VStack {
        Text("Without forced size, window height explodes again in macOS.")
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
        // When fixedSize is used and the text is multiline, the rectangles expand masively in size.
            .fixedSize(horizontal: false, vertical: isFixedHeight)
        Rectangle().fill(.red.tertiary)
    }
    .padding()
    .debugOutline(options: .size)
}


// FIXME: frame size is applied to all elements individually
#Preview("Texts", traits: .iPhoneProSizeForcedLayout) {
    Text("Several texts to ascertain that size is applied to all content as a whole.")
    Text("One")
    Text("Two")
    Text("Three")
    Text("Four")
}


// MARK: - Examples


#Preview("fixedSize false", traits: .fixedLayout(width: 400, height: 300)) {
    @Previewable @State var wordCount: Double = 10
    @Previewable @State var isFixedHeight: Bool = false

    VStack {
        Text("`fixedLayout` is respected when preview starts with `fixedHeight` to `false`.")
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
            .fixedSize(horizontal: false, vertical: isFixedHeight)
        Rectangle().fill(.red.tertiary)
    }
    .padding()
    .debugOutline(options: .size)
}


#Preview("fixedSize true", traits: .fixedLayout(width: 400, height: 300)) {
    @Previewable @State var wordCount: Double = 10
    @Previewable @State var isFixedHeight: Bool = true

    VStack {
        Text("`fixedLayout` fails and height increases considerably when preview starts with `fixedHeight` to `true`.")
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
        // When fixedSize is used and the text is multiline, the rectangles expand masively in size.
            .fixedSize(horizontal: false, vertical: isFixedHeight)
        Rectangle().fill(.red.tertiary)
    }
    .padding()
    .debugOutline(options: .size)
}


#Preview("With frame", traits: .fixedLayout(width: 400, height: 300)) {
    @Previewable @State var wordCount: Double = 10
    @Previewable @State var isFixedHeight: Bool = true

    VStack {
        Text("`frame` overrides the `fixedLayout` entirely, and forces the view to size.")
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
        // When fixedSize is used and the text is multiline, the rectangles expand masively in size.
            .fixedSize(horizontal: false, vertical: isFixedHeight)
        Rectangle().fill(.red.tertiary)
    }
    .padding()
    .debugOutline(options: .size)
    .frame(width: 450, height: 300)
}
