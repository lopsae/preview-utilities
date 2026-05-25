//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Alignment positions for floating content.
///
/// Identifies the alignment positions for floating content over a parent view. Floating content is
/// content overlaid a parent view and aligned to an edge of its boundaries, either inside or
/// outside.
///
/// @Image(
///     source: "floating-alignment-alignment-examples",
///     alt: "Example floating alignments for inner top leading and outer bottom trailing"
/// ) {
///     Example floating alignments: _Outer Top Leading_ and _Inner Bottom Trailing_.
/// }
///
///
/// ### Inner Alignments
///
/// Inner alignments are composed by a ``FloatingAlignment/HorizontalAlignment`` and a ``FloatingAlignment/VerticalAlignment``.
/// These are intended to work as equivalents of the SwiftUI alignments with the same names, for
/// example aligning content to ``InnerAlignment/topLeading`` would be equivalent to aligning the
/// same content using a `SwiftUICore/Alignment/topLeading`.
///
/// @Image(
///     source: "floating-alignment-inner-alignments",
///     alt: "Illustration of all inner floating alignments."
/// ) {
///     All inner alignments.
/// }
///
/// ### Outer Alignments
///
/// Outer alignments are composed by a major component and a minor component. ``OuterAlignment``
/// defines the major components and identifies the edge to which the content will be primarily
/// aligned: top, leading, bottom, or trailing. The minor component determines the secondary
/// direction along that edge where the content will be aligned.
///
/// Outer alignments with a vertical major (top and bottom) support three minor components: leading,
/// center, and trailing.
///
/// ![Outer floating alignments with a vertical major.](floating-alignment-outer-with-vertical-major)
///
/// Outer alignments with a horizontal major (leading and trailing) support five minor components:
/// above, top, center, bottom, and under.
///
/// ![Outer floating alignments with a horizontal major.](floating-alignment-outer-with-horizontal-major)
///
///
/// ### Implementing floating content
///
/// This type only identifies the different positions for floating content. Consumers use this
/// information to align their own content though their own implementation. Each floating alignment
/// provides the appropriate ``ContentAlignments`` for content to align itself to the attached edge.
///
/// Two examples of this implementations are ``DebugOverlayModifier`` and ``FloatingCaptionModifier``.
public nonisolated
enum FloatingAlignment: CaseIterable, SelfIdentifiable, Sendable {

    /// An inner floating alignment.
    case inner(InnerAlignment)

    /// An outer floating alignment.
    case outer(OuterAlignment)

    enum Key: String, CaseIterable, SelfIdentifiable {
        case inner, outer
    }

    var key: Key {
        switch self {
        case .inner: .inner
        case .outer: .outer
        }
    }


    var displayNameComponents: [String] {
        let first = [key.rawValue]
        let rest = switch self {
        case .inner(let innerAlignment): innerAlignment.displayNameComponents
        case .outer(let outerAlignment): outerAlignment.displayNameComponents
        }

        return first + rest
    }


    var displayName: String { displayNameComponents.joined(separator: .space) }
    var hyphenatedName: String { displayNameComponents.joined(separator: .hyphen) }

    var abbreviatedName: String {
        displayNameComponents.map(formatting: .firstCharacter).joined()
    }


    var outerAlignment: OuterAlignment? {
        switch self {
        case .outer(let outerAlignment): outerAlignment
        case .inner: nil
        }
    }


    var forContent: SwiftUI.Alignment {
        switch self {
        case .inner(let innerAlignment): innerAlignment.swiftAlignment
        case .outer(let outerAlignment): outerAlignment.contentAlignment
        }
    }


    var forText: SwiftUI.TextAlignment {
        switch self {
        case .inner(let innerAlignment):
            return innerAlignment.horizontal.textAlignment
        case .outer(let outerAlignment):
            return outerAlignment.textAlignment
        }
    }


    var contentAlignments: ContentAlignments {
        .init(floatingAlignment: self)
    }


    // TODO: rename to component
    /// Horizontal alignment component of the floating alignment.
    var horizontal: HorizontalAlignment {
        switch self {
        case .inner(let innerAlignment): innerAlignment.horizontal
        case .outer(let outerAlignment): outerAlignment.horizontal
        }
    }


    // MARK: Shorthand functions


