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
                spacingSize: .all(16+8)
            )
            .caliperLabel(
                "Inset\nLine Sets", to: .trailing,
                span: 40, stem: 12,
                alignment: .innerTrailing,
                spacingSize: .all(8+8)
            )
            .caliperLabel(
                "Top Inset\nwith modified\nspacing", to: .leading,
                span: 8*3, stem: 20,
                alignment: .outerTrailingTop,
                spacingSize: [6, .zero]
            )
            .caliperLabel(
                "Bottom Inset\nwith modified\ncount", to: .leading,
                span: 8*3, stem: 20,
                alignment: .outerTrailingBottom,
                spacingSize: [6, .zero]
            )
        } // DocumentationIllustration
    }
}


// MARK: Previews


#Preview("card", traits: .docsIllustration) {
    EdgeGraticuleModifier.Illustrations.card
}


#Preview("components", traits: .docsIllustration) {
    EdgeGraticuleModifier.Illustrations.components
}
