//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


nonisolated
private protocol HorizontalReferenceAlignmentID: AlignmentID, Sendable {
    static var referenceAlignment: HorizontalAlignment { get }
    static var relativeAlignment: HorizontalAlignment { get }
}

extension HorizontalReferenceAlignmentID {

    nonisolated
    static func defaultValue(in context: ViewDimensions) -> CGFloat {
        context[horizontal: relativeAlignment]
    }

}


nonisolated
private struct OuterTrailing: HorizontalReferenceAlignmentID {
    static let referenceAlignment: HorizontalAlignment = .trailing
    static let relativeAlignment: HorizontalAlignment = .leading
}


nonisolated
private extension HorizontalAlignment {
    static let outerTrailing = HorizontalAlignment(OuterTrailing.self)
}


/// A horizontal alignment guide that can set its guide in two roles: reference and relative.
///
/// A horizontal reference alignment guide aligns content with two different roles: reference
/// content and relative content. Each role provides its own alignment to use, causing the relative
/// content to be aligned to an given alignment of the reference content.
///
/// For example, to align content next to each other, a reference alignment instance can define
/// its reference content to use its `trailing` edge, and its relative content its `leading` edge.
/// Using this alignment will cause reference content to always sit on the leading side of relative
/// content. This is the behaviour of `outerTrailing`, since relative content aligned with
/// `outerTrailing` is always aligned outside the trailing edge of its reference content.
nonisolated
private struct HorizontalReferenceAlignment: Sendable {
    let alignmentID: HorizontalReferenceAlignmentID.Type

    init(_ alignmentID: HorizontalReferenceAlignmentID.Type) {
        self.alignmentID = alignmentID
    }

    /// The `HorizontalAlignment` instance used by this reference alignment.
    var horizontalAlignment: HorizontalAlignment { .init(alignmentID) }
    var reference: HorizontalAlignment { alignmentID.referenceAlignment }
    var relative: HorizontalAlignment { alignmentID.relativeAlignment }

}


/// Static members available as parameter shorthands.
extension HorizontalReferenceAlignment {
    nonisolated
    static let outerTrailing: Self = .init(OuterTrailing.self)
}



private extension View {

    /// Adjusts the view reference alignment guide to is reference role.
    func alignmentGuide(referenceOf referenceAlignment: HorizontalReferenceAlignment) -> some View {
        self.alignmentGuide(referenceAlignment.horizontalAlignment) { dimension in
            dimension[referenceAlignment.alignmentID.referenceAlignment]
        }
    }
}


private extension View {

    func overlay(
        referenceAlignment: HorizontalReferenceAlignment,
        @ViewBuilder content: () -> some View
    ) -> some View {
        self
        .alignmentGuide(referenceOf: referenceAlignment)
        // FIXME: Convenience function for orthogonalCentered? .centered? .alignmentWithCenter? .orthogonalCenterAlignment?
        .overlay(alignment: referenceAlignment.horizontalAlignment.alignment(withOrthogonal: .center)) {
            content()
        }
    }


    /// This implementation has two issues:
    /// + referenceAlignment defines only the horizontal, it is still unclear how the composite alignment
    /// would be passed into.
    /// + Since there is no other view to use as the reference role, the alignment has to be manually
    /// adjusted so that it aligns to its default position (the relative role) but appears offset
    /// like a reference role view was present.
    func frame(
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        referenceAlignment: HorizontalReferenceAlignment
    ) -> some View {
        let horizontalAlignment = referenceAlignment.horizontalAlignment

        return self
        // First frame for the content to align to relative alignment.
        .frame(width: width, height: height, alignment: horizontalAlignment.alignment(withOrthogonal: .center))
        .border(.green.secondary, width: 2)
//        .debugAlignmentGuide(horizontal: horizontalAlignment, .extendedLength(20))

        // This implementation requires a manual adjustment of horizontalAlignment to relocate it at
        // the trailing edge, since there is no other content which alignment can be updated to the
        // reference role!
        .alignmentGuide(horizontalAlignment) { dimensions in
            let shift = dimensions[referenceAlignment.reference] - dimensions[referenceAlignment.relative]
            return dimensions[horizontalAlignment] - shift
        }
//        .debugAlignmentGuide(horizontal: horizontalAlignment, .extendedLength(10), .lineWidth(4))

        // Second frame aligns again to horizontalAlignment, so that the content with the adjusted
        // guide now appears as having a reference role view.
        .frame(width: width, height: height, alignment: horizontalAlignment.alignment(withOrthogonal: .center))

        .border(.blue.secondary, width: 8)
    }

}



// MARK: - Previews


#Preview("Default") {
    VStack(alignment: .outerTrailing) {
        Text("Reference\nManual")
        .multilineTextAlignment(.trailing)
        .fontWeight(.bold)
        // Manual setup or reference alignment.
        .alignmentGuide(.outerTrailing) { dimension in
            dimension[referenceOf: .outerTrailing]
        }

        Text("Relative One")
        Text("Relative Two")
    }


    DashedDivider()

    VStack(alignment: .outerTrailing) {
        Text("Reference\n`referenceOf`")
        .multilineTextAlignment(.trailing)
        .fontWeight(.bold)
        .alignmentGuide(referenceOf: .outerTrailing)
        // FIXME: Could this be just .referenceAlignment() using Environment values?

        Text("Relative One")
        Text("Relative Two")
    }
}


#Preview("NoReference") {
    VStack(alignment: .outerTrailing) {
        Text("No Reference").fontWeight(.bold)
        Text("1st Relative")
        Text("Second Relative")
    }
}


#Preview("Overlay&Frame") {
    CaptionRectangle("Overlaid Content", color: .blue, size: [120, 40])
    .overlay(referenceAlignment: .outerTrailing) {
        Text("Relative Role")
    }

    DashedDivider()

    Text("Relative Role")
    .frame(width: 120, height: 40, referenceAlignment: .outerTrailing)
    .border(.red.secondary, width: 4)
    Text("Relative Role")
    .frame(referenceAlignment: .outerTrailing)
    .border(.red.secondary, width: 4)
}


private extension ViewDimensions {

    nonisolated
    subscript(horizontal guide: HorizontalAlignment) -> CGFloat {
        self[guide]
    }

    nonisolated
    subscript(vertical guide: VerticalAlignment) -> CGFloat {
        self[guide]
    }

    nonisolated
    subscript(referenceOf guide: HorizontalReferenceAlignment) -> CGFloat {
        self[horizontal: guide.reference]
    }

}
