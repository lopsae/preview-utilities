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
            .overlay {
                // Outset Line Sets.
                FloatingAlignedContainer(alignment: .outerLeading, spacing: 16+8) { contentAlignments in
                    HStack(spacing: 4) {
                        Text.caption("Outset\nLine Sets")
                        .multilineTextAlignment(contentAlignments.text)

                        GeometryReader { geometry in
                            Path { path in
                                path.move(to: [geometry.size.width, .zero])
                                path.addLine(to: [geometry.size.width, geometry.size.height])
                                path.move(to: [.zero, geometry.size.height/2])
                                path.addLine(to: [geometry.size.width, geometry.size.height/2])
                            }
                            .stroke(.primary, lineWidth: 1)
                        }
                        .frame(size: [20, 100+16+16])


                    }
                }

                // Inset Line Sets.
                FloatingAlignedContainer(alignment: .innerTrailing, spacing: 8+8) { contentAlignments in
                    HStack(spacing: 4) {
                        Text.caption("Inset\nLine Sets")
                            .multilineTextAlignment(contentAlignments.text)

                        GeometryReader { geometry in
                            Path { path in
                                path.move(to: [geometry.size.width, .zero])
                                path.addLine(to: [geometry.size.width, geometry.size.height])
                                path.move(to: [.zero, geometry.size.height/2])
                                path.addLine(to: [geometry.size.width, geometry.size.height/2])
                            }
                            .stroke(.primary, lineWidth: 1)
                        }
                        .frame(size: [12, 40])
                    }
                }

                // Top Inset Spacing.
                FloatingAlignedContainer(alignment: .outerTrailingTop, horizontalSpacing: 6, verticalSpacing: .zero) { contentAlignments in
                    HStack(spacing: 4) {
                        GeometryReader { geometry in
                            Path { path in
                                path.move(to: .zero)
                                path.addLine(to: [.zero, geometry.size.height])
                                path.move(to: [.zero, geometry.size.height/2])
                                path.addLine(to: [geometry.size.width, geometry.size.height/2])
                            }
                            .stroke(.primary, lineWidth: 1)
                        }
                        .frame(size: [20, 8*3])

                        Text.caption("Top Inset\nwith modified\nspacing")
                        .multilineTextAlignment(contentAlignments.text)
                        .fixedSize()
                        .frame(height: 20)
                    }
                }

                // Bottom Inset Count.
                FloatingAlignedContainer(alignment: .outerTrailingBottom, horizontalSpacing: 6, verticalSpacing: .zero) { contentAlignments in
                    HStack(spacing: 4) {
                        GeometryReader { geometry in
                            Path { path in
                                path.move(to: .zero)
                                path.addLine(to: [.zero, geometry.size.height])
                                path.move(to: [.zero, geometry.size.height/2])
                                path.addLine(to: [geometry.size.width, geometry.size.height/2])
                            }
                            .stroke(.primary, lineWidth: 1)
                        }
                        .frame(size: [20, 8*3])

                        Text.caption("Bottom Inset\nwith modified\ncount")
                        .multilineTextAlignment(contentAlignments.text)
                        .fixedSize()
                        .frame(height: 20)
                    }
                }
            } // overlay
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
