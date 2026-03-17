//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// TODO: this trait may no longer be needed, since HeaderFooter now defaults to regular spacing.

/// Wraps the preview content in a `VStack` with regular spacing.
///
/// Useful when using traits that enclose with a default spacing of zero.
struct RegularSpacingPreviewModifier: PreviewModifier {

    func body(content: Content, context _: ()) -> some View {
        VStack {
            content
        }
    }

}


/// Wraps the preview content in a `VStack` with regular spacing and surrounded by two additional
/// views to visualize the order of preview trait application.
private struct DebugRegularSpacingPreviewModifier: PreviewModifier {

    func body(content: Content, context _: ()) -> some View {
        VStack {
            CaptionRectangle("RegularSpacing Top", color: .gray,
                 width: 150, height: 40)
            content
            CaptionRectangle("RegularSpacing Bottom", color: .gray,
                 width: 150, height: 40)
        }
    }

}


extension PreviewTrait where T == Preview.ViewTraits {

    fileprivate static var debugRegularSpacing: PreviewTrait {
        .modifier(DebugRegularSpacingPreviewModifier())
    }

}


// MARK: - Previews


#Preview("Default", traits: .debugRegularSpacing) {
    Rectangle()
        .fill(.teal)
        .frame(squareOf: 100)
    Rectangle()
        .fill(.orange)
        .frame(squareOf: 100)
    Divider()
    Rectangle()
        .fill(.yellow)
        .frame(squareOf: 100)
}


/// Traits get applied in order. In this case `content` is wrapped first in `regularSpacing` and
/// then in `headerFooter`:
/// ```
/// HeaderFooter {
///     RegularSpacing {
///         content
///     }
/// }
/// ```
///
/// Although visually identical, this order is preferred.
#Preview("RegularSpacing + HeaderFooter", traits: .debugRegularSpacing, .headerFooter(.showDividers)) {
    Rectangle()
        .fill(.teal)
        .frame(squareOf: 100)
    Rectangle()
        .fill(.orange)
        .frame(squareOf: 100)
    Divider()
    Rectangle()
        .fill(.yellow)
        .frame(squareOf: 100)
}


/// Traits get applied in order. In this case `content` is wrapped first in `headerFooter` and
/// then in `regularSpacing`:
/// ```
/// RegularSpacing {
///     HeaderFooter {
///         content
///     }
/// }
/// ```
///
/// The regular spacing modifier does not work in this case, since content is last wrapped in
/// `.headerFooter`, which uses internally a zero spacing `VStack`.
#Preview("HeaderFooter + RegularSpacing", traits: .headerFooter(.showDividers), .debugRegularSpacing) {
    Rectangle()
        .fill(.teal)
        .frame(squareOf: 100)
    Rectangle()
        .fill(.orange)
        .frame(squareOf: 100)
    Divider()
    Rectangle()
        .fill(.yellow)
        .frame(squareOf: 100)
}
