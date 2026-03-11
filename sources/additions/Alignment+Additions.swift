//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension VerticalAlignment {
    nonisolated
    static var verticalCenter: Self { .center }
}


extension HorizontalAlignment {
    nonisolated
    static var horizontalCenter: Self { .center }
}


/// Enumeration of the alignment instances available in ``SwiftUICore/HorizontalAlignment``.
///
/// Allows previews and other consumers to list the alignment options available.
nonisolated
enum HorizontalAlignmentEnum: String, SelfIdentifiable, CaseIterable {

    case leading, center, traling

    /// Returns the corresponding ``SwiftUI/HorizontalAlignment``.
    var alignment: HorizontalAlignment {
        switch self {
        case .leading: .leading
        case .center:  .center
        case .traling: .trailing
        }
    }

    var displayName: String { rawValue }

}


/// Enumeration of the alignment instances available in ``SwiftUI/VerticalAlignment``.
///
/// Allows previews and other consumers to list the alignment options available.
nonisolated
enum VerticalAlignmentEnum: String, SelfIdentifiable, CaseIterable {

    case top, center, bottom
    case firstTextBaseline, lastTextBaseline

    /// Returns the corresponding ``SwiftUI/VerticalAlignment``.
    var alignment: SwiftUI.VerticalAlignment {
        switch self {
        case .top:    .top
        case .center: .center
        case .bottom: .bottom
        case .firstTextBaseline: .firstTextBaseline
        case .lastTextBaseline:  .lastTextBaseline
        }
    }

    var displayName: String {
        switch self {
        case .top, .center, .bottom: rawValue
        case .firstTextBaseline: "first text baseline"
        case .lastTextBaseline:  "last text baseline"
        }
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("AlignmentsEnums", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var horizontalAlignment: HorizontalAlignmentEnum = .center
    @Previewable @State var verticalAlignment: VerticalAlignmentEnum = .center

    Picker(
        "Horizontal",
        selection: $horizontalAlignment,
        selectables: HorizontalAlignmentEnum.allCases,
        elementFormat: .capitalized(property: \.displayName)
    ).pickerStyle(.segmented)

    VStack(alignment: horizontalAlignment.alignment) {
        Text("Lorem ipsum dolor")
        CaptionRectangle(
            "Fixed Size", color: .indigo, size: .init(width: 200, height: 50),
            traits: .size, .alignment(.topLeading))
        Text("Text with\nmultiple\nlines")
    }
    .floatingCaption("VStack", .colorStyle(.indigo), .alignment(.outerBottomTrailing))

    DashedDivider()
        .padding(.vertical)

    Picker(
        "Vertical",
        selection: $verticalAlignment,
        selectables: VerticalAlignmentEnum.allCases,
        elementFormat: .capitalized(property: \.displayName)
    ).pickerStyle(.segmented)

    HStack(alignment: verticalAlignment.alignment) {
        Text("Lorem ipsum dolor")
        CaptionRectangle(
            "Fixed Size", color: .purple, size: .init(width: 100, height: 150),
            traits: .size, .alignment(.top))
        Text("Text with\nmultiple\nlines")
    }
    .floatingCaption("HStack", .colorStyle(.purple), .alignment(.outerBottomTrailing))

    VisibleSpacer()
}
