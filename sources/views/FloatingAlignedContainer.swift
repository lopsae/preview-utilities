//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct FloatingAlignedContainer<Content: View>: View {

    let alignment: FloatingAlignment
    // TODO: nil could be unnecessary here, if a view wants default padding they could define it in the content.
    let spacing: CGFloat?
    let content: (FloatingAlignment.ContentAlignments) -> Content


    init(
        alignment: FloatingAlignment = .inner(.center),
        spacing: CGFloat? = .zero,
        @ViewBuilder content: @escaping (FloatingAlignment.ContentAlignments) -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }


    var body: some View {
        GeometryReader { geometry in
            let offset = calculateOffset(geometry: geometry)

            VStack(alignment: alignment.forContent.horizontal) {
                let contentAlignments = FloatingAlignment.ContentAlignments(floatingAlignment: alignment)
                content(contentAlignments)
            }
            .padding(.all, spacing)
            // Centers the view based in the alignment even when the frame is smaller that the view.
            .frame(size: geometry.size, alignment: alignment.forContent)
            .offset(offset)
        } // GeometryReader
    }


    private func calculateOffset(geometry: GeometryProxy) -> CGSize {
        guard let outerAlignment = alignment.outerAlignment else { return .zero }

        let widthOffset: CGFloat = switch outerAlignment {
        case .leading:  -geometry.size.width
        case .trailing: geometry.size.width
        case .top, .bottom: .zero
        }

        let heightOffset: CGFloat = switch outerAlignment {
        case .top:    -geometry.size.height
        case .bottom: geometry.size.height
        case .leading(let outerVerticalAlignment), .trailing(let outerVerticalAlignment):
            switch outerVerticalAlignment {
            case .top, .center, .bottom: .zero
            case .above: -geometry.size.height
            case .under: geometry.size.height
            }
        }

        return .init(width: widthOffset, height: heightOffset)
    }

}


// MARK: - FloatingAlignment


nonisolated
public enum FloatingAlignment: CaseIterable, SelfIdentifiable, Sendable {

    case inner(InnerAlignment)
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


    /// Returns an outer floating alignment with the given horizontal alignment, and vertically
    /// aligned to the center.
    ///
    /// E.g.: `outer(horizontal: .leading)` returns `outerLeadingCenter`.
    ///
    /// For `center` horizontal alignment, defaults to returning `outerTrailingCenter`.
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


    // Outer Top Mayor
    public static let outerTopLeading:     Self = .outer(.topLeading)
    public static let outerTopCenter:      Self = .outer(.topCenter)
    public static let outerTopTrailing:    Self = .outer(.topTrailing)
    // Aliases.
    public static let outerTop:            Self = .outerTopCenter


    // Outer Bottom Mayor
    public static let outerBottomLeading:  Self = .outer(.bottomLeading)
    public static let outerBottomCenter:   Self = .outer(.bottomCenter)
    public static let outerBottomTrailing: Self = .outer(.bottomTrailing)
    // Aliases.
    public static let outerBottom:         Self = .outerBottomCenter


    // Outer Leading Mayor
    public static let outerLeadingAbove:   Self = .outer(.leadingAbove)
    public static let outerLeadingTop:     Self = .outer(.leadingTop)
    public static let outerLeadingCenter:  Self = .outer(.leadingCenter)
    public static let outerLeadingBottom:  Self = .outer(.leadingBottom)
    public static let outerLeadingUnder:   Self = .outer(.leadingUnder)
    // Aliases.
    public static let outerLeading:        Self = .outerLeadingCenter


    // Outer Trailing Mayor
    public static let outerTrailingAbove:  Self = .outer(.trailingAbove)
    public static let outerTrailingTop:    Self = .outer(.trailingTop)
    public static let outerTrailingCenter: Self = .outer(.trailingCenter)
    public static let outerTrailingBottom: Self = .outer(.trailingBottom)
    public static let outerTrailingUnder:  Self = .outer(.trailingUnder)
    // Aliases.
    public static let outerTrailing:       Self = .outerTrailingCenter


    // MARK: All Cases


    /// All floating alignment cases.
    public static let allCases: [FloatingAlignment] = {
        let innerCases: [FloatingAlignment] = FloatingAlignment.InnerAlignment.allCases.map {
            .inner($0)
        }
        let outerCases: [FloatingAlignment] = FloatingAlignment.OuterAlignment.allCases.map {
            .outer($0)
        }
        return innerCases + outerCases
    }()


