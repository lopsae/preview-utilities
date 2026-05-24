//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// View that aligns content to a floating alignment.
///
/// This view is the primary implementation to align any content to a ``FloatingAlignment``.
///
/// The container view expands to the size available, and allows the given content to expand up to
/// that size. The content is then aligned to the specified floating alignment.
///
/// When used inside an `overlay` modifier, the content is aligned to the parent view.
struct FloatingAlignedContainer<Content: View>: View {

    let alignment: FloatingAlignment
    // TODO: nil could be unnecessary here, if a view wants default padding they could define it in the content.
    let horizontalSpacing: CGFloat?
    let verticalSpacing: CGFloat?
    let content: (FloatingAlignment.ContentAlignments) -> Content


    init(
        alignment: FloatingAlignment = .inner(.center),
        horizontalSpacing: CGFloat? = .zero,
        verticalSpacing: CGFloat? = .zero,
        @ViewBuilder content: @escaping (FloatingAlignment.ContentAlignments) -> Content
    ) {
        self.alignment = alignment
        self.horizontalSpacing = horizontalSpacing
        self.verticalSpacing = verticalSpacing
        self.content = content
    }


    init(
        alignment: FloatingAlignment = .inner(.center),
        spacing: CGFloat,
        @ViewBuilder content: @escaping (FloatingAlignment.ContentAlignments) -> Content
    ) {
        self.alignment = alignment
        self.horizontalSpacing = spacing
        self.verticalSpacing = spacing
        self.content = content
    }


    var body: some View {
        GeometryReader { geometry in
            let offset = calculateOffset(geometry: geometry)

            VStack(alignment: alignment.forContent.horizontal) {
                let contentAlignments = FloatingAlignment.ContentAlignments(floatingAlignment: alignment)
                content(contentAlignments)
            }
            // This first frame constrains the content to the same size the geometry reader can take.
            .frame(size: geometry.size, alignment: alignment.forContent)
            // Padding is added on top, for spacing from the edge of the content.
            .padding(.horizontal, horizontalSpacing)
            .padding(.vertical, verticalSpacing)
            // Aligns the content based in the floating alignment, larger content floats due to
            // this alignment.
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
    @Previewable @State var horizontalSpacing: Double = 5
    @Previewable @State var verticalSpacing: Double = 5

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

        DashedDivider()

        Toggle("Large Parent", isOn: $isLargeParent)
        Picker("Content", selection: $contentOption, caseFormat: .rawValueCapitalized())
            .pickerStyle(.segmented)

        DashedDivider()

        Slider.captioned(
            "Horizontal Spacing", value: $horizontalSpacing, in: 0...15,
            currentValueFormat: .fractionLength(2),
            boundsValueFormat: .arithmeticRoundedInteger)
        Slider.captioned(
            "Vertical Spacing", value: $verticalSpacing, in: 0...15,
            currentValueFormat: .fractionLength(2),
            boundsValueFormat: .arithmeticRoundedInteger)

    }
    .padding(.not(.top))

    let floatingContent = FloatingAlignedContainer(
        alignment: alignment,
        horizontalSpacing: horizontalSpacing,
        verticalSpacing: verticalSpacing
    ) { alignments in
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
                    .font(.caption)
                    .multilineTextAlignment(alignments.text)
                Image(systemName: "target")
                    .foregroundStyle(.tertiary)
                Text(alignment.abbreviatedName)
            }
        }
    }
}
