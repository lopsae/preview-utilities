//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Wraps the preview content in a `VStack` with zero spacing.
struct ZeroSpacingPreviewModifier: PreviewModifier {

    func body(content: Content, context _: ()) -> some View {
        VStack(spacing: .zero) {
            content
        }
    }

}


/// Wraps the preview content in a `VStack` with zero spacing and surrounded by two additional views
/// to visualize the order of preview trait application.
private struct DebugZeroSpacingPreviewModifier: PreviewModifier {

    func body(content: Content, context _: ()) -> some View {
        VStack(spacing: .zero) {
            CaptionRectangle("ZeroSpacing Above", color: .gray, width: 150, height: 40)
            content
            CaptionRectangle("ZeroSpacing Below", color: .gray, width: 150, height: 40)
        }
    }

}


extension PreviewTrait where T == Preview.ViewTraits {

    /// Wraps the preview content in a `VStack` with zero spacing.
    public static var zeroSpacing: PreviewTrait {
        .modifier(ZeroSpacingPreviewModifier())
    }


    /// Wraps the preview content in a `VStack` with zero spacing and surrounded by two additional
    /// views to visualize the order of preview trait application.
    fileprivate static var debugZeroSpacing: PreviewTrait {
        .modifier(DebugZeroSpacingPreviewModifier())
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


#Preview("Default", traits: .zeroSpacing) {
    PreviewContent.Items()
}


#Preview("DebugDefault", traits: .debugZeroSpacing) {
    PreviewContent.Items()
}


#Preview("No Trait") {
    Text("By default, a preview wraps its content in a VStack with default spacing.")
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    PreviewContent.Items()
}


/// Traits get applied in order. In this case `content` is wrapped first in `.zeroSpacing` and
/// then in `.headerFooter`:
/// ```
/// HeaderFooter {
///     ZeroSpacing {
///         content
///     }
/// }
/// ```
///
/// This order is preferred. The opposite order will produce a preview with the spacing defined
/// by `.headerFooter`.
#Preview("ZeroSpacing + HeaderFooter", traits: .debugZeroSpacing, .headerFooter(.showDividers)) {
    PreviewContent.Items()
}


/// Traits get applied in order. In this case `content` is wrapped first in `.headerFooter` and
/// then in `.zeroSpacing`:
/// ```
/// ZeroSpacing {
///     HeaderFooter {
///         content
///     }
/// }
/// ```
///
/// In this case the spacing between items is defined by `.headerFooter`.
#Preview("HeaderFooter + ZeroSpacing", traits: .headerFooter(.showDividers), .debugZeroSpacing) {
    PreviewContent.Items()
}
