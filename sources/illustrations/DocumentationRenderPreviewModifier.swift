//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// TODO: Move all documentation illustrations to use DocumentationIllustration instead of the
// utilities in this file. Once migrated, this file can be deleted.


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

    @available(*, deprecated, message: "Use instead `DocumentationIllustration` and `docsIllustration` trait")
    public static func docsRender(size: CGSize) -> PreviewTrait {
        .init(
            .modifier(DocumentationRenderPreviewModifier(size: size)),
            .fixedLayout(size: size)
        )
    }


    @available(*, deprecated, message: "Use instead `DocumentationIllustration` and `docsIllustration` trait")
    public static func docsRender(height: Double) -> PreviewTrait {
        .init(
            .modifier(DocumentationRenderPreviewModifier(height: height)),
            .fixedLayout(size: [DocumentationRenderPreviewModifier.defaultWidth, height])
        )
    }

}


// MARK: - DocumentationRenderModifier


@available(*, deprecated, message: "Use instead `DocumentationIllustration`")
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

    @available(*, deprecated, message: "Use instead `DocumentationIllustration`")
    public func docRender(size: CGSize) -> some View {
        return modifier(DocumentationRenderModifier(size: size))
    }

}


// MARK: - Previews


#Preview("Default", traits: .docsIllustration) {
    DocumentationIllustration(height: 160) {
        CaptionRectangle(
            "Documentation\nIllustration\nPrevew",
            color: .orange, size: [200, 80]
        )
    }
}


#Preview("Padded", traits: .docsIllustration) {
    DocumentationIllustration(height: 160) {
        CaptionRectangle(
            "Documentation\nIllustration\nPrevew",
            color: .orange, size: [200, 80]
        )
    }
    .floatingCaption("Padded to show the illustration border", .alignment(.outerBottomTrailing))
    .padding(30)
}
