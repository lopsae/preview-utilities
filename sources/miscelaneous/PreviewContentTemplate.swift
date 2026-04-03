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

    struct ExampleView: View {
        var body: some View {
            CaptionRectangle("Example Preview", color: .orange, size: [200, 150])
        }
    }

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    PreviewContent.ExampleView()
}