    /// Returns an outer floating alignment with the given horizontal major component, centered.
    ///
    /// E.g.: `outer(horizontal: .leading)` returns ``outerLeadingCenter``.
    ///
    /// For ``HorizontalAlignment/center``, defaults to return ``outerTrailingCenter``.
    public static func outer(horizontal: HorizontalAlignment) -> Self {
        switch horizontal {
        case .leading:  .outer(.leadingCenter)
        case .center:   .outer(.trailingCenter)
        case .trailing: .outer(.trailingCenter)
        }
    }


    // MARK: Shorthand properties


    // Inner Top
    public static let innerTopLeading:     Self = .inner(.topLeading)
    public static let innerTopCenter:      Self = .inner(.topCenter)
    public static let innerTopTrailing:    Self = .inner(.topTrailing)
    // Aliases.
    public static let innerTop:            Self = .innerTopCenter
    public static let topLeading:          Self = .innerTopLeading
    public static let top:                 Self = .innerTopCenter
    public static let topTrailing:         Self = .innerTopTrailing

    // Inner Center
    public static let innerLeadingCenter:  Self = .inner(.leadingCenter)
    public static let innerCenter:         Self = .inner(.center)
    public static let innerTrailingCenter: Self = .inner(.trailingCenter)
    // Aliases.
    public static let innerLeading:        Self = .innerLeadingCenter
    public static let innerTrailing:       Self = .innerTrailingCenter
    public static let leading:             Self = .innerLeadingCenter
    public static let center:              Self = .innerCenter
    public static let trailing:            Self = .innerTrailingCenter


    // Inner Bottom
    public static let innerBottomLeading:  Self = .inner(.bottomLeading)
    public static let innerBottomCenter:   Self = .inner(.bottomCenter)
    public static let innerBottomTrailing: Self = .inner(.bottomTrailing)
    // Aliases.
    public static let innerBottom:         Self = .innerBottomCenter
    public static let bottomLeading:       Self = .innerBottomLeading
    public static let bottom:              Self = .innerBottomCenter
    public static let bottomTrailing:      Self = .innerBottomTrailing


    // Outer Top Major
    public static let outerTopLeading:     Self = .outer(.topLeading)
    public static let outerTopCenter:      Self = .outer(.topCenter)
    public static let outerTopTrailing:    Self = .outer(.topTrailing)
    // Aliases.
    public static let outerTop:            Self = .outerTopCenter


    // Outer Bottom Major
    public static let outerBottomLeading:  Self = .outer(.bottomLeading)
    public static let outerBottomCenter:   Self = .outer(.bottomCenter)
    public static let outerBottomTrailing: Self = .outer(.bottomTrailing)
    // Aliases.
    public static let outerBottom:         Self = .outerBottomCenter


    // Outer Leading Major
    public static let outerLeadingAbove:   Self = .outer(.leadingAbove)
    public static let outerLeadingTop:     Self = .outer(.leadingTop)
    public static let outerLeadingCenter:  Self = .outer(.leadingCenter)
    public static let outerLeadingBottom:  Self = .outer(.leadingBottom)
    public static let outerLeadingUnder:   Self = .outer(.leadingUnder)
    // Aliases.
    public static let outerLeading:        Self = .outerLeadingCenter


    // Outer Trailing Major
    public static let outerTrailingAbove:  Self = .outer(.trailingAbove)
    public static let outerTrailingTop:    Self = .outer(.trailingTop)
    public static let outerTrailingCenter: Self = .outer(.trailingCenter)
    public static let outerTrailingBottom: Self = .outer(.trailingBottom)
    public static let outerTrailingUnder:  Self = .outer(.trailingUnder)
    // Aliases.
    public static let outerTrailing:       Self = .outerTrailingCenter


    // MARK: All Cases


    /// All floating alignments.
    public static let allCases: [FloatingAlignment] = {
        let innerCases: [FloatingAlignment] = FloatingAlignment.InnerAlignment.allCases.map {
            .inner($0)
        }
        let outerCases: [FloatingAlignment] = FloatingAlignment.OuterAlignment.allCases.map {
            .outer($0)
        }
        return innerCases + outerCases
    }()


    /// Returns all floating alignment with the given horizontal component.
    public static func allCases(
        withHorizontal horizontalAlignment: HorizontalAlignment
    ) -> [FloatingAlignment] {
        allCases.filter { floatingAlignment in
            floatingAlignment.horizontal == horizontalAlignment
        }
    }


