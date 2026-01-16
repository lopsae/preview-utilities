//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Wraps the preview content in a ``HeaderFooterContainer``, displaying the preview with a
/// header and footer that pushes the content away from the preview safe-areas.
struct HeaderFooterPreviewModifier: PreviewModifier {

    let options: HeaderFooterPreviewOptions

    /// Edge padding configuration for the current platform. The preview of iOS always have a
    /// significant top and bottom safearea, so header and footer labels can stick closer to the
    /// view edge. For macOS, the padding is enabled since previews have only a top safe area.
    static let platformEnableEdgePadding: Bool = {
        #if os(macOS)
        true
        #else
        false
        #endif
    }()


    init(options: HeaderFooterPreviewOptions = []) {
        self.options = options
    }


    func body(content: Content, context _: ()) -> some View {
        HeaderFooterContainer(enableEdgePadding: Self.platformEnableEdgePadding, options: options) {
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

    @ViewBuilder
    static func fixedHeightControlAndContent(_ heightBinding: Binding<Double>) -> some View {
        Slider.captioned(
            "Content Height",
            value: heightBinding,
            in: 0...1000,
            valueFormat: .arithmeticRoundedInteger)

        StarShape(points: 4, concaveVertexRatio: 0.5)
            .fill(.yellow)
            .frame(height: heightBinding.wrappedValue)
            .floatingCaption(
                "Content", .colorStyle(.yellow),
                .alignment(.topTrailing), .height)
    }

}


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var fixedHeight: Double = 200
    PreviewContent.fixedHeightControlAndContent($fixedHeight)
}


#Preview("Fixed header", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var fixedHeight: Double = 200
    PreviewContent.fixedHeightControlAndContent($fixedHeight)
}


#Preview("Multiple traits", traits: .headerFooter(.fixed, .showDividers), PreviewContent.layout) {
    @Previewable @State var fixedHeight: Double = 200
    PreviewContent.fixedHeightControlAndContent($fixedHeight)
}