    /// Returns all floating alignment cases that use the given horizontal component.
    public static func allCases(
        withHorizontal horizontalAlignment: HorizontalAlignment
    ) -> [FloatingAlignment] {
        allCases.filter { floatingAlignment in
            floatingAlignment.horizontal == horizontalAlignment
        }
    }

}


// MARK: - InnerAlignment


extension FloatingAlignment {

    nonisolated
    public struct InnerAlignment: CaseIterable, SelfIdentifiable, Sendable {

        let horizontal: HorizontalAlignment
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


        public static let allCases: [FloatingAlignment.InnerAlignment] = [
            .topLeading, .topCenter, .topTrailing,
            .leadingCenter, .center, .trailingCenter,
            .bottomLeading, .bottomCenter, .bottomTrailing
        ]

    }

}


// MARK: - HorizontalAlignment


extension FloatingAlignment {

    nonisolated
    public enum HorizontalAlignment: String, CaseIterable, SelfIdentifiable, Sendable {
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

    nonisolated
    enum VerticalAlignment: String, CaseIterable, SelfIdentifiable {
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

    nonisolated
    public enum OuterAlignment: CaseIterable, SelfIdentifiable, Sendable {

        case top(HorizontalAlignment)
        case leading(OuterVerticalAlignment)
        case bottom(HorizontalAlignment)
        case trailing(OuterVerticalAlignment)

        enum Key: String, CaseIterable, SelfIdentifiable {
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
            let mayorName = key.rawValue
            let minorName = switch self {
            case .top(let horizontalAlignment), .bottom(let horizontalAlignment):
                horizontalAlignment.displayName
            case .leading(let outerVerticalAlignment), .trailing(let outerVerticalAlignment):
                outerVerticalAlignment.displayName
            }

            return [mayorName, minorName]
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

    nonisolated
    public enum OuterVerticalAlignment: String, CaseIterable, SelfIdentifiable, Sendable {
        case above, top, center, bottom, under

        var displayName: String { rawValue }
        var abbreviatedName: String { displayName.formatted(.firstCharacter) }
    }

}


extension FloatingAlignment {

    /// Container of alignments that can be applied to content that is aligned using a
    /// `FloatingAlignment`.
    ///
    /// Use the contained `content` and `text` alignments to align content to the appropriate edge
    /// that the content will be touching.
    ///
    /// I.e.: For content aligned to ``FloatingAlignment/outerTrailing``, the
    /// ``SwiftUI/HorizontalAlignment/leading`` and ``SwiftUI/TextAlignment/leading`` will be passed
    /// for the content to align itself towards the trailing edge from the outside.
    nonisolated
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

    enum ContentOption: String, SelfIdentifiable, CaseIterable {
        case text, vertical, multiline
    }

}


// MARK: - Previews


#Preview("Default", traits: PreviewContent.layout) {
    Rectangle()
    .fill(.teal.gradient.secondary)
    .frame(squareOf: 100)
    .overlay {
        FloatingAlignedContainer { _ in
            Group {
                Text("Sphinx of black quartz,")
                Text("judge my vow")
            }
            .fixedSize()
        }
    }
}


#Preview("Alignments", traits: .zeroSpacing, .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var isLargeParent: Bool = true
    @Previewable @State var contentOption: PreviewContent.ContentOption = .multiline
    @Previewable @State var spacing: Double = 5

    @Previewable @State var alignmentKey: FloatingAlignment.Key = .outer
    @Previewable @State var innerHorizontalAlignment: FloatingAlignment.HorizontalAlignment = .center
    @Previewable @State var innerVerticalAlignment: FloatingAlignment.VerticalAlignment = .top

    @Previewable @State var outerMayorAlignment: FloatingAlignment.OuterAlignment.Key = .bottom
    @Previewable @State var outerMinorHorizontalAlignment: FloatingAlignment.HorizontalAlignment = .center
    @Previewable @State var outerMinorVerticalAlignment: FloatingAlignment.OuterVerticalAlignment = .center

