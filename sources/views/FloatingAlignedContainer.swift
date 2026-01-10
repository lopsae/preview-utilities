//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct FloatingAlignedContainer<Content: View>: View {

    let alignment: FloatingAlignment
    let spacing: CGFloat?
    let content: Content


    init(
        alignment: FloatingAlignment = .inner(.center),
        spacing: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.alignment = alignment
        self.spacing = spacing
        self.content = content()
    }

    var body: some View {
        GeometryReader { geometry in
            let offset = calculateOffset(geometry: geometry)

            VStack(alignment: alignment.containerHorizontal.swiftAlignment) {
                content
            }
            .font(.caption)
            .monospaced()
            .foregroundStyle(.secondary)
            .padding(.all, spacing)
            // Prevents info view from collapsing in small sizes.
            .fixedSize()
            .border(.red)
            // Centers the view based in the alignment even when the frame is smaller that the view.
            .frame(size: geometry.size, alignment: alignment.frameAlignment)
            .border(.green)
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
            case .above:
                -geometry.size.height
            case .top, .center, .bottom:
                    .zero
            case .below:
                geometry.size.height
            }
        }

        return .init(width: widthOffset, height: heightOffset)
    }

}


// MARK: - AlignedFixedContainerAlignment


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

    static let allCases: [FloatingAlignment] = {
        let innerCases: [FloatingAlignment] = FloatingAlignment.InnerAlignment.allCases.map {
            .inner($0)
        }
        let outerCases: [FloatingAlignment] = FloatingAlignment.OuterAlignment.allCases.map {
            .outer($0)
        }
        return innerCases + outerCases
    }()

    // TODO: might make more sense to have along the views, also for other textAlignment vars.
    // TODO: text alignment may not be used anymore?
    var textAlignment: SwiftUI.TextAlignment {
        switch self {
        case .inner(let innerAlignment):
            return innerAlignment.horizontal.textAlignment
        case .outer(let outerAlignment):
            return outerAlignment.textAlignment
        }
    }

    var outerAlignment: OuterAlignment? {
        switch self {
        case .outer(let outerAlignment): outerAlignment
        case .inner: nil
        }
    }


    // TODO: might make more sense to have along the views.
    // Alignment for the VStack containing the info view.
    // TODO: should be the swift horizontal type
    var containerHorizontal: HorizontalAlignment {
        switch self {
        case .inner(let innerAlignment): innerAlignment.containerHorizontal
        case .outer(let outerAlignment): outerAlignment.containerHorizontal
        }
    }

    // TODO: this also might need to move to the view itself
    var frameAlignment: SwiftUI.Alignment {
        switch self {
        case .inner(let innerAlignment): innerAlignment.frameAlignment
        case .outer(let outerAlignment): outerAlignment.frameAlignment
        }
    }

}


// MARK: - InnerAlignment


extension FloatingAlignment {

    nonisolated
    struct InnerAlignment: CaseIterable, SelfIdentifiable {

        let horizontal: HorizontalAlignment
        let vertical: VerticalAlignment

        var swiftAlignment: SwiftUI.Alignment {
            .init(horizontal: horizontal.swiftAlignment, vertical: vertical.swiftAlignment)
        }

        // TODO: might make more sense to have along the views.
        // Alignment for the VStack containing the info view.
        var containerHorizontal: HorizontalAlignment { horizontal }

        // TODO: this also might need to move to the view itself
        var frameAlignment: SwiftUI.Alignment { swiftAlignment }

        // TODO: add other static properties
        static let topLeading: InnerAlignment = .init(horizontal: .leading, vertical: .top)
        static let topCenter:  InnerAlignment = .init(horizontal: .center, vertical: .top)
        static let topTrailing: InnerAlignment = .init(horizontal: .trailing, vertical: .top)

        static let centerLeading: InnerAlignment = .init(horizontal: .leading, vertical: .center)
        static let center:  InnerAlignment = .init(horizontal: .center, vertical: .center)
        static let centerTrailing: InnerAlignment = .init(horizontal: .trailing, vertical: .center)

        static let bottomLeading: InnerAlignment = .init(horizontal: .leading, vertical: .bottom)
        static let bottomCenter:  InnerAlignment = .init(horizontal: .center, vertical: .bottom)
        static let bottomTrailing: InnerAlignment = .init(horizontal: .trailing, vertical: .bottom)

        static let allCases: [FloatingAlignment.InnerAlignment] = [
            .topLeading, .topCenter, .topTrailing,
            .centerLeading, .center, .centerTrailing,
            .bottomLeading, .bottomCenter, .bottomTrailing
        ]

    }


    nonisolated
    enum HorizontalAlignment: String, CaseIterable, SelfIdentifiable {
        case leading, center, trailing

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


    nonisolated
    enum VerticalAlignment: String, CaseIterable, SelfIdentifiable {
        case top, center, bottom

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

        // TODO: might make more sense to have along the views, also for other textAlignment vars.
        var textAlignment: SwiftUI.TextAlignment {
            switch self {
            case .top(let horizontalAlignment), .bottom(let horizontalAlignment):
                horizontalAlignment.textAlignment
            case .leading: .trailing
            case .trailing: .leading
            }
        }

