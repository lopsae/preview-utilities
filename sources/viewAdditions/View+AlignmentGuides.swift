//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


// MARK: - Offsets


extension View {

    /// Offsets a horizontal alignment guide, optionally positioning it from another guide.
    ///
    /// Convenience function for `View.alignmentGuide(_:computeValue:)` that places the
    /// `alignment` guide at an offset position of the `target` guide. When `target` is omitted
    /// the guide is offset from its own default position.
    ///
    /// Guide positions are measured in the view's own coordinates, where positive values move in
    /// the trailing direction. A positive `offset` moves the guide towards the trailing side of the
    /// view, which moves the view itself towards the leading direction with respect to the views
    /// it is aligned with.
    ///
    /// - Parameters:
    ///   - alignment: The horizontal alignment to modify.
    ///   - target: The alignment whose position is used as the base for `alignment`; When omitted
    ///       the default position of `alignment` is used.
    ///   - offset: Offset to apply to the alignment position; Defaults to zero.
    /// - Returns: A view modified with respect to its vertical alignment.
    @inlinable nonisolated
    public func alignmentGuide(
        _ alignment: HorizontalAlignment,
        moveTo target: HorizontalAlignment? = nil,
        offsetBy offset: CGFloat = .zero
    ) -> some View {
        self.alignmentGuide(alignment) { dimensions in
            dimensions[target ?? alignment] + offset
        }
    }


    /// Offsets a vertical alignment guide, optionally positioning it from another guide.
    ///
    /// Convenience function for `View.alignmentGuide(_:computeValue:)` that places the
    /// `alignment` guide at an offset position of the `target` guide. When `target` is omitted
    /// the guide is offset from its own default position.
    ///
    /// Guide positions are measured in the view's own coordinates, where positive values move in
    /// the bottom direction.A positive `offset` moves the guide towards the bottom of the view,
    /// which moves the view itself upwards with respect to the views it is aligned with.
    ///
    /// - Parameters:
    ///   - alignment: The vertical alignment to modify.
    ///   - target: The alignment whose position is used as the base for `alignment`; When omitted
    ///       the default position of `alignment` is used.
    ///   - offset: Offset to apply to the alignment position; Defaults to zero.
    /// - Returns: A view modified with respect to its vertical alignment.
    @inlinable nonisolated
    public func alignmentGuide(
        _ alignment: VerticalAlignment,
        moveTo target: VerticalAlignment? = nil,
        offsetBy offset: CGFloat = .zero
    ) -> some View {
        self.alignmentGuide(alignment) { dimensions in
            dimensions[target ?? alignment] + offset
        }
    }

}


// MARK: - InsettableAlignments


/// Alignment guide that can be inset.
///
/// Defines the inset direction of the wrapped `baseAlignment`.
///
/// Used by `View/alignmentGuide(_:moveTo:insetBy:)` and `View/alignmentGuide(_:moveTo:outsetBy:)`
/// functions to inset or outset an alignment guide.
nonisolated
public struct InsettableAlignment<AlignmentType: Sendable> {

    let baseAlignment: AlignmentType
    let insetDirection: InsetDirection

    enum InsetDirection {
        case positive, negative

        var multiplier: CGFloat {
            switch self {
            case .positive: +1
            case .negative: -1
            }
        }

        var inverse: Self {
            switch self {
            case .positive: .negative
            case .negative: .positive
            }
        }
    }

}


// MARK: - Horizontal Insettable


extension InsettableAlignment where AlignmentType == HorizontalAlignment {

    /// Insettable alignment guide for the leading edge of a view.
    public static let leading: Self = .init(baseAlignment: .leading, insetDirection: .negative)

    /// Insettable alignment guide for the trailing edge of a view.
    public static let trailing: Self = .init(baseAlignment: .trailing, insetDirection: .positive)

}


// MARK: - Vertical Insettable


extension InsettableAlignment where AlignmentType == VerticalAlignment {

    /// Insettable alignment guide for the top edge of a view.
    public static let top: Self = .init(baseAlignment: .top, insetDirection: .negative)

    /// Insettable alignment guide for the bottom edge of a view.
    public static let bottom: Self = .init(baseAlignment: .bottom, insetDirection: .positive)

}


// MARK: - Inset/Offset


extension View {