    let makeAlignment: () -> FloatingAlignment = {
        switch alignmentKey {
        case .inner:
            return .inner(.init(horizontal: innerHorizontalAlignment, vertical: innerVerticalAlignment))
        case .outer:
            let outerAlignment: FloatingAlignment.OuterAlignment = switch outerMayorAlignment {
            case .top:      .top(     outerMinorHorizontalAlignment)
            case .bottom:   .bottom(  outerMinorHorizontalAlignment)
            case .leading:  .leading( outerMinorVerticalAlignment)
            case .trailing: .trailing(outerMinorVerticalAlignment)
            }
            return .outer(outerAlignment)
        }
    }

    let alignment = makeAlignment()

    VStack {
        Picker("Alignment", selection: $alignmentKey, caseFormat: .rawValueCapitalized())
            .pickerStyle(.segmented)

        switch alignmentKey {
        case .inner:
            Picker("Horizontal Alignment", selection: $innerHorizontalAlignment, caseFormat: .rawValueCapitalized())
                .pickerStyle(.segmented)
            Picker("Vertical Alignment", selection: $innerVerticalAlignment, caseFormat: .rawValueCapitalized())
                .pickerStyle(.segmented)

        case .outer:
            Picker("Outer Mayor Alignment", selection: $outerMayorAlignment, caseFormat: .rawValueCapitalized())
                .pickerStyle(.segmented)

            switch outerMayorAlignment {
            case .top, .bottom:
                Picker("Horizontal Minor Alignment", selection: $outerMinorHorizontalAlignment, caseFormat: .rawValueCapitalized())
                    .pickerStyle(.segmented)
            case .leading, .trailing:
                Picker("Vertical Minor Alignment", selection: $outerMinorVerticalAlignment, caseFormat: .rawValueCapitalized())
                    .pickerStyle(.segmented)
            }
        }

        Slider.captioned(
            "Spacing", value: $spacing, in: 0...15,
            currentValueFormat: .fractionLength(2),
            boundsValueFormat: .arithmeticRoundedInteger)

        Toggle("Large Parent", isOn: $isLargeParent)
        Picker("Content", selection: $contentOption, caseFormat: .rawValueCapitalized())
            .pickerStyle(.segmented)
    }
    .padding(.not(.top))

    let floatingContent = FloatingAlignedContainer(alignment: alignment, spacing: spacing) { alignments in
        switch contentOption {
        case .text:
            VStack(alignment: alignments.content.horizontal) {
                Text("Sphinx of black quartz")
                Text("judge my vow")
            }
            .foregroundStyle(.secondary)
            .font(.caption.monospaced())
            .fixedSize()
        case .vertical:
            HStack(alignment: alignments.content.vertical) {
                Rectangle().fill(.red)
                    .frame(width: 20, height: 100)
                Rectangle().fill(.red)
                    .frame(width: 20, height: 50)
                Rectangle().fill(.red)
                    .frame(width: 20, height: 250)
            }
        case .multiline:
            VStack(alignment: alignments.content.horizontal) {
                Text("How happy is\nthe blameless vestal's lot!")
                Text("The world forgetting,\nby the world forgot.")
            }
            .foregroundStyle(.secondary)
            .font(.caption.monospaced())
            .multilineTextAlignment(alignments.text)
            .fixedSize()
        }
    }

    if isLargeParent {
        VisibleSpacer()
        StarShape(points: 4, concaveVertexRatio: 1)
            .fill(.teal.gradient.secondary)
            .background(.teal.gradient.quinary)
            .frame(squareOf: 200)
            .overlay {
                floatingContent
            }
        VisibleSpacer()
    } else {
        VisibleSpacer()
        Text("Preview text")
            .foregroundStyle(.quaternary)
            .background(.teal.gradient.quinary)
            .monospaced()
            .overlay {
                floatingContent
            }
        VisibleSpacer()
    }

}


#Preview("All Alignments", traits: PreviewContent.layout) {
    Rectangle()
        .fill(.teal.gradient.secondary)
    .frame(width: 200, height: 300)
    .overlay {
        ForEach(FloatingAlignment.allCases) { alignment in
            FloatingAlignedContainer(alignment: alignment, spacing: 2) { alignments in
                Text("black\nquartz")
                    .multilineTextAlignment(alignments.text)
                Image(systemName: "target")
                    .foregroundStyle(.tertiary)
                Text(alignment.abbreviatedName)
            }
        }
    }
}


#Preview("Horizontal Alignments", traits: PreviewContent.layout) {
    ForEach(FloatingAlignment.HorizontalAlignment.allCases) { horizontalAlignment in
        DashedDivider()
        Text(horizontalAlignment.displayName.formatted(.capitalized))
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
