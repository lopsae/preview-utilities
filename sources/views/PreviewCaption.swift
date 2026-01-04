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
        "`Markdown support`."
    )

    Rectangle().fill(.red.tertiary)
        .frame(square: 100)
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