    /// Returns all floating alignment with the given major component.
    public static func allCases(
        outerWithMajor majorKey: OuterAlignment.Key
    ) -> [FloatingAlignment] {
        allCases.filter { floatingAlignment in
            switch floatingAlignment {
            case .inner: return false
            case .outer(let outerAlignment):
                return outerAlignment.key == majorKey
            }
        }
    }

}


// MARK: - InnerAlignment


extension FloatingAlignment {

    /// Alignment positions for inner floating content.
    ///
    /// An inner alignments is composed by a ``FloatingAlignment/HorizontalAlignment`` and a ``FloatingAlignment/VerticalAlignment``.
    /// These are intended to work as equivalents of the SwiftUI alignments with the same names, for
    /// example aligning content to ``InnerAlignment/topLeading`` would be equivalent to aligning
    /// the same content using `SwiftUICore/Alignment/topLeading`.
    ///
    /// @Image(
    ///     source: "floating-alignment-inner-alignments",
    ///     alt: "Illustration of all inner floating alignments."
    /// ) {
    ///     All inner alignments.
    /// }
    public nonisolated
    struct InnerAlignment: CaseIterable, SelfIdentifiable, Sendable {

        /// Horizontal component of the alignment.
        let horizontal: HorizontalAlignment
        /// Vertical component of the alignment.
        let vertical: VerticalAlignment


        var displayNameComponents: [String] { [horizontal.displayName, vertical.displayName] }

        var displayName: String { displayNameComponents.joined(separator: " ") }

        var abbreviatedName: String {
            displayNameComponents.map(formatting: .firstCharacter).joined()
        }

        var swiftAlignment: SwiftUI.Alignment {
            .init(horizontal: horizontal.swiftAlignment, vertical: vertical.swiftAlignment)
        }


        // MARK: Shorthand properties
        public static let topLeading:     Self = .init(horizontal: .leading,  vertical: .top)
        public static let topCenter:      Self = .init(horizontal: .center,   vertical: .top)
        public static let topTrailing:    Self = .init(horizontal: .trailing, vertical: .top)
        public static let top:            Self = .topCenter

        public static let leadingCenter:  Self = .init(horizontal: .leading,  vertical: .center)
        public static let center:         Self = .init(horizontal: .center,   vertical: .center)
        public static let trailingCenter: Self = .init(horizontal: .trailing, vertical: .center)
        public static let leading:        Self = .leadingCenter
        public static let trailing:       Self = .trailingCenter

        public static let bottomLeading:  Self = .init(horizontal: .leading,  vertical: .bottom)
        public static let bottomCenter:   Self = .init(horizontal: .center,   vertical: .bottom)
        public static let bottomTrailing: Self = .init(horizontal: .trailing, vertical: .bottom)
        public static let bottom:         Self = .bottomCenter


        /// All inner alignments.
        public static let allCases: [FloatingAlignment.InnerAlignment] = [
            .topLeading, .topCenter, .topTrailing,
            .leadingCenter, .center, .trailingCenter,
            .bottomLeading, .bottomCenter, .bottomTrailing
        ]

    }

}


// MARK: - HorizontalAlignment


extension FloatingAlignment {

    /// Horizontal alignment component of a floating alignment.
    public nonisolated
    enum HorizontalAlignment: String, CaseIterable, SelfIdentifiable, Sendable {
        case leading, center, trailing

        var displayName: String { rawValue }
        var abbreviatedName: String { displayName.formatted(.firstCharacter) }

        var swiftAlignment: SwiftUI.HorizontalAlignment {
            switch self {
            case .leading:  .leading
            case .center:   .center
            case .trailing: .trailing
            }
        }

        var textAlignment: SwiftUI.TextAlignment {
            switch self {
            case .leading:  .leading
            case .center:   .center
            case .trailing: .trailing
            }
        }


        /// The opposite alignment.
        var opposite: Self {
            switch self {
            case .leading:  .trailing
            case .center:   .center
            case .trailing: .leading
            }
        }

    }

}


// MARK: - VerticalAlignment


extension FloatingAlignment {

    /// Vertical alignment component of a floating alignment.
    public nonisolated
    enum VerticalAlignment: String, CaseIterable, SelfIdentifiable, Sendable {
        case top, center, bottom

