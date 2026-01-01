//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Wraps the preview content in a `VStack` with regular spacing.
///
/// Useful when using traits like `.headerFooter` which by default set the enclosing `VStack`
/// spacing to zero.
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
            Text("RegularSpacing Top")
            content
            Text("RegularSpacing Bottom")
        }
    }

}


extension PreviewTrait where T == Preview.ViewTraits {

    /// Wraps the preview content in a `VStack` with regular spacing.
    public static var regularSpacing: PreviewTrait {
        .modifier(RegularSpacingPreviewModifier())
    }


    fileprivate static var debugRegularSpacing: PreviewTrait {
        .modifier(DebugRegularSpacingPreviewModifier())
    }

}


// MARK: - Previews


#Preview("Default", traits: .regularSpacing) {
    Rectangle()
        .fill(.teal)
        .frame(square: 100)
    Rectangle()
        .fill(.orange)
        .frame(square: 100)
    Divider()
    Rectangle()
        .fill(.yellow)
        .frame(square: 100)
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
        .frame(square: 100)
    Rectangle()
        .fill(.orange)
        .frame(square: 100)
    Divider()
    Rectangle()
        .fill(.yellow)
        .frame(square: 100)
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
        .frame(square: 100)
    Rectangle()
        .fill(.orange)
        .frame(square: 100)
    Divider()
    Rectangle()
        .fill(.yellow)
        .frame(square: 100)
}
