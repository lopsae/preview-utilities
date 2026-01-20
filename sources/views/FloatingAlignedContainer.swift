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
enum FloatingAlignment: CaseIterable, SelfIdentifiable {

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


    var abbreviatedName: String {
        let firstLetter = key.rawValue.formatted(.firstCharacter)
        let abbreviation = switch self {
        case .inner(let innerAlignment): innerAlignment.abbreviatedName
        case .outer(let outerAlignment): outerAlignment.abbreviatedName
        }
        return firstLetter + abbreviation
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


    // MARK: Shorthand properties


    // Inner Top
    static let innerTopLeading:     Self = .inner(.topLeading)
    static let innerTopCenter:      Self = .inner(.topCenter)
    static let innerTopTrailing:    Self = .inner(.topTrailing)
    // Aliases.
    static let innerTop:            Self = .innerTopCenter
    static let topLeading:          Self = .innerTopLeading
    static let top:                 Self = .innerTopCenter
    static let topTrailing:         Self = .innerTopTrailing

    // Inner Center
    static let innerLeadingCenter:  Self = .inner(.leadingCenter)
    static let innerCenter:         Self = .inner(.center)
    static let innerTrailingCenter: Self = .inner(.trailingCenter)
    // Aliases.
    static let innerLeading:        Self = .innerLeadingCenter
    static let innerTrailing:       Self = .innerTrailingCenter
    static let leading:             Self = .innerLeadingCenter
    static let center:              Self = .innerCenter
    static let trailing:            Self = .innerTrailingCenter


    // Inner Bottom
    static let innerBottomLeading:  Self = .inner(.bottomLeading)
    static let innerBottomCenter:   Self = .inner(.bottomCenter)
    static let innerBottomTrailing: Self = .inner(.bottomTrailing)
    // Aliases.
    static let innerBottom:         Self = .innerBottomCenter
    static let bottomLeading:       Self = .innerBottomLeading
    static let bottom:              Self = .innerBottomCenter
    static let bottomTrailing:      Self = .innerBottomTrailing


    // Outer Top Mayor
    static let outerTopLeading:     Self = .outer(.topLeading)
    static let outerTopCenter:      Self = .outer(.topCenter)
    static let outerTopTrailing:    Self = .outer(.topTrailing)
    // Aliases.
    static let outerTop:            Self = .outerTopCenter


    // Outer Bottom Mayor
    static let outerBottomLeading:  Self = .outer(.bottomLeading)
    static let outerBottomCenter:   Self = .outer(.bottomCenter)
    static let outerBottomTrailing: Self = .outer(.bottomTrailing)
    // Aliases.
    static let outerBottom:         Self = .outerBottomCenter


    // Outer Leading Mayor
    static let outerLeadingAbove:   Self = .outer(.leadingAbove)
    static let outerLeadingTop:     Self = .outer(.leadingTop)
    static let outerLeadingCenter:  Self = .outer(.leadingCenter)
    static let outerLeadingBottom:  Self = .outer(.leadingBottom)
    static let outerLeadingUnder:   Self = .outer(.leadingUnder)
    // Aliases.
    static let outerLeading:        Self = .outerLeadingCenter


    // Outer Trailing Mayor
    static let outerTrailingAbove:  Self = .outer(.trailingAbove)
    static let outerTrailingTop:    Self = .outer(.trailingTop)
    static let outerTrailingCenter: Self = .outer(.trailingCenter)
    static let outerTrailingBottom: Self = .outer(.trailingBottom)
    static let outerTrailingUnder:  Self = .outer(.trailingUnder)
    // Aliases.
    static let outerTrailing:       Self = .outerTrailingCenter


    static let allCases: [FloatingAlignment] = {
        let innerCases: [FloatingAlignment] = FloatingAlignment.InnerAlignment.allCases.map {
            .inner($0)
        }
        let outerCases: [FloatingAlignment] = FloatingAlignment.OuterAlignment.allCases.map {
            .outer($0)
        }
        return innerCases + outerCases
    }()

}


// MARK: - InnerAlignment


extension FloatingAlignment {

    nonisolated
    struct InnerAlignment: CaseIterable, SelfIdentifiable {

        let horizontal: HorizontalAlignment
        let vertical: VerticalAlignment

        var abbreviatedName: String {
            return horizontal.abbreviatedName + vertical.abbreviatedName
        }

        var swiftAlignment: SwiftUI.Alignment {
            .init(horizontal: horizontal.swiftAlignment, vertical: vertical.swiftAlignment)
        }


