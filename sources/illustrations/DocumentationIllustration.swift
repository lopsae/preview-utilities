//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Wraps content for rendering a documentation illustration.
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


// MARK: - Preview Trait


extension PreviewTrait where T == Preview.ViewTraits {

    /// Applies the preview traits needed for documentation illustration.
    public static var docsIllustration: PreviewTrait {
        .sizeThatFitsLayout
    }

}
