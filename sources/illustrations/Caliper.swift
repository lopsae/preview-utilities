//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// An annotation mark that spans a length and points toward a describing label.
///
/// A caliper draws a bar along one edge of its frame and a stem from the middle of the bar to the
/// opposite edge. The stem points away from the bar, toward the label that describes the spanned
/// region.
struct Caliper: Shape {

    /// The edge along which the spanning bar is drawn.
    ///
    /// The stem extends from the middle of the bar toward the opposite edge, where the describing
    /// label is expected to sit.
    var barEdge: Edge

    nonisolated func path(in rect: CGRect) -> Path {
        Path { path in
            rect.segment(at: barEdge).add(to: &path)
            rect.bisectorSegment(of: barEdge.axis).add(to: &path)
        }
    }

}


extension View {

    /// Pairs `self`, used as a label, with a `Caliper` pointing back toward it.
    ///
    /// The caliper is placed on the side of `self` indicated by `barEdge`, so that its stem points
    /// from the bar back toward the label. The returned view is either a `VStack` or an `HStack`
    /// containing both self and the caliper.
    ///
    /// - Parameters:
    ///   - barEdge: The edge along which the caliper's bar is drawn, and the side of `self` on which
    ///     the caliper is placed.
    ///   - span: The length of the bar, along `barEdge`.
    ///   - stem: The length of the stem, extending from the bar towards the label.
    ///   - spacing: The spacing between the label and the caliper.
    @ViewBuilder func caliper(
        to barEdge: Edge,
        span: CGFloat,
        stem: CGFloat,
        spacing: CGFloat = 4,
    ) -> some View {
        // The bar runs along `barEdge`, so its length is the frame dimension parallel to that edge,
        // while the stem runs across the frame's other dimension.
        let size: CGSize = switch barEdge.axis {
        case .horizontal: [stem, span]
        case .vertical:   [span, stem]
        }

        let mark = Caliper(barEdge: barEdge)
            .stroke(.primary)
            .frame(size: size)

        // FUTURE: can this be laid-out with a generic Layout and the direction?
        switch barEdge {
        case .leading:
            HStack(spacing: spacing) { mark; self }
        case .trailing:
            HStack(spacing: spacing) { self; mark }
        case .top:
            VStack(spacing: spacing) { mark; self }
        case .bottom:
            VStack(spacing: spacing) { self; mark }
        }
    }


    /// Overlays on the owner view the given label and caliper.
    ///
    /// The caliper direction and alignment are provided separately to allow for all combinations.
    func caliperLabel(
        _ key: LocalizedStringKey,
        to edge: Edge,
        span: CGFloat,
        stem: CGFloat,
        alignment: FloatingAlignment,
        spacingSize: CGSize
    ) -> some View {
        self.overlay {
            FloatingAlignedContainer(
                alignment: alignment,
                horizontalSpacing: spacingSize.width,
                verticalSpacing: spacingSize.height
            ) { contentAlignments in
                Text.caption(key)
                .fixedSize()
                .frame(length: span, along: edge.axis.orthogonal, alignment: .center)
                .caliper(to: edge, span: span, stem: stem)
            }
        }
    }


    /// Overlays on the owner view the given label and caliper from an edge.
    ///
    /// Span and stem length are provided as fixed values.
    @ContentBuilder
    func caliperLabel(
        _ key: LocalizedStringKey,
        from edge: Edge,
        span: CGFloat = 12,
        stem: CGFloat = 16,
        spacing: CGFloat = 4
    ) -> some View {
        let alignment: FloatingAlignment = switch edge {
        case .top:      .outerTop
        case .leading:  .outerLeading
        case .bottom:   .outerBottom
        case .trailing: .outerTrailing
        }

        // FUTURE: caliper label span could take the owner view length, with size modifications
        // similar to the traits used in debugAlignmentGuides.

        self.caliperLabel(
            key,
            to: edge.opposite,
            span: span,
            stem: stem,
            alignment: alignment,
            spacingSize: .square(of: spacing)
        )
    }

}



// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    Text("Top Caliper")
    .caliper(to: .top, span: 40, stem: 20)

    DashedDivider()

    Text("Leading Caliper")
    .caliper(to: .leading, span: 40, stem: 20)

    DashedDivider()

    Text("Trailing Caliper")
    .caliper(to: .trailing, span: 40, stem: 20)

    DashedDivider()

    Text("Bottom Caliper")
    .caliper(to: .bottom, span: 40, stem: 20)
}


#Preview("CaliperLabel", traits: .headerFooter, PreviewContent.layout) {
    RoundedRectangle(cornerRadius: 8)
    .fill(.gray.gradient.tertiary)
    .frame(squareOf: 100)
    .caliperLabel(
        "Top\nCaliper", to: .top,
        span: 40, stem: 20,
        alignment: .outerBottom,
        spacingSize: .square(of: 4)
    )
    .caliperLabel(
        "Leading\nCaliper", to: .leading,
        span: 40, stem: 20,
        alignment: .outerTrailing,
        spacingSize: .square(of: 4)
    )
    .caliperLabel(
        "Bottom\nCaliper", to: .bottom,
        span: 40, stem: 20,
        alignment: .outerTop,
        spacingSize: .square(of: 4)
    )
    .caliperLabel(
        "Trailing\nCaliper", to: .trailing,
        span: 40, stem: 20,
        alignment: .outerLeading,
        spacingSize: .square(of: 4)
    )
    .expandingWidthFrame(height: 220)

    DashedDivider()

    RoundedRectangle(cornerRadius: 8)
    .fill(.gray.gradient.tertiary)
    .frame(squareOf: 100)
    .caliperLabel("From\nTop",       from: .top)
    .caliperLabel("From\nLeading",  from: .leading)
    .caliperLabel("From\nBottom",    from: .bottom)
    .caliperLabel("From\nTrailing", from: .trailing)
    .expandingWidthFrame(height: 220)
}
