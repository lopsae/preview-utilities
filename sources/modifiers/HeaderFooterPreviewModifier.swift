//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Wraps the preview content in a ``HeaderFooterContainer``, displaying the preview with a
/// header and footer that pushes the content away from the preview safe-areas.
struct HeaderFooterPreviewModifier: PreviewModifier {

    let options: HeaderFooterPreviewOptions


    init(options: HeaderFooterPreviewOptions = []) {
        self.options = options
    }


    func body(content: Content, context _: ()) -> some View {
        HeaderFooterContainer(options: options) {
            content
        }
    }

}


extension PreviewTrait where T == Preview.ViewTraits {

    /// Wraps the preview content in a ``HeaderFooterContainer`` with flexible height for both
    /// header and footer.
    public static var headerFooter: PreviewTrait {
        .modifier(HeaderFooterPreviewModifier())
    }


    /// Wraps the preview content in a ``HeaderFooterContainer`` with the given options.
    public static func headerFooter(_ options: HeaderFooterPreviewOptions...) -> PreviewTrait {
        return .modifier(HeaderFooterPreviewModifier(options: options.union()))
    }


    /// Wraps the preview content in a ``HeaderFooterContainer`` with fixed height header and
    /// a flexible height footer.
    public static var fixedHeader: PreviewTrait {
        .modifier(HeaderFooterPreviewModifier(options: .fixedHeader))
    }


    /// Wraps the preview content in a ``HeaderFooterContainer`` with fixed height header and
    /// the given options.
    public static func fixedHeader(_ options: HeaderFooterPreviewOptions...) -> PreviewTrait {
        return .modifier(HeaderFooterPreviewModifier(
            options: options.union().union(.fixedHeader)
        ))
    }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    StarShape(points: 4, concaveVertexRatio: 0.5)
        .fill(.yellow)
}


// FIXME: in ios when fixed height content pushes the footer out of the view boundaries, triggers an infinite update to currentSafeAreaInset. Issue does not happen in header.
#Preview("Content Height", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var contentHeight: Double = 200

    Slider(
        "Content Height",
        value: $contentHeight,
        in: 0...800,
        valueFormat: .arithmeticRoundedInteger)
    .padding([.horizontal, .bottom])

    Divider()

    Rectangle()
        .fill(.teal.secondary)
        .frame(width: 200, height: contentHeight)
        .debugOverlay(.hairline, .size)
}


#Preview("Fixed header", traits: .fixedHeader, PreviewContent.layout) {
    StarShape(points: 4, concaveVertexRatio: 0.5)
        .fill(.yellow)
}


#Preview("Multiple traits", traits: .headerFooter(.fixed, .showDividers), PreviewContent.layout) {
    StarShape(points: 4, concaveVertexRatio: 0.5)
        .fill(.yellow)
}
