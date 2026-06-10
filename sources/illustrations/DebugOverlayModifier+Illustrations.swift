//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension DebugOverlayModifier {

    /// Container of specialized illustrations for `DebugOverlayModifier`.
    enum Illustrations {}

}


extension DebugOverlayModifier.Illustrations {

    /// Card illustration for `DebugOverlayModifier`.
    static var card: DocumentationIllustration {
        DocumentationIllustration(size: [320, 180]) {
            Capsule()
            .fill(.gray.secondary)
            .frame(width: 320, height: 180)
            .debugOverlay(.bordersWidth(10))
            .safeAreaInset(edge: .top, spacing: .zero) {
                ClearRectangle().frame(squareOf: 80)
            }
            .safeAreaInset(edge: .leading, spacing: .zero) {
                ClearRectangle().frame(squareOf: 60)
            }
            .offset(x: 320/5, y: 180/3)
        } // DocumentationIllustration
    }


    /// Illustration of the components of the `debugOverlay`.
    static var components: DocumentationIllustration {
        DocumentationIllustration(height: 200) {
            Capsule()
            .fill(.gray.secondary)
            .frame(width: 140, height: 60)
            .debugOverlay(.caption("A `Capsule` shape"), .size, .alignment(.outerTop))
            .overlay {
                // Outer stroke.
                FloatingAlignedContainer(alignment: .outerTrailing, spacing: 10) { contentAlignments in
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
                        .frame(size: [20, 60])

                        Text.caption("Outer stroke\nin blue")
                            .multilineTextAlignment(contentAlignments.text)
                    }
                }

                // Safe area inset.
                FloatingAlignedContainer(alignment: .outerTrailingUnder, spacing: 5) { contentAlignments in
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
                        .frame(size: [20, 30])

                        Text.caption("Safe area inset\nin green")
                            .multilineTextAlignment(contentAlignments.text)
                    }
                    .offset(x: 5)
                }

                // Inner stroke.
                FloatingAlignedContainer(alignment: .innerTrailing, spacing: 10) { contentAlignments in
                    HStack(spacing: 4) {
                        Text.caption("Inner stroke\nin red")
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
                        .frame(size: [20, 40])
                    }
                }

                // Origin point.
                FloatingAlignedContainer(alignment: .outerLeadingTop, spacing: 10) { contentAlignments in
                    HStack(spacing: 4) {
                        Text.caption("Origin point")
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
                        .frame(size: [20, 11])
                    }
                    .offset(y: -17)
                }

                // Debug caption.
                FloatingAlignedContainer(alignment: .outerLeadingAbove, spacing: 10) { contentAlignments in
                    HStack(spacing: 4) {
                        Text.caption("Debug caption")
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
                        .frame(size: [20, 24])
                    }
                }
            } // overlay
            .safeAreaInset(edge: .bottom, spacing: .zero) {
                ClearRectangle().frame(squareOf: 35)
            }
            .offset(y: 20)
        } // DocumentationIllustration
    }
}


// MARK: Previews


#Preview("card", traits: .docsIllustration) {
    DebugOverlayModifier.Illustrations.card
}


#Preview("components", traits: .docsIllustration) {
    DebugOverlayModifier.Illustrations.components
}
