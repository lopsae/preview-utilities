//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct SafeAreaPad<S: ShapeStyle>: View {

    let topDivider: Bool
    let bottomDivider: Bool
    let backgroundFill: S


    init(topDivider: Bool = false, bottomDivider: Bool = false, fill: S = .orange.tertiary) {
        self.topDivider = topDivider
        self.bottomDivider = bottomDivider
        self.backgroundFill = fill
    }

    var body: some View {
        if (topDivider) {
            Divider()
        }

        Text("clear from device safe area")
            .font(.caption)
            .maxWidthFrame()
            .concentricSafeAreaBackground(fill: backgroundFill)

        if (bottomDivider) {
            Divider()
        }
    }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


#Preview("Defaults", traits: PreviewContent.layout) {
    SafeAreaPad()
        .debugOverlay()

    Spacer()

    SafeAreaPad()
        .debugOverlay()

    Spacer()

    SafeAreaPad()
        .debugOverlay()
}
