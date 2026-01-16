//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Caption with a background similar to the header and footer created by
/// ``HeaderFooterContainer``. Intended to provide additional detail along a preview.
public struct PreviewCaption: View {

    /// Strings for each paragraph.
    let strings: [String]

    /// Creates a preview caption with the given string.
    ///
    /// The string is parsed as markdown and new lines are replaced with spaces, allowing to easily
    /// use multiline string literals.
    init(_ string: String) {
        self.strings = [string]
    }


    private init(strings: [String]) {
        self.strings = strings
    }


    public var body: some View {
        VStack(spacing: Defaults.padding * 2 / 3 ) {
            ForEach(strings.enumerated(), id: \.offset) { index, string in
                // Markdown initializer without options removes new lines from the resulting string.
                let markdownString = (try? AttributedString(markdown: string))
                    ?? AttributedString("[markdown failed!] " + string)
                Text(markdownString)
                    .fixedSize(horizontal: false, vertical: true)
                    .maxWidthFrame(alignment: .leading)
            }
        }
        .concentricSafeAreaBackground(
            fill: HeaderFooterContainer.backgroundStyle,
            paddingEdges: .horizontal)
    }


    /// Creates a new preview caption appending a paragraph.
    func paragraph(_ string: String) -> Self {
        return .init(strings: strings + [string])
    }


    /// Joins all the strings in a given array into a single string selectively adding whitespace.
    ///
    /// Any whitespace present at the edges of two strings is preserved; if no whitespace is present
    /// between two strings a single space is added between them.
    private static func joinStrings(_ strings: [String]) -> String {
        let stringsToJoin: [String] = strings.enumerated().map { index, string in
            let nextIndex = strings.index(after: index)
            guard strings.indices.contains(nextIndex) else {
                // Last, no modification.
                return string
            }
            let nextString = strings[nextIndex]
            if string.last?.isWhitespace == true || nextString.first?.isWhitespace == true {
                // Adyacent whitespace, no modification.
                return string
            } else {
                // No adyacent whitespace, add space.
                return string + " "
            }
        }
        return stringsToJoin.joined()
    }
}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeForcedLayout

    static let mockContent: some View = CaptionRectangle(
        "Preview\nContent",
        fill: .red.tertiary, stroke: .red.secondary,
        width: 100, height: 100)

}


// MARK: - Previews


#Preview("Default", traits: .regularSpacing, .headerFooter, PreviewContent.layout) {
    PreviewCaption("""
        **Caption** for a preview that can have text defined
        in _multiple lines_ with `Markdown support`.
        """)
    .paragraph("Along with additional paragraphs: \(String.natoPhoneticAlphabet.joined(separator: " "))")

    PreviewContent.mockContent
}


#Preview("Spacing", traits:  .regularSpacing, .headerFooter, PreviewContent.layout) {
    PreviewCaption("""
        Markdown parsing replaces newlines
        with
        spaces
        in
        a
        multiline string.
        However   internal   spacing   between   words   is   preserved.
        """)

    PreviewContent.mockContent
}


#Preview("LoremIpsum", traits:  .regularSpacing, .headerFooter, PreviewContent.layout) {
    @Previewable @State var wordCount: Double = 50
    @Previewable @State var fixedHeight: Double = 200

    PreviewCaption(Strings.loremIpsum(words: wordCount.arithmeticRoundedInt))

    VStack {
        Slider.captioned(
            "Word Count",
            value: $wordCount, in: 0...200,
            valueFormat: .arithmeticRoundedInteger)
        Slider.captioned(
            "Fixed Height",
            value: $fixedHeight, in: 0...800,
            currentValueFormat: .fractionLength(2),
            boundsValueFormat: .arithmeticRoundedInteger)
    }
    .padding()

    CaptionRectangle(
        "Fixed Content", fill: .red.gradient.tertiary, stroke: .red.secondary,
        width: 150, height: fixedHeight, traits: .height)
}

#Preview("Caption", traits:  .regularSpacing, .fixedHeader, PreviewContent.layout) {
    PreviewCaption(
        "Modifier functions like `.font(.caption)` can be used to modify the internal `Text`s."
    ).paragraph(
        "Including the text of any additional paragraphs."
    )
    .font(.caption)
    .foregroundStyle(.brown)

    PreviewContent.mockContent
}


#Preview("NoHeaderFooter", traits:  .regularSpacing, PreviewContent.layout) {
    PreviewCaption("This is a preview caption without the header/footer preview trait.")
        .paragraph("If this becomes a common use, options for edge padding should be considered.")

    PreviewContent.mockContent
    VisibleSpacer()
}


#Preview("Text.fixedSize Issue", traits: .regularSpacing, .fixedHeader, .iPhoneProSizeLayout) {
    PreviewCaption("""
        Without forced layout, using `Text.fixedSize` causes layout issues in macOS previews
        any time there is other views with flexible height.
        """
    ).paragraph("This issues does not ocurr in iOS.")

    VisibleSpacer()
}