        var displayName: String { rawValue }
        var abbreviatedName: String { displayName.formatted(.firstCharacter) }

        var swiftAlignment: SwiftUI.VerticalAlignment {
            switch self {
            case .top:    .top
            case .center: .center
            case .bottom: .bottom
            }
        }
    }

}


// MARK: - OuterAlignment


extension FloatingAlignment {

    /// Alignment positions for outer floating content.
    ///
    /// An outer alignments is composed by a major component and a minor component. ``OuterAlignment``
    /// defines the major components and identifies the edge to which the content will be primarily
    /// aligned: top, leading, bottom, or trailing. The minor component determines the secondary
    /// direction along that edge where the content will be aligned.
    ///
    /// Outer alignments with a vertical major (top and bottom) support three minor components: leading,
    /// center, and trailing.
    ///
    /// ![Outer floating alignments with a vertical major.](floating-alignment-outer-with-vertical-major)
    ///
    /// Outer alignments with a horizontal major (leading and trailing) support five minor components:
    /// above, top, center, bottom, and under.
    ///
    /// ![Outer floating alignments with a horizontal major.](floating-alignment-outer-with-horizontal-major)
    public nonisolated
    enum OuterAlignment: CaseIterable, SelfIdentifiable, Sendable {

        /// Outer alignment with a top major component.
        case top(HorizontalAlignment)
        /// Outer alignment with a leading major component.
        case leading(OuterVerticalAlignment)
        /// Outer alignment with a bottom major component.
        case bottom(HorizontalAlignment)
        /// Outer alignment with a trailing major component.
        case trailing(OuterVerticalAlignment)

        /// Identifier of the major component of an outer alignment.
        ///
        /// Enumeration with equivalent cases to each ``FloatingAlignment/OuterAlignment`` case
        /// without its associated value.
        ///
        /// Allows identification of each outer alignment major component (its case) irregardless
        /// of its minor component (its associated value).
        public enum Key: String, CaseIterable, SelfIdentifiable, Sendable {
            case top, leading, bottom, trailing

            var swiftHorizontal: SwiftUI.HorizontalAlignment {
                switch self {
                case .top, .bottom: .center
                case .leading:  .leading
                case .trailing: .trailing
                }
            }

            var swiftVertical: SwiftUI.VerticalAlignment {
                switch self {
                case .leading, .trailing: .center
                case .top:    .top
                case .bottom: .bottom
                }
            }
        }

        var key: Key {
            switch self {
            case .top:      .top
            case .leading:  .leading
            case .bottom:   .bottom
            case .trailing: .trailing
            }
        }

        var oppositeKey: Key {
            switch self.key {
            case .top:      .bottom
            case .leading:  .trailing
            case .bottom:   .top
            case .trailing: .leading
            }
        }

        var displayNameComponents: [String] {
            let majorName = key.rawValue
            let minorName = switch self {
            case .top(let horizontalAlignment), .bottom(let horizontalAlignment):
                horizontalAlignment.displayName
            case .leading(let outerVerticalAlignment), .trailing(let outerVerticalAlignment):
                outerVerticalAlignment.displayName
            }

            return [majorName, minorName]
        }

        var displayName: String { displayNameComponents.joined(separator: .space)

        }

        var abbreviatedName: String {
            displayNameComponents.map(formatting: .firstCharacter).joined()
        }


        var contentAlignment: SwiftUI.Alignment {
            switch self {
            case .top(let horizontalAlignment), .bottom(let horizontalAlignment):
                // Same horizontal, opposite vertical, to hug the top/bottom.
                return .init(horizontal: horizontalAlignment.swiftAlignment, vertical: oppositeKey.swiftVertical)
            case .leading(let outerVerticalAlignment), .trailing(let outerVerticalAlignment):
                let vertical: SwiftUI.VerticalAlignment = switch outerVerticalAlignment {
                // Same vertical.
                case .center: .center
                case .top:    .top
                case .bottom: .bottom
                // Opposite verticals, to hug top/bottom from the outside.
                case .above: .bottom
                case .under: .top
                }
                // Opposite horizontal, to hug leading/trailing from the outside.
                return .init(horizontal: oppositeKey.swiftHorizontal, vertical: vertical)
            }
        }


