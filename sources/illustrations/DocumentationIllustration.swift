//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Wraps content for rendering an illustration generated from a SwiftUI view body.
public struct DocumentationIllustration: View {

    static var defaultWidth: CGFloat { 400 }

    let size: CGSize
    let drawsBorder: Bool
    let content: AnyView

    public init<Content: View>(
        height: CGFloat,
        drawsBorder: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.size = [Self.defaultWidth, height]
        self.drawsBorder = drawsBorder
        self.content = AnyView(content())
    }


    public init<Content: View>(
        size: CGSize,
        drawsBorder: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.size = size
        self.drawsBorder = drawsBorder
        self.content = AnyView(content())
    }

    @_documentation(visibility: internal)
    public var body: some View {
        VStack {
            content
        }
        .frame(size: size)
        .background(.background, in: .rect)
        .border(.tertiary, width: drawsBorder ? 1 : .zero)
    }

}


// MARK: - Preview Trait


extension PreviewTrait where T == Preview.ViewTraits {

    /// Applies the preview traits needed for documentation illustration.
    public static var docsIllustration: PreviewTrait {
        .sizeThatFitsLayout
    }

}


// MARK: - Previews


#Preview("Default", traits: .docsIllustration) {
    DocumentationIllustration(height: 160) {
        Text("Documentation Illustration")
    }
    .padding()
}


#Preview("Size", traits: .docsIllustration) {
    DocumentationIllustration(size: [160, 160]) {
        Text("Custom Size\nIllustration")
    }
    .padding()
}


#Preview("NoBorder", traits: .docsIllustration) {
    DocumentationIllustration(height: 160, drawsBorder : false) {
        Text("No Border Illustration")
    }
    .padding()
}
