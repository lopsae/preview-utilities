//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct ZeroSpacingPreviewModifier: PreviewModifier {

    func body(content: Content, context _: ()) -> some View {
        VStack(spacing: 0) {
            content
        }
    }

}


private struct DebugZeroSpacingPreviewModifier: PreviewModifier {

    func body(content: Content, context _: ()) -> some View {
        VStack(spacing: 0) {
            Text("ZeroSpacing Top")
            content
            Text("ZeroSpacing Bottom")
        }
    }

}


extension PreviewTrait where T == Preview.ViewTraits {

    public static var zeroSpacing: PreviewTrait {
        .modifier(ZeroSpacingPreviewModifier())
    }


    fileprivate static var debugZeroSpacing: PreviewTrait {
        .modifier(DebugZeroSpacingPreviewModifier())
    }

}


#Preview("Default", traits: .zeroSpacing) {
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


#Preview("No Trait") {
    Text("By default, a preview wraps its content in a VStack with default spacing.")
        .multilineTextAlignment(.center)

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
        .frame(square: 100)
    Rectangle()
        .fill(.orange)
        .frame(square: 100)
    Divider()
    Rectangle()
        .fill(.yellow)
        .frame(square: 100)
}
