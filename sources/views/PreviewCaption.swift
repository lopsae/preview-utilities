//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Caption with a background similar to the header and footer created by
/// ``HeaderFooterContainerView``. Intended to provide additional detail along a preview.
struct PreviewCaption: View {

    let string: String

    /// Creates a preview caption with a given sequence of strings.
    ///
    /// All the strings are joined into a single string: if any whitespace is present at the edges
    /// of two strings, these are joined as-is; if no whitespace is present between strings, a
    /// single space is added between them.
    init(_ strings: String...) {
        guard !strings.isEmpty else {
            self.string = String()
            return
        }

        let stringsWithSpacing: [String] = strings.enumerated().map { index, string in
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

        print("String: >\(stringsWithSpacing.joined())<")
        self.string = stringsWithSpacing.joined()
    }


    var body: some View {
        Text(verbatim: string)
            .maxWidthFrame(alignment: .leading)
            .padding()
            .background {
                Rectangle().fill(.gray.tertiary)
                    .roundedRectangleClip(cornerRadius: HeaderFooterContainerView.minimumConcentricRadius)
            }
            .padding(.horizontal)
    }
}


// MARK: - Previews


#Preview("Default", traits: .regularSpacing, .headerFooter, .iphoneSize) {
    PreviewCaption(
        "Caption for a preview",
        "that can have text defined",
        "in multiple lines."
    )

    Rectangle().fill(.red.tertiary)
        .frame(square: 100)
}


#Preview("Spacing", traits:  .regularSpacing, .headerFooter, .iphoneSize) {
    PreviewCaption(
        "Normal", "space", "inserted", "between", "parameters.",
        "\n",
        "And  ", "existing", "  space", "  is  ", "persisted."
    )

    Rectangle().fill(.red.tertiary)
        .frame(square: 100)
}


#Preview("Empty", traits:  .regularSpacing, .headerFooter, .iphoneSize) {
    PreviewCaption()

    Rectangle().fill(.red.tertiary)
        .frame(square: 100)
}
