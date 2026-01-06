//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Caption with a background similar to the header and footer created by
/// ``HeaderFooterContainerView``. Intended to provide additional detail along a preview.
struct PreviewCaption: View {

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


    var body: some View {
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
            Rectangle().fill(HeaderFooterContainerView.backgroundStyle)
                .roundedRectangleClip(cornerRadius: HeaderFooterContainerView.minimumConcentricRadius)
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


// MARK: - Previews


#Preview("Default", traits: .regularSpacing, .headerFooter, .iphoneSize) {
    PreviewCaption(
        "**Caption** for a preview",
        "that can have text defined",
        "in _multiple lines_ with ",
        "`Markdown support`.",
        "Lorem ipsum"
    )

    Rectangle().fill(.red.tertiary)
        .frame(width: 100, height: 500)
}


#Preview("Spacing", traits:  .regularSpacing, .headerFooter, .iphoneSize) {
    PreviewCaption(
        "**Inserts", "space**", "between", "parameters.",
        "\nNewlines are ignored.",
        "Existing", "  space", "  is  ", "**persisted**."
    )

    Rectangle().fill(.red.tertiary)
        .frame(square: 100)
}


// FIXME: this showcases preview size issues when run in macOS.
#Preview("FixedSizeText Issue", traits: .fixedLayout(width: 400, height: 300)) {

    VStack {
        Rectangle().fill(.red.tertiary)
        Rectangle().fill(.red.secondary)
        Text(String.loremIpsum)
            .fixedSize(horizontal: false, vertical: true)
        Rectangle().fill(.red.secondary)
        Rectangle().fill(.red.tertiary)
    }
    // Setting this frame forces the window to the correct size.
//    .frame(width: 400, height: 300)

}


// FIXME: in IOS, content freezes when fixed height grows enough to push the footer out of layout, likely caused by PreviewFooter issues.
#Preview("LoremIpsum", traits:  .regularSpacing, .headerFooter(.fixed), .iphoneSize) {
    @Previewable @State var wordCount: Double = 50
    @Previewable @State var fixedHeight: Double = 200

    let loremIpsumWords = String.loremIpsum.components(separatedBy: .whitespacesAndNewlines)
    PreviewCaption(loremIpsumWords.prefix(wordCount.rounded().asInt).joined(separator: " "))

    VStack {
        Slider(
            "Word Count",
            value: $wordCount,
            in: 0...loremIpsumWords.beforeEndIndex.asDouble,
            valueFormat: .roundedIntegerToNearestOrEven)
        Slider(
            "Fixed Height",
            value: $fixedHeight,
            in: 0...800,
            valueFormat: .roundedIntegerToNearestOrEven)
    }
    .padding()

    Rectangle().fill(.red.tertiary)
        .frame(width: 100, height: fixedHeight)
        .debugOutline(lineWidth: 1, options: .size)
}

#Preview("Paragraph", traits:  .regularSpacing, .headerFooter, .iphoneSize) {
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


#Preview("Empty", traits:  .regularSpacing, .headerFooter, .iphoneSize) {
    PreviewCaption()

    Rectangle().fill(.red.tertiary)
        .frame(square: 100)
}
