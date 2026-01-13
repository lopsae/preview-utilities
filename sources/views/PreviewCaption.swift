//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Caption with a background similar to the header and footer created by
/// ``HeaderFooterContainer``. Intended to provide additional detail along a preview.
public struct PreviewCaption: View {

    /// String for each text produced in the caption.
    let textStrings: [String]

    /// Creates a preview caption with a given sequence of strings joined together.
    ///
    /// All the strings are joined into a single string: any whitespace present at the edgesof two
    /// strings is preserved; if no whitespace is present between two strings a single space is
    /// added between them.
    init(_ strings: String...) {
        guard !strings.isEmpty else {
            self.textStrings = [String()]
            return
        }

        let joinedString = Self.joinStrings(strings)
        self.textStrings = [joinedString]
    }


    private init(textStrings: [String]) {
        self.textStrings = textStrings
    }


    public var body: some View {
        VStack(spacing: 8 ) {
            ForEach(textStrings.enumerated(), id: \.offset) { index, string in
                let markdownString = (try? AttributedString(markdown: string)) ?? AttributedString("[markdown failed!] " + string)
                Text(markdownString)
                    .fixedSize(horizontal: false, vertical: true)
                    .maxWidthFrame(alignment: .leading)
            }
        }
        .padding()
        .background {
            Rectangle().fill(HeaderFooterContainer.backgroundStyle)
                .roundedRectangleClip(cornerRadius: HeaderFooterContainer.minimumConcentricRadius)
        }
        .padding(.horizontal)
    }


    /// Creates a new preview caption appending a paragraph with a given sequence of strings joined
    /// together.
    func paragraph(_ strings: String...) -> Self {
        let joinedString = Self.joinStrings(strings)
        return .init(textStrings: textStrings + [joinedString])
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

}


// MARK: - Previews


#Preview("Default", traits: .regularSpacing, .headerFooter, PreviewContent.layout) {
    PreviewCaption(
        "**Caption** for a preview",
        "that can have text defined",
        "in _multiple lines_ with ",
        "`Markdown support`.",
        "Lorem ipsum"
    )

    Rectangle().fill(.red.tertiary)
        .frame(square: 100)
}


#Preview("Spacing", traits:  .regularSpacing, .headerFooter, PreviewContent.layout) {
    PreviewCaption(
        "**Inserts", "spaces**", "between", "parameters.",
        "\nNewlines are ignored.",
        "Existing", "  space", "  is  ", "**persisted**."
    )

    Rectangle().fill(.red.tertiary)
        .frame(square: 100)
}


// FIXME: in IOS, content freezes when fixed height grows enough to push the footer out of layout, likely caused by PreviewFooter issues.
// FIXME: this still seems to be happening after possible fix in minSafeAreaPadding, add printing capability to test.
// TODO: this should have enough text to push out of the given size layout, to show that large text is respected.
#Preview("LoremIpsum", traits:  .regularSpacing, .headerFooter(.fixed), PreviewContent.layout) {
    @Previewable @State var wordCount: Double = 50
    @Previewable @State var fixedHeight: Double = 200

    PreviewCaption(Strings.loremIpsum(words: wordCount.arithmeticRoundedInt))

    VStack {
        Slider(
            "Word Count",
            value: $wordCount,
            in: 0...100,
            valueFormat: .arithmeticRoundedInteger)
        Slider(
            "Fixed Height",
            value: $fixedHeight,
            in: 0...800,
            valueFormat: .arithmeticRoundedInteger)
    }
    .padding()

    Rectangle().fill(.red.tertiary)
        .frame(width: 100, height: fixedHeight)
        .debugOverlay(.hairline, .size)
}

#Preview("Paragraph", traits:  .regularSpacing, .fixedHeader, PreviewContent.layout) {
    PreviewCaption(
        "**Paragraphs**"
    ).paragraph(
        "To display text in different **paragraphs**"
    ).paragraph(
        "Use the _paragraph function_."
    )

    Rectangle().fill(.red.tertiary)
        .frame(square: 100)
}


#Preview("Empty", traits:  .regularSpacing, .fixedHeader, PreviewContent.layout) {
    PreviewCaption()

    Rectangle().fill(.red.tertiary)
        .frame(square: 100)
}


#Preview("Text.fixedSize Issue", traits: .regularSpacing, .fixedHeader, .iPhoneProSizeLayout) {
    PreviewCaption(
        "Without forced layout, using `Text.fixedSize` causes layout issues in macOS previews",
        "any time there is other views with flexible height."
    ).paragraph(
        "This issues does not ocurr in iOS."
    )

    Rectangle().fill(.red.tertiary)
        .frame(width: 100)
}