        // TODO: might make more sense to have along the views.
        // Alignment for the VStack containing the info view.
        var containerHorizontal: HorizontalAlignment {
            switch self {
            case .top(let horizontalAlignment), .bottom(let horizontalAlignment):
                horizontalAlignment
            case .leading: .trailing
            case .trailing: .leading
            }
        }

        // TODO: this also might need to move to the view itself
        var frameAlignment: SwiftUI.Alignment {
            switch self {
            case .top(let horizontalAlignment), .bottom(let horizontalAlignment):
                return .init(horizontal: horizontalAlignment.swiftAlignment, vertical: oppositeKey.swiftVertical)
            case .leading(let outerVerticalAlignment), .trailing(let outerVerticalAlignment):
                let vertical: SwiftUI.VerticalAlignment = switch outerVerticalAlignment {
                case .above: .bottom
                case .top: .top
                case .center: .center
                case .bottom: .bottom
                case .below: .top
                }
                return .init(horizontal: oppositeKey.swiftHorizontal, vertical: vertical)
            }
        }

        static var topLeading:     OuterAlignment { .top(.leading) }
        static var topCenter:      OuterAlignment { .top(.center) }
        static var topTrailing:    OuterAlignment { .top(.trailing) }

        static var bottomLeading:  OuterAlignment { .bottom(.leading) }
        static var bottomCenter:   OuterAlignment { .bottom(.center) }
        static var bottomTrailing: OuterAlignment { .bottom(.trailing) }

        static var leadingAbove:   OuterAlignment { .leading(.above) }
        static var leadingTop:     OuterAlignment { .leading(.top) }
        static var leadingCenter:  OuterAlignment { .leading(.center) }
        static var leadingBottom:  OuterAlignment { .leading(.bottom) }
        static var leadingUnder:   OuterAlignment { .leading(.below) }

        static var trailingAbove:  OuterAlignment { .trailing(.above) }
        static var trailingTop:    OuterAlignment { .trailing(.top) }
        static var trailingCenter: OuterAlignment { .trailing(.center) }
        static var trailingBottom: OuterAlignment { .trailing(.bottom) }
        static var trailingBelow:  OuterAlignment { .trailing(.below) }

        static let allCases: [Self] = [
            topLeading, topCenter, topTrailing,
            bottomTrailing, bottomCenter, bottomLeading,
            leadingAbove, leadingTop, leadingCenter, leadingBottom, leadingUnder,
            trailingAbove, trailingTop, trailingCenter, trailingBottom, trailingBelow
        ]

    }


    enum OuterVerticalAlignment: String, CaseIterable, SelfIdentifiable {
        case above, top, center, bottom, below
    }

}



// MARK: - Previews


#Preview("Default") {
    Rectangle()
        .fill(.teal.tertiary)
    .frame(square: 100)
    .overlay {
        FloatingAlignedContainer {
            Text("Sphinx of black quartz,")
            Text("judge my vow")
        }
    }
}


#Preview("Alignments", traits: .fixedHeader, .iPhoneProSizeLayout) {
    @Previewable @State var isLargeContent: Bool = true
    @Previewable @State var spacing: Double = 5

    @Previewable @State var alignmentKey: FloatingAlignment.Key = .outer
    @Previewable @State var innerHorizontalAlignment: FloatingAlignment.HorizontalAlignment = .center
    @Previewable @State var innerVerticalAlignment: FloatingAlignment.VerticalAlignment = .top

    @Previewable @State var outerMayorAlignment: FloatingAlignment.OuterAlignment.Key = .top
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

        Toggle("Large Content", isOn: $isLargeContent)
    }
    .padding(.not(.top))

    if isLargeContent {
        Rectangle().fill(.gray.tertiary)
            .frame(width: 50)
            .previewCaption("Spacer")
        StarShape(points: 4, concaveVertexRatio: 1)
            .fill(.teal.gradient.secondary)
            .background(.teal.quinary)
            .frame(square: 200)
            .overlay {
                FloatingAlignedContainer(alignment: alignment, spacing: spacing) {
                    Text("Sphinx of black quartz")
                    Text("judge my vow")
                }
            }
        Rectangle().fill(.gray.tertiary)
            .frame(width: 50)
            .previewCaption("Spacer")
    } else {
        Rectangle().fill(.gray.tertiary)
            .frame(width: 50)
            .previewCaption("Spacer")
        Text("Preview text")
            .foregroundStyle(.quaternary)
            .background(.teal.quinary)
            .monospaced()
            .overlay {
                FloatingAlignedContainer(alignment: alignment, spacing: spacing) {
                    Text("Sphinx of black quartz")
                    Text("judge my vow")
                }
            }
        Rectangle().fill(.gray.tertiary)
            .frame(width: 50)
            .previewCaption("Spacer")
    }

}


#Preview("All Alignments") {
    Rectangle()
    .fill(.teal.tertiary)
    .frame(square: 200)
    .overlay {
        ForEach(FloatingAlignment.allCases) { alignment in
            FloatingAlignedContainer(alignment: alignment) {
                // TODO: string formatting will eventually be moved here.
                Text("black")
                Image(systemName: "target")
                Text("quartz")

            }
        }
    }

}
