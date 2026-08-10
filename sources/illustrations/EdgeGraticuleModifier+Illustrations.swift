//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension EdgeGraticuleModifier {

    /// Container of specialized illustrations for ``EdgeGraticuleModifier``.
    enum Illustrations {}

}


extension EdgeGraticuleModifier.Illustrations {

    /// Card illustration for <doc:edge-graticule-api>.
    static var card: DocumentationIllustration {
        DocumentationIllustration(sizing: .card.half, drawsBorder: false) {
            RoundedRectangle(cornerRadius: 16)
            .fill(.teal.gradient.secondary)
            .frame(size: CardIllustrations.contentSize)
            .edgeGraticule(insetSpacing: 8, insetCount: 2, outsetSpacing: 16)
        } // DocumentationIllustration
    }


    /// Illustration of the components of the `debugOverlay`.
    static var components: DocumentationIllustration {
        DocumentationIllustration(height: 200) {
            RoundedRectangle(cornerRadius: 16)
            .fill(.teal.gradient.secondary)
            .frame(width: 140, height: 100)
            .edgeGraticule(
                insetSpacing: 8, outsetSpacing: 16,
                .inset(.top, spacing: 8*3),
                .inset(.bottom, count: 3)
            )
            .caliperLabel(
                "Outset\nLine Sets", to: .trailing,
                span: 100+16+16, stem: 20,
                alignment: .outerLeading,
                spacingSize: .all(16+8))
            .overlay {
                // Inset Line Sets.
                FloatingAlignedContainer(alignment: .innerTrailing, spacing: 8+8) { contentAlignments in
                    Text.caption("Inset\nLine Sets")
                    .multilineTextAlignment(contentAlignments.text)
                    .caliper(to: .trailing, span: 40, stem: 12)
                }

                // Top Inset Spacing.
                FloatingAlignedContainer(alignment: .outerTrailingTop, horizontalSpacing: 6, verticalSpacing: .zero) { contentAlignments in
                    Text.caption("Top Inset\nwith modified\nspacing")
                    .multilineTextAlignment(contentAlignments.text)
                    .fixedSize()
                    .frame(height: 20)
                    .caliper(to: .leading, span: 8*3, stem: 20)
                }

                // Bottom Inset Count.
                FloatingAlignedContainer(alignment: .outerTrailingBottom, horizontalSpacing: 6, verticalSpacing: .zero) { contentAlignments in
                    Text.caption("Bottom Inset\nwith modified\ncount")
                    .multilineTextAlignment(contentAlignments.text)
                    .fixedSize()
                    .frame(height: 20)
                    .caliper(to: .leading, span: 8*3, stem: 20)
                }
            } // overlay
        } // DocumentationIllustration
    }
}


// FIXME: move to Caliper.

extension View {

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


// MARK: Previews


#Preview("card", traits: .docsIllustration) {
    EdgeGraticuleModifier.Illustrations.card
}


#Preview("components", traits: .docsIllustration) {
    EdgeGraticuleModifier.Illustrations.components
}