        var textAlignment: SwiftUI.TextAlignment {
            switch self {
            case .top(let horizontalAlignment), .bottom(let horizontalAlignment):
                horizontalAlignment.textAlignment
            case .leading: .trailing
            case .trailing: .leading
            }
        }


        /// Horizontal alignment component.
        var horizontal: HorizontalAlignment {
            switch self {
            case .top(let horizontalAlignment), .bottom(let horizontalAlignment):
                horizontalAlignment
            case .leading:  .leading
            case .trailing: .trailing
            }
        }


        // MARK: Shorthand properties
        public static let topLeading:     Self = .top(.leading)
        public static let topCenter:      Self = .top(.center)
        public static let topTrailing:    Self = .top(.trailing)
        public static let top:            Self = .topCenter

        public static let bottomLeading:  Self = .bottom(.leading)
        public static let bottomCenter:   Self = .bottom(.center)
        public static let bottomTrailing: Self = .bottom(.trailing)
        public static let bottom:         Self = .bottomCenter

        public static let leadingAbove:   Self = .leading(.above)
        public static let leadingTop:     Self = .leading(.top)
        public static let leadingCenter:  Self = .leading(.center)
        public static let leadingBottom:  Self = .leading(.bottom)
        public static let leadingUnder:   Self = .leading(.under)
        public static let leading:        Self = .leadingCenter

        public static let trailingAbove:  Self = .trailing(.above)
        public static let trailingTop:    Self = .trailing(.top)
        public static let trailingCenter: Self = .trailing(.center)
        public static let trailingBottom: Self = .trailing(.bottom)
        public static let trailingUnder:  Self = .trailing(.under)
        public static let trailing:       Self = .trailingCenter


        public static let allCases: [Self] = [
            topLeading, topCenter, topTrailing,
            bottomTrailing, bottomCenter, bottomLeading,
            leadingAbove, leadingTop, leadingCenter, leadingBottom, leadingUnder,
            trailingAbove, trailingTop, trailingCenter, trailingBottom, trailingUnder
        ]

    }

}


// MARK: - OuterVerticalAlignment


extension FloatingAlignment {

    /// Vertical alignment component of an outer floating alignment.
    ///
    /// Vertical alignment component of an outer alignment with a horizontal major component
    /// (leading or trailing).
    ///
    /// Adds `above` and `under` to the usual vertical components.
    public nonisolated
    enum OuterVerticalAlignment: String, CaseIterable, SelfIdentifiable, Sendable {
        case above, top, center, bottom, under

        var displayName: String { rawValue }
        var abbreviatedName: String { displayName.formatted(.firstCharacter) }
    }

}


extension FloatingAlignment {

    /// Container of alignments that can be applied to content aligned using a `FloatingAlignment`.
    ///
    /// Use the contained `content` and `text` alignments to align content to the appropriate edge
    /// that the content will be leaning towards.
    ///
    /// For example, content aligned to ``FloatingAlignment/outerTrailing`` will use alignments
    /// `SwiftUI/HorizontalAlignment/leading` for content,  and `SwiftUI/TextAlignment/leading` for
    /// text, so that the content itself leans towards the trailing edge from the outside.
    public nonisolated
    struct ContentAlignments {
        let content: SwiftUI.Alignment
        let text: SwiftUI.TextAlignment
        init(floatingAlignment: FloatingAlignment) {
            content = floatingAlignment.forContent
            text = floatingAlignment.forText
        }
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeForcedLayout

}


// MARK: - Previews


#Preview("All Alignments", traits: PreviewContent.layout) {
    ForEach(FloatingAlignment.HorizontalAlignment.allCases) { horizontalAlignment in
        DashedDivider()
        Text(horizontalAlignment.displayName, format: .capitalized)
        Rectangle()
            .fill(.teal.gradient.secondary)
        .frame(width: 100, height: 100)
        .overlay {
            let alignments = FloatingAlignment.allCases(withHorizontal: horizontalAlignment)
            ForEach(alignments) { alignment in
                FloatingAlignedContainer(alignment: alignment, spacing: 2) { alignments in
                    Text.caption(verbatim:alignment.hyphenatedName).fixedSize()
                    .padding(2)
                    .floatingCaption("", .colorStyle(.mint))
                }
            }
        }
        .padding(.vertical, 20)
    }

    DashedDivider()
}
