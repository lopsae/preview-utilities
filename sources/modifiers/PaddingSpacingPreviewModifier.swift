//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Wraps the preview content in a `VStack` with regular spacing equal to the default padding.
struct PaddingSpacingPreviewModifier: PreviewModifier {

    func body(content: Content, context _: ()) -> some View {
        VStack(spacing: Defaults.padding) {
            content
        }
    }

}


/// Wraps the preview content in a `VStack` with padding spacing and surrounded by two additional
/// views to visualize the order of preview trait application.
private struct DebugPaddingSpacingPreviewModifier: PreviewModifier {

    func body(content: Content, context _: ()) -> some View {
        VStack(spacing: Defaults.padding) {
            CaptionRectangle("DefaultSpacing Above", color: .gray, width: 150, height: 40)
            content
            CaptionRectangle("DefaultSpacing Below", color: .gray, width: 150, height: 40)
        }
    }

}


extension PreviewTrait where T == Preview.ViewTraits {

    /// Wraps the preview content in a `VStack` with spacing equal to the default padding.
    public static var paddingSpacing: PreviewTrait {
        .modifier(PaddingSpacingPreviewModifier())
    }


    /// Wraps the preview content in a `VStack` with spacing equal to the default spacing and
    /// surrounded by two additional views to visualize the order of preview trait application.
    fileprivate static var debugPaddingSpacing: PreviewTrait {
        .modifier(DebugPaddingSpacingPreviewModifier())
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    struct Items: View {
        var body: some View {
            CaptionRectangle("First", color: .teal, size: .square(of: 100))
            CaptionRectangle("Second", color: .orange, size: .square(of: 100))
            DashedDivider()
            CaptionRectangle("Third", color: .yellow, size: .square(of: 100))
        }
    }

}


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing) {
    PreviewContent.Items()
}


#Preview("DebugDefault", traits: .debugPaddingSpacing) {
    PreviewContent.Items()
}


#Preview("No Trait") {
    Text("By default, a preview wraps its content in a VStack with default spacing.")
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    PreviewContent.Items()
}


/// Traits get applied in order. In this case `content` is wrapped first in `.paddingSpacing` and
/// then in `.headerFooter`:
/// ```
/// HeaderFooter {
///     PaddingSpacing {
///         content
///     }
/// }
/// ```
///
/// This order is preferred. The opposite order will produce a preview with the spacing defined
/// by `.headerFooter`.
#Preview("ZeroSpacing + PaddingSpacing", traits: .debugPaddingSpacing, .headerFooter(.showDividers)) {
    PreviewContent.Items()
}


/// Traits get applied in order. In this case `content` is wrapped first in `.headerFooter` and
/// then in `.paddingSpacing`:
/// ```
/// PaddingSpacing {
///     HeaderFooter {
///         content
///     }
/// }
/// ```
///
/// In this case the spacing between items is defined by `.headerFooter`.
#Preview("HeaderFooter + PaddingSpacing", traits: .headerFooter(.showDividers), .debugPaddingSpacing) {
    PreviewContent.Items()
}