        // MARK: Shorthand properties
        static let topLeading:     Self = .init(horizontal: .leading,  vertical: .top)
        static let topCenter:      Self = .init(horizontal: .center,   vertical: .top)
        static let topTrailing:    Self = .init(horizontal: .trailing, vertical: .top)
        static let top:            Self = .topCenter

        static let leadingCenter:  Self = .init(horizontal: .leading,  vertical: .center)
        static let center:         Self = .init(horizontal: .center,   vertical: .center)
        static let trailingCenter: Self = .init(horizontal: .trailing, vertical: .center)
        static let leading:        Self = .leadingCenter
        static let trailing:       Self = .trailingCenter

        static let bottomLeading:  Self = .init(horizontal: .leading,  vertical: .bottom)
        static let bottomCenter:   Self = .init(horizontal: .center,   vertical: .bottom)
        static let bottomTrailing: Self = .init(horizontal: .trailing, vertical: .bottom)
        static let bottom:         Self = .bottomCenter


        static let allCases: [FloatingAlignment.InnerAlignment] = [
            .topLeading, .topCenter, .topTrailing,
            .leadingCenter, .center, .trailingCenter,
            .bottomLeading, .bottomCenter, .bottomTrailing
        ]

    }

}


// MARK: - HorizontalAlignment


extension FloatingAlignment {

    nonisolated
    enum HorizontalAlignment: String, CaseIterable, SelfIdentifiable {
        case leading, center, trailing

        var abbreviatedName: String {
            rawValue.formatted(.firstCharacter)
        }

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

    }

}


// MARK: - VerticalAlignment


extension FloatingAlignment {

    nonisolated
    enum VerticalAlignment: String, CaseIterable, SelfIdentifiable {
        case top, center, bottom

        var abbreviatedName: String {
            rawValue.formatted(.firstCharacter)
        }

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
    enum OuterAlignment: CaseIterable, SelfIdentifiable {

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

        var abbreviatedName: String {
            let mayorLetter = key.rawValue.first?.description ?? .init()
            let minorLetter = switch self {
            case .top(let horizontalAlignment), .bottom(let horizontalAlignment):
                horizontalAlignment.abbreviatedName
            case .leading(let outerVerticalAlignment), .trailing(let outerVerticalAlignment):
                outerVerticalAlignment.abbreviatedName
            }

            return mayorLetter + minorLetter
        }


        var contentAlignment: SwiftUI.Alignment {
            switch self {
            case .top(let horizontalAlignment), .bottom(let horizontalAlignment):
                // Same horizontal, opposie vertical, to hug the top/bottom.
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
                // Oposite horizontal, to hug leading/trailing from the outside.
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


        // MARK: Shorthand properties
        static let topLeading:     Self = .top(.leading)
        static let topCenter:      Self = .top(.center)
        static let topTrailing:    Self = .top(.trailing)
        static let top:            Self = .topCenter

        static let bottomLeading:  Self = .bottom(.leading)
        static let bottomCenter:   Self = .bottom(.center)
        static let bottomTrailing: Self = .bottom(.trailing)
        static let bottom:         Self = .bottomCenter

        static let leadingAbove:   Self = .leading(.above)
        static let leadingTop:     Self = .leading(.top)
        static let leadingCenter:  Self = .leading(.center)
        static let leadingBottom:  Self = .leading(.bottom)
        static let leadingUnder:   Self = .leading(.under)
        static let leading:        Self = .leadingCenter

        static let trailingAbove:  Self = .trailing(.above)
        static let trailingTop:    Self = .trailing(.top)
        static let trailingCenter: Self = .trailing(.center)
        static let trailingBottom: Self = .trailing(.bottom)
        static let trailingUnder:  Self = .trailing(.under)
        static let trailing:       Self = .trailingCenter


        static let allCases: [Self] = [
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
    enum OuterVerticalAlignment: String, CaseIterable, SelfIdentifiable {
        case above, top, center, bottom, under

        var abbreviatedName: String {
            rawValue.formatted(.firstCharacter)
        }
    }

}


extension FloatingAlignment {

    /// Container of alignments that can be applied to content that is aligned using a
    /// `FloatingAlignment`.
    ///
    /// Use the contained `content` and `text` alignments to align content to the appropiate edge
    /// that the content will be touching.
    ///
    /// I.e.: For content aligned to ``FloatingAlignment/outerTrailing``, the ``SwiftUI/HorizontalAlignment/leading``
    /// and ``SwiftUI/TextAlignment/leading`` will be passed for the content to align itself towards
    /// the trailing edge from the outside.
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


#Preview("Alignments", traits: .zeroSpacing, .headerFooter(.fixed), PreviewContent.layout) {
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
