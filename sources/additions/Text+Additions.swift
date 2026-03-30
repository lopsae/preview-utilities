//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Text {

    public static func caption(_ key: LocalizedStringKey) -> Self {
        Self(key).font(.caption)
    }

    public static func caption(verbatim string: String) -> Self {
        Self(verbatim: string).font(.caption)
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    Text("Regular `Text`")
    DashedDivider()
    Text.caption("Captioned `Text.caption`")
    DashedDivider()
    Text.caption("Text using `LocalizedStringKey`\ncan have *formatting*\nand new lines.")
    DashedDivider()
    Text.caption(verbatim: "Verbatim `String` does not support formatting")
}
