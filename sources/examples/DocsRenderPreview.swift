//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


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


extension PreviewTrait where T == Preview.ViewTraits {

    /// Applies the preview traits needed for documentation illustration.
    public static var docsIllustration: PreviewTrait {
        .sizeThatFitsLayout
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


/// Wraps content for rendering of a documentation illustration.
public struct DocumentationIllustration: View {

    static var defaultWidth: CGFloat { 400 }

    let size: CGSize
    let content: AnyView

    init<Content: View>(height: CGFloat, @ViewBuilder content: @escaping () -> Content) {
        self.size = [Self.defaultWidth, height]
        self.content = AnyView(content())
    }

    @_documentation(visibility: internal)
    public var body: some View {
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
