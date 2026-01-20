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
            CaptionRectangle("ZeroSpacing Top", color: .gray,
                 width: 150, height: 40)
            content
            CaptionRectangle("ZeroSpacing Top", color: .gray,
                 width: 150, height: 40)
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


// MARK: - Previews


#Preview("Default", traits: .zeroSpacing) {
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


#Preview("No Trait") {
    Text("By default, a preview wraps its content in a VStack with default spacing.")
        .multilineTextAlignment(.center)
        .padding(.horizontal)

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


/// Traits get applied in order. In this case `content` is wrapped first in `zeroSpacing` and
/// then in `headerFooter`:
/// ```
/// HeaderFooter {
///     ZeroSpacing {
///         content
///     }
/// }
/// ```
///
/// Although visually identical, this order is preferred.
#Preview("ZeroSpacing + HeaderFooter", traits: .debugZeroSpacing, .headerFooter(.showDividers)) {
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
/// then in `zeroSpacing`:
/// ```
/// ZeroSpacing {
///     HeaderFooter {
///         content
///     }
/// }
/// ```
///
/// Although visually identical, the oposite order is preferred.
#Preview("HeaderFooter + ZeroSpacing", traits: .headerFooter(.showDividers), .debugZeroSpacing) {
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
