//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// Template for Previews and PreviewContent to copy into new files.


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    struct Silver: View {
        var body: some View {
            Text("Ag")
            .font(.title.pointSize(100))
            .border(.green.tertiary, width: 8)
        }
    }

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    PreviewContent.Silver()
    .debugOverlay(.size)
}
