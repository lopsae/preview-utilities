//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct HeaderFooterPreviewModifier: PreviewModifier {

    let options: HeaderFooterPreviewOptions


    init(options: HeaderFooterPreviewOptions = []) {
        self.options = options
    }


    func body(content: Content, context _: ()) -> some View {
        HeaderFooterPreview(options: options) {
            content
        }
    }

}


extension PreviewTrait where T == Preview.ViewTraits {

    public static var headerFooter: PreviewTrait {
        .modifier(HeaderFooterPreviewModifier())
    }


    public static func headerFooter(_ options: HeaderFooterPreviewOptions...) -> PreviewTrait {
        return .modifier(HeaderFooterPreviewModifier(options: options.union()))
    }


    public static var fixedHeader: PreviewTrait {
        .modifier(HeaderFooterPreviewModifier(options: .fixedHeader))
    }


    public static func fixedHeader(_ options: HeaderFooterPreviewOptions...) -> PreviewTrait {
        return .modifier(HeaderFooterPreviewModifier(
            options: options.union().union(.fixedHeader)
        ))
    }

}


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
