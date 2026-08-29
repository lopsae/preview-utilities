//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


extension Text {

    public static func caption(_ key: LocalizedStringKey) -> Self {
        Self(key).font(.caption)
    }

    public static func caption(verbatim string: String) -> Self {
        Self(verbatim: string).font(.caption)
    }

    /// Expands the view's width with matching frame and multiline alignment.
    ///
    /// Applies the given multiline text alignment and warps the view in a horizontally expanding
    /// frame with a matching alignment.
    /// 
    /// When applied to `Text` views, allows the text to expand to the available width and remain
    /// properly aligned when displaying multiple lines.
    ///
    /// - Parameter textAlignment: The text alignment to apply to multiline text, and to the
    ///   expanding frame.
    func expandingWidthFrame(textAlignment: TextAlignment = .leading) -> some View {
        self
        .multilineTextAlignment(textAlignment)
        .maxWidthFrame(
            alignment: textAlignment.horizontalAlignment.alignment(withOrthogonal: .center)
        )
    }

}


extension TextAlignment {

    /// The matching `HorizontalAlignment`.
    var horizontalAlignment: HorizontalAlignment {
        switch self {
        case .leading:  .leading
        case .center:   .center
        case .trailing: .trailing
        }
    }

}



// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .spacing(8), .headerFooter, PreviewContent.layout) {
    Text("Regular `Text`")
    DashedDivider()
    Text.caption("Captioned `Text.caption`")
    DashedDivider()
    Text.caption("Text using `LocalizedStringKey`\ncan have *formatting*\nand new lines.")
    DashedDivider()
    Text.caption(verbatim: "Verbatim `String` does not support formatting")
}


#Preview("ExpandingWidth", traits: .spacing(8), .headerFooter, PreviewContent.layout) {
    Text("Single Line Default")
    .expandingWidthFrame()

    DashedDivider()

    Text("Single Line Trailing")
    .expandingWidthFrame(textAlignment: .trailing)

    DashedDivider()

    Text("Multiline text\nwith default alignment")
    .expandingWidthFrame()

    DashedDivider()

    Text("Multiline text\nwith center alignment")
    .expandingWidthFrame(textAlignment: .center)

    DashedDivider()

    Text("Multiline text\nwith trailing alignment")
    .expandingWidthFrame(textAlignment: .trailing)
}
