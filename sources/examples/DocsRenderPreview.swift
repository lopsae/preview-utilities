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
        VStack {
            content
        }
        .frame(size: size)
        .border(.tertiary, width: 1)
    }

}


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
