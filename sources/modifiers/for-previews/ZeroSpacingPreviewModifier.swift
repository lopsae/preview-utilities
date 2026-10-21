//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


// FIXME: replace ZeroSpacingModifier and PaddingSpacingModifier with instances of this.


/// Wraps the preview content in a `VStack` with the given spacing.
struct SpacingPreviewModifier: PreviewModifier {

    let spacing: CGFloat

    func body(content: Content, context _: ()) -> some View {
        VStack(spacing: spacing) {
            content
        }
    }

}


/// Wraps the preview content in a `VStack` with the given spacing and surrounded by two additional
/// views to visualize the order of preview trait application.
private struct DebugSpacingPreviewModifier: PreviewModifier {

    let spacing: CGFloat

    func body(content: Content, context _: ()) -> some View {
        VStack(spacing: spacing) {
            CaptionRectangle("DebugSpacing Above", color: .gray, width: 150, height: 40)
            content
            CaptionRectangle("DebugSpacing Below", color: .gray, width: 150, height: 40)
        }
    }

}


extension PreviewTrait where T == Preview.ViewTraits {

    /// Wraps the preview content in a `VStack` with zero spacing.
    public static var zeroSpacing: PreviewTrait {
        .modifier(SpacingPreviewModifier(spacing: .zero))
    }


    /// Wraps the preview content in a `VStack` with the given spacing.
    public static func spacing(_ spacing: CGFloat) -> Self {
        let spacingModifier = SpacingPreviewModifier(spacing: spacing)
        return .modifier(spacingModifier)
    }


    /// Wraps the preview content in a `VStack` with the given spacing and surrounded by two
    /// additional views to visualize the order of preview trait application.
    fileprivate static func debugSpacing(_ spacing: CGFloat) -> Self {
        let debugSpacingModifier = DebugSpacingPreviewModifier(spacing: spacing)
        return .modifier(debugSpacingModifier)
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


#Preview("DebugDefault", traits: .debugSpacing(.zero)) {
    PreviewContent.Items()
}


#Preview("Spacing", traits: .spacing(16)) {
    PreviewContent.Items()
}


#Preview("No Trait") {
    Text("By default, a preview wraps its content in a VStack with default spacing.")
        .multilineTextAlignment(.center)
        .padding(.horizontal)
    PreviewContent.Items()
}


/// Traits get applied in order. In this case `content` is wrapped first in `.debugSpacing` and
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
#Preview("ZeroSpacing + HeaderFooter", traits: .debugSpacing(.zero), .headerFooter(.showDividers)) {
    PreviewContent.Items()
}


/// Traits get applied in order. In this case `content` is wrapped first in `.headerFooter` and
/// then in `.debugSpacing`:
/// ```
/// ZeroSpacing {
///     HeaderFooter {
///         content
///     }
/// }
/// ```
///
/// In this case the spacing between items is defined by `.headerFooter`, and debug rectangles
/// surround the header and footer.
#Preview("HeaderFooter + ZeroSpacing", traits: .headerFooter(.showDividers), .debugSpacing(.zero)) {
    PreviewContent.Items()
}
