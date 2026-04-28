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
    public init(_ string: String) {
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
            paddingEdges: [])

            // Settings for possible standalone top.
//            contentPaddingEdges: .all,
//            safeAreaPaddingEdges: .not(.top),
//            backgroundPaddingEdges: .all)
    }


    /// Creates a new preview caption appending a paragraph.
    public func paragraph(_ string: String) -> Self {
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

    static func fixedHeightContent(height: CGFloat = 100) -> some View {
        CaptionRectangle(
            "Preview\nContent", color: .red,
            width: 100, height: height)
    }

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    PreviewCaption("""
        **Caption** for a preview that can have text defined
        in _multiple lines_ with `Markdown support`.
        """)
    .paragraph("Along with additional paragraphs: \(Strings.loremIpsum(words: 30)).")

    PreviewContent.fixedHeightContent()
}


#Preview("Spacing", traits: .headerFooter, PreviewContent.layout) {
    PreviewCaption("""
        Markdown parsing replaces newlines
        with
        spaces
        in
        a
        multiline string.
        However   internal   spacing   between   words   is   preserved.
        """)
    .debugOverlay()

    PreviewContent.fixedHeightContent()
}


#Preview("LoremIpsum", traits: .headerFooter, PreviewContent.layout) {
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

    PreviewContent.fixedHeightContent(height: fixedHeight)
}

#Preview("Caption", traits: .fixedHeader, PreviewContent.layout) {
    PreviewCaption("Modifier functions like `.font(.caption)` can be used to modify the internal `Text`s.")
        .paragraph("Including the text of any additional paragraphs.")
    .font(.caption)
    .foregroundStyle(.brown)

    PreviewContent.fixedHeightContent()
}


#Preview("Standalone", traits: PreviewContent.layout) {
    PreviewCaption("This is a preview caption without the header/footer preview trait.")
        .paragraph("If this becomes a common use, options for edge padding should be considered.")

    PreviewContent.fixedHeightContent()
    VisibleSpacer()
}


#Preview("Text.fixedSize Issue", traits: .fixedHeader, .iPhoneProSizeLayout) {
    PreviewCaption("""
        Without forced layout, using `Text.fixedSize` causes layout issues in macOS previews
        any time there is other views with flexible height.
        """)
    .paragraph("This issues does not ocurr in iOS.")

    VisibleSpacer()
}
