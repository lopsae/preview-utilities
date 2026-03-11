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

    // TODO: could use display property?
    var displayName: String { rawValue }

}


/// Enumeration of the alignment instances available in ``SwiftUI/VerticalAlignment``.
///
/// Allows previews and other consumers to list the alignment options available.
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

    // TODO: could use display property?
    var displayName: String {
        switch self {
        case .top, .center, .bottom: rawValue
        case .firstTextBaseline: "first text baseline"
        case .lastTextBaseline:  "last text baseline"
        }
    }

}
