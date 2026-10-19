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


extension Text.Layout {

    /// All the runs of the layout.
    public var runs: [Run] {
        flatMap { line in
            line.map { run in run }
        }
    }

    /// All the runs of the layout that have an attribute of the given type.
    /// - Parameter attributeType: The type of the attribute to find.
    /// - Returns: An array of tuples containing the run and associated attribute.
    public func attributedRuns<Attribute>(
        with attributeType: Attribute.Type
    ) -> [(Run, Attribute)]
    where Attribute: TextAttribute {
        flatMap { line in
            line.compactMap { run in
                run[attributeType.self].map { attribute in
                    (run, attribute)
                }
            }
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
