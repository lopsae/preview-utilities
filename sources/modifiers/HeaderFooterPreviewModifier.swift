//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Wraps the preview content in a ``HeaderFooterContainerView``, displaying the preview with a
/// header and footer that pushes the content away from the preview safe-areas.
struct HeaderFooterPreviewModifier: PreviewModifier {

    let options: HeaderFooterPreviewOptions


    init(options: HeaderFooterPreviewOptions = []) {
        self.options = options
    }


    func body(content: Content, context _: ()) -> some View {
        HeaderFooterContainerView(options: options) {
            content
        }
    }

}


extension PreviewTrait where T == Preview.ViewTraits {

    /// Wraps the preview content in a ``HeaderFooterContainerView`` with flexible height for both
    /// header and footer.
    public static var headerFooter: PreviewTrait {
        .modifier(HeaderFooterPreviewModifier())
    }


    /// Wraps the preview content in a ``HeaderFooterContainerView`` with the given options.
    public static func headerFooter(_ options: HeaderFooterPreviewOptions...) -> PreviewTrait {
        return .modifier(HeaderFooterPreviewModifier(options: options.union()))
    }


    /// Wraps the preview content in a ``HeaderFooterContainerView`` with fixed height header and
    /// a flexible height footer.
    public static var fixedHeader: PreviewTrait {
        .modifier(HeaderFooterPreviewModifier(options: .fixedHeader))
    }


    /// Wraps the preview content in a ``HeaderFooterContainerView`` with fixed height header and
    /// the given options.
    public static func fixedHeader(_ options: HeaderFooterPreviewOptions...) -> PreviewTrait {
        return .modifier(HeaderFooterPreviewModifier(
            options: options.union().union(.fixedHeader)
        ))
    }

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter) {
    StarShape(points: 4, concaveVertexRatio: 0.5)
        .fill(.yellow)
}


#Preview("Fixed header", traits: .fixedHeader) {
    StarShape(points: 4, concaveVertexRatio: 0.5)
        .fill(.yellow)
}


#Preview("Multiple traits", traits: .headerFooter(.fixed, .showDividers)) {
    StarShape(points: 4, concaveVertexRatio: 0.5)
        .fill(.yellow)
}
