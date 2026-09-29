//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension DebugGeometryModifier {

    /// Container of specialized illustrations for ``DebugGeometryModifier``.
    enum Illustrations {}

}


extension DebugGeometryModifier.Illustrations {

    /// Card illustration for <doc:debug-overlay-api>.
    static var card: DocumentationIllustration {
        DocumentationIllustration(sizing: .card.half, alignment: .topLeading, drawsBorder: false) {
            Capsule()
            .fill(.gray.gradient.secondary)
            .frame(width: 320, height: 180)
            .debugGeometry(.bordersWidth(10))
            .safeAreaInset(edge: .top, spacing: .zero) {
                ClearRectangle().frame(squareOf: 40)
            }
            .safeAreaInset(edge: .leading, spacing: .zero) {
                ClearRectangle().frame(squareOf: 50)
            }
            .offset(x: 50, y: 40)
        } // DocumentationIllustration
    }


    /// Illustration of the components of the `debugGeometry`.
    static var components: DocumentationIllustration {
        DocumentationIllustration(height: 200) {
            Capsule()
            .fill(.gray.secondary)
            .frame(width: 140, height: 60)
            .debugGeometry(.caption("A `Capsule` shape"), .size, .alignment(.outerTop))
            .caliperLabel(
                "Outer stroke\nin blue", to: .leading,
                span: 60, stem: 20,
                alignment: .outerTrailing,
                spacingSize: .square(of: 8)
            )
            .caliperLabel(
                "Safe area inset\nin green", to: .leading,
                span: 30, stem: 20,
                alignment: .outerTrailingUnder,
                spacingSize: [8, 4]
            )
            .caliperLabel(
                "Inner stroke\nin red", to: .trailing,
                span: 60 - 16, stem: 20,
                alignment: .innerTrailing,
                spacingSize: .square(of: 8)
            )
            .caliperLabel(
                "Origin point", to: .trailing,
                span: 9, stem: 20,
                alignment: .outerLeadingTop,
                spacingSize: [8, -4]
            )
            .caliperLabel(
                "Debug caption", to: .trailing,
                span: 25, stem: 20,
                alignment: .outerLeadingAbove,
                spacingSize: [8, 8]
            )
            .safeAreaInset(edge: .bottom, spacing: .zero) {
                ClearRectangle().frame(squareOf: 34)
            }
            .expandingFrame(alignment: .bottom)
            .offset(y: -34)
        } // DocumentationIllustration
    }
}


// MARK: Previews


#Preview("card", traits: .docsIllustration) {
    DebugGeometryModifier.Illustrations.card
}


#Preview("components", traits: .docsIllustration) {
    DebugGeometryModifier.Illustrations.components
}