    nonisolated
    public func alignmentGuide(
        _ alignment: InsettableAlignment<HorizontalAlignment>,
        moveTo target: HorizontalAlignment? = nil,
        insetBy inset: CGFloat
    ) -> some View {
        let signedInset = inset * alignment.insetDirection.multiplier
        return self.alignmentGuide(alignment.baseAlignment, moveTo: target, offsetBy: signedInset)
    }

    nonisolated
    public func alignmentGuide(
        _ alignment: InsettableAlignment<HorizontalAlignment>,
        moveTo target: HorizontalAlignment? = nil,
        outsetBy outset: CGFloat
    ) -> some View {
        let signedOutset = outset * alignment.insetDirection.inverse.multiplier
        return self.alignmentGuide(alignment.baseAlignment, moveTo: target, offsetBy: signedOutset)
    }

    nonisolated
    public func alignmentGuide(
        _ alignment: InsettableAlignment<VerticalAlignment>,
        moveTo target: VerticalAlignment? = nil,
        insetBy inset: CGFloat
    ) -> some View {
        let signedInset = inset * alignment.insetDirection.multiplier
        return self.alignmentGuide(alignment.baseAlignment, moveTo: target, offsetBy: signedInset)
    }

    nonisolated
    public func alignmentGuide(
        _ alignment: InsettableAlignment<VerticalAlignment>,
        moveTo target: VerticalAlignment? = nil,
        outsetBy outset: CGFloat
    ) -> some View {
        let signedOutset = outset * alignment.insetDirection.inverse.multiplier
        return self.alignmentGuide(alignment.baseAlignment, moveTo: target, offsetBy: signedOutset)
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}



// MARK: - Previews


#Preview("Horizontal Inset/Outset", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var padding: CGFloat = 16

    Slider.captioned(
        "Distance",
        value: $padding,
        in: -20...20,
        valueFormat: .arithmeticRoundedInteger
    )
    .padding(.bottom)

    VStack(alignment: .leading) {
        CaptionRectangle("Fixed Content", color: .gray, size: [100, 50])
        .debugAlignmentGuide(horizontal: .leading, .fixedLength(150), .anchor(.top))

        let guideMarker: DebugHorizontalAlignmentGuideModifier.ConcreteTrait  = [
            .extendedLength(10), .style(.mint)
        ]

        Text("Leading Offset")
            .debugAlignmentGuide(horizontal: .leading, guideMarker)
            .alignmentGuide(.leading, offsetBy: padding)

        Text("Leading Inset")
            .debugAlignmentGuide(horizontal: .leading, guideMarker)
            .alignmentGuide(.leading, insetBy: padding)

        Text("Leading Outset")
            .debugAlignmentGuide(horizontal: .leading, guideMarker)
            .alignmentGuide(.leading, outsetBy: padding)

        Text("Trailing Inset")
            .debugAlignmentGuide(horizontal: .trailing, guideMarker)
            .alignmentGuide(.leading, moveTo: .trailing, insetBy: padding)
        Text("Trailing Outset")
            .debugAlignmentGuide(horizontal: .trailing, guideMarker)
            .alignmentGuide(.leading, moveTo: .trailing, outsetBy: padding)
    }
    .floatingCaption("Leading Aligned", .colorStyle(.mint), .alignment(.outerTopTrailing))

    DashedDivider()
        .frame(height: 40)

    VStack(alignment: .trailing) {
        CaptionRectangle("Fixed Content", color: .gray, size: [100, 50])
        .debugAlignmentGuide(horizontal: .trailing, .fixedLength(150), .anchor(.top))

        let guideMarker: DebugHorizontalAlignmentGuideModifier.ConcreteTrait  = [
            .extendedLength(10), .style(.mint)
        ]

        Text("Trailing Offset")
            .debugAlignmentGuide(horizontal: .trailing, guideMarker)
            .alignmentGuide(.trailing, offsetBy: padding)

        Text("Trailing Inset")
            .debugAlignmentGuide(horizontal: .trailing, guideMarker)
            .alignmentGuide(.trailing, insetBy: padding)
        Text("Trailing Outset")
            .debugAlignmentGuide(horizontal: .trailing, guideMarker)
            .alignmentGuide(.trailing, outsetBy: padding)

        Text("Leading Inset")
            .debugAlignmentGuide(horizontal: .leading, guideMarker)
            .alignmentGuide(.trailing, moveTo: .leading, insetBy: padding)
        Text("Leading Outset")
            .debugAlignmentGuide(horizontal: .leading, guideMarker)
            .alignmentGuide(.trailing, moveTo: .leading, outsetBy: padding)
    }
    .floatingCaption("Trailing Aligned", .colorStyle(.mint), .alignment(.outerTopTrailing))
}


