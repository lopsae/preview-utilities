//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Button {


}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var circleToggle: Bool = false
    PreviewCaption("""
        Buttons using the `.iconOnly` style will change its size depending on the image being used.
        """)

    HStack {
        Button("Minus", systemImage: "minus", action: {})
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)

        Button("Circle", systemImage: circleToggle ? "circle.fill" : "circle", action: { circleToggle.toggle() })
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)

        Button("Plus", systemImage: "plus", action: {})
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)
    }
}
