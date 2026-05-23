//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct ExamplesForDebugOverlay {

    /// Illustration of the components of the `debugOverlay`.
    ///
    /// Intended for a height of 200.
    @ViewBuilder static var components: some View {
        Capsule()
        .fill(.quaternary)
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
    }

}


#Preview("debug-overlay-alignments", traits: .docsRender(height: 160)) {
    HStack(spacing: 16) {
        Rectangle()
            .fill(.green.gradient)
            .frame(width: 100, height: 60)
            .debugOverlay(.caption("Inner Top"), .alignment(.innerTop))
        Rectangle()
            .fill(.mint.gradient)
            .frame(width: 100, height: 60)
            .debugOverlay(.caption("Outer Bottom Leading"), .alignment(.outerBottomLeading))
        Rectangle()
            .fill(.teal.gradient)
            .frame(width: 100, height: 60)
            .debugOverlay(.caption("Outer Top Trailing"), .alignment(.outerTopTrailing))
    }
}


#Preview("debug-overlay-components", traits: .docsRender(height: 200)) {
    ExamplesForDebugOverlay.components
}


// MARK: - DocumentationRenderPreviewModifier


struct DocumentationRenderPreviewModifier: PreviewModifier {

    static let defaultWidth: Double = 400

    let size: CGSize

    init(size: CGSize) {
        self.size = size
    }

    init(height: Double) {
        self.size = [Self.defaultWidth, height]
    }

    func body(content: Content, context _: ()) -> some View {
        content.docRender(size: size)
    }

}


// MARK: - PreviewTrait Extension


extension PreviewTrait where T == Preview.ViewTraits {

    public static func docsRender(size: CGSize) -> PreviewTrait {
        .init(
            .modifier(DocumentationRenderPreviewModifier(size: size)),
            .fixedLayout(size: size)
        )
    }


    public static func docsRender(height: Double) -> PreviewTrait {
        .init(
            .modifier(DocumentationRenderPreviewModifier(height: height)),
            .fixedLayout(size: [DocumentationRenderPreviewModifier.defaultWidth, height])
        )
    }

}


// MARK: - DocumentationRenderModifier


struct DocumentationRenderModifier: ViewModifier {

    let size: CGSize

    func body(content: Content) -> some View {
        VStack {
            content
        }
        .frame(size: size)
        .background(.background, in: .rect)
        .border(.tertiary, width: 1)
    }

}


// MARK: - View Extension


extension View {

    public func docRender(size: CGSize) -> some View {
        return modifier(DocumentationRenderModifier(size: size))
    }

}