#Preview("Vertical Inset/Outset", traits: PreviewContent.layout) {
    HStack(alignment: .top){
        Rectangle()
        .fill(.gray)
        .frame(width: 20, height: 50)
        .floatingCaption("Offset", .alignment(.outerBottomLeading), .zeroPadding)
        // Negative value subtracts to the top alignment pushing it farther from the view,
        // view appears pushed inwardly, thus insetting the view.
        .alignmentGuide(.top, offsetBy: -40)
        .debugAlignmentGuide(vertical: .top)

        Rectangle()
        .fill(.gray)
        .frame(width: 20, height: 50)
        .floatingCaption("Inset", .alignment(.outerBottomLeading), .zeroPadding)
        .alignmentGuide(.top, insetBy: 20)
        .debugAlignmentGuide(vertical: .top)

        Rectangle()
        .fill(.gray)
        .frame(width: 20, height: 50)
        .floatingCaption("Inset to Center", .alignment(.outerBottomLeading), .zeroPadding)
        .debugAlignmentGuide(vertical: .center, .style(.indigo.secondary))
        .alignmentGuide(.top, moveTo: .center, insetBy: 10)
        .debugAlignmentGuide(vertical: .top)

        CaptionRectangle("Fixed Content", color: .gray, size: [150, 20])
        .debugAlignmentGuide(vertical: .top)

        Rectangle()
        .fill(.gray)
        .frame(width: 20, height: 50)
        .floatingCaption("Outset", .alignment(.outerBottomTrailing))
        .alignmentGuide(.top, outsetBy: 20)
        .debugAlignmentGuide(vertical: .top)
    }
    .floatingCaption("Top Aligned HStack", .alignment(.outerTopTrailing), .colorStyle(.green))
    .padding()

    HStack(alignment: .bottom){
        Rectangle()
        .fill(.gray)
        .frame(width: 20, height: 50)
        .floatingCaption("Offset", .alignment(.outerTopLeading), .zeroPadding)
        // Positive value adds to the bottom alignment pushing it farther from the view,
        // view appears pushed inwardly, thus insetting the view.
        .alignmentGuide(.bottom, offsetBy: 40)
        .debugAlignmentGuide(vertical: .bottom)

        Rectangle()
        .fill(.gray)
        .frame(width: 20, height: 50)
        .floatingCaption("Inset", .alignment(.outerTopLeading), .zeroPadding)
        .alignmentGuide(.bottom, insetBy: 20)
        .debugAlignmentGuide(vertical: .bottom)

        Rectangle()
        .fill(.gray)
        .frame(width: 20, height: 50)
        .floatingCaption("Inset to Center", .alignment(.outerTopLeading), .zeroPadding)
        .debugAlignmentGuide(vertical: .center, .style(.indigo.secondary))
        .alignmentGuide(.bottom, moveTo: .center, insetBy: 10)
        .debugAlignmentGuide(vertical: .bottom)

        CaptionRectangle("Fixed Content", color: .gray, size: [150, 20])
        .debugAlignmentGuide(vertical: .bottom)

        Rectangle()
        .fill(.gray)
        .frame(width: 20, height: 50)
        .floatingCaption("Outset", .alignment(.outerTopTrailing))
        .alignmentGuide(.bottom, outsetBy: 20)
        .debugAlignmentGuide(vertical: .bottom)
    }
    .floatingCaption("Bottom Aligned HStack", .alignment(.outerTopTrailing), .colorStyle(.green))
    .padding()

    ZStack(alignment: .bottom) {
        CaptionRectangle("Fixed\nContent", color: .gray, size: [100, 100])
    } // ZStack
    .floatingCaption("ZStack", .alignment(.outerTop), .colorStyle(.purple))
    .alignmentGuide(.bottom, outsetBy: 20)
    .debugAlignmentGuide(vertical: .bottom, .lineWidth(8))
    .frame(squareOf: 150, alignment: .bottom)
    .floatingCaption("Bottom Aligned Frame", .alignment(.outerTop), .colorStyle(.teal))
}
