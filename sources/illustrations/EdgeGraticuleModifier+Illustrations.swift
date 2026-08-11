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


    /// Illustration of the inset components of the edge graticule.
    static var insetComponent: DocumentationIllustration {
        DocumentationIllustration(sizing: .regular) {
            RoundedRectangle(cornerRadius: 16)
            .fill(.teal.gradient.secondary)
            .frame(width: 200, height: 100)
            .edgeGraticule(insetSpacing: 8, insetCount: 2)
            .caliperLabel(
                "Inset\nLine Sets", to: .leading,
                span: 100 - 8*4 - 8*2, stem: 12,
                alignment: .innerLeading,
                spacingSize: .all(8*2 + 8)
            )
        } // DocumentationIllustration
    }


    /// Illustration of the outset components of the edge graticule.
    static var outsetComponent: DocumentationIllustration {
        DocumentationIllustration(sizing: .regular) {
            RoundedRectangle(cornerRadius: 16)
            .fill(.teal.gradient.secondary)
            .frame(width: 200 - 8*4, height: 100 - 8*4)
            .edgeGraticule(outsetSpacing: 8, outsetCount: 2)
            .caliperLabel(
                "Outset\nLine Sets", to: .trailing,
                span: 100, stem: 20,
                alignment: .outerLeading,
                spacingSize: .all(16+8)
            )
        } // DocumentationIllustration
    }


    /// Illustration of the per edge modification of the edge graticule.
    static var perEdgeTraits: DocumentationIllustration {
        DocumentationIllustration(height: 160) {
            RoundedRectangle(cornerRadius: 16)
            .fill(.teal.gradient.secondary)
            .frame(width: 100, height: 100)
            .edgeGraticule(
                spacing: 8,
                .outset(.leading, spacing: 8*3),
                .inset(.bottom, count: 3)
            )
            .caliperLabel(
                "Leading Outset\nwith modified\nspacing", to: .trailing,
                span: 100 + 8*2, stem: 20,
                alignment: .outerLeading,
                spacingSize: [8*3 + 8, .zero]
            )
            .caliperLabel(
                "Bottom Inset\nwith modified\ncount", to: .leading,
                span: 8*3, stem: 20,
                alignment: .outerTrailingBottom,
                spacingSize: [4, .zero]
            )
        } // DocumentationIllustration
    }
}


// MARK: Previews


#Preview("card", traits: .docsIllustration) {
    EdgeGraticuleModifier.Illustrations.card
}


#Preview("insetComponents", traits: .docsIllustration) {
    EdgeGraticuleModifier.Illustrations.insetComponent
}


#Preview("outsetComponents", traits: .docsIllustration) {
    EdgeGraticuleModifier.Illustrations.outsetComponent
}


#Preview("perEdgeTraits", traits: .docsIllustration) {
    EdgeGraticuleModifier.Illustrations.perEdgeTraits
}
