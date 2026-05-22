//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


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
    Capsule()
    .fill(.quaternary)
    .frame(width: 160, height: 80)
    .debugOverlay(.caption("A `Capsule` shape"), .size, .alignment(.outerTop))
    .overlay {
        // Outer Stroke.
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
                .frame(size: [20, 80])

                Text.caption("Outer stroke\nin blue")
                .multilineTextAlignment(contentAlignments.text)
            }
        }

        // Inner Stroke.
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
                .frame(size: [20, 60])
            }
        }

        // Origin.
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

        // Debug Caption.
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
                .frame(size: [19.5, 26])
            }
            .offset(x: 16)
        }
    }
    .offset(y: 16)
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
