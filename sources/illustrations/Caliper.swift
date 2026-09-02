//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// A annotation mark that spans a length and points toward a describing label.
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
            switch barEdge {
            case .leading:
                path.addPath(rect.leadingSegment.path)
                path.addPath(rect.horizontalBisectorSegment.path)
            case .trailing:
                path.addPath(rect.trailingSegment.path)
                path.addPath(rect.horizontalBisectorSegment.path)
            case .top:
                path.addPath(rect.topSegment.path)
                path.addPath(rect.verticalBisectorSegment.path)
            case .bottom:
                path.addPath(rect.bottomSegment.path)
                path.addPath(rect.verticalBisectorSegment.path)
            }
        }
    }

}


extension CGRect {

    nonisolated
    var topSegment: Segment {
        CGPoint(x: minX, y: minY)
        .segmentToOffset(x: width)
    }

    nonisolated
    var trailingSegment: Segment {
        CGPoint(x: maxX, y: minY)
        .segmentToOffset(y: height)
    }

    nonisolated
    var bottomSegment: Segment {
        CGPoint(x: maxX, y: maxY)
        .segmentToOffset(x: -width)
    }

    nonisolated
    var leadingSegment: Segment {
        CGPoint(x: minX, y: maxY)
        .segmentToOffset(y: -height)
    }

    nonisolated
    var topCenterPoint: CGPoint {
        .init(x: minX, y: minY)
        .offset(x: width/2)
    }

    nonisolated
    var leadingCenterPoint: CGPoint {
        .init(x: minX, y: minY)
        .offset(y: height/2)
    }

    nonisolated
    var horizontalBisectorSegment: Segment {
        leadingCenterPoint
        .segmentToOffset(x: width)
    }

    nonisolated
    var verticalBisectorSegment: Segment {
        topCenterPoint
        .segmentToOffset(y: height)
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
                    .multilineTextAlignment(contentAlignments.text)
                    .frame(length: span, along: edge.axis.orthogonal, alignment: .center)
                    .caliper(to: edge, span: span, stem: stem)
            }
        }
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
        "Top Caliper", to: .top,
        span: 40, stem: 20,
        alignment: .outerBottom,
        spacingSize: .all(4)
    )
    .caliperLabel(
        "Leading\nCaliper", to: .leading,
        span: 40, stem: 20,
        alignment: .outerTrailing,
        spacingSize: .all(4)
    )
    .caliperLabel(
        "Bottom Caliper", to: .bottom,
        span: 40, stem: 20,
        alignment: .outerTop,
        spacingSize: .all(4)
    )
    .caliperLabel(
        "Trailing\nCaliper", to: .trailing,
        span: 40, stem: 20,
        alignment: .outerLeading,
        spacingSize: .all(4)
    )
}
