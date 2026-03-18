//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Button {

    init(
        _ titleKey: LocalizedStringKey,
        sizedSystemImage systemImage: String,
        action: @escaping () -> Void
    )
        where Label == SwiftUI.Label<Text, HiddenOverlay<Text, Image>>
    {
        self.init(action: action) {
            SwiftUI.Label {
                Text(titleKey)
            } icon: {
                HiddenOverlay {
                    Text("M")
                } content: {
                    Image(systemName: systemImage)
                }
            }
        }
    }

}


struct HiddenOverlay<Parent: View, Content: View>: View {
    @ViewBuilder let parent: Parent
    @ViewBuilder let content: Content
    var body: some View {
        parent
            .hidden()
            .accessibilityHidden(true)
            .overlay(alignment: .center) {
                content
            }
    }
}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var circleToggle: Bool = false
    @Previewable @State var guidepointToggle: Bool = false

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

        Button("Vertical", systemImage: guidepointToggle ? "guidepoint.vertical" : "guidepoint.horizontal", action: { guidepointToggle.toggle() })
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)

        Button("Plus", systemImage: "plus", action: {})
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)
    }


    PreviewCaption("""
        Buttons using the `sizedSystemImage` initializer have a constrained size, irregardless
        of the image used.
        """)

    HStack {
        Button("Minus", sizedSystemImage: "minus", action: {})
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)

        Button("Circle", sizedSystemImage: circleToggle ? "circle.fill" : "circle", action: { circleToggle.toggle() })
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)

        Button("Vertical", sizedSystemImage: guidepointToggle ? "guidepoint.vertical" : "guidepoint.horizontal", action: { guidepointToggle.toggle() })
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)

        Button("Plus", sizedSystemImage: "plus", action: {})
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)
    }

    // TODO: put in separate preview
    Text.caption("Constrained")
    Button("Label", sizedSystemImage: "guidepoint.horizontal", action: {})
        .buttonStyle(.borderedProminent)
    Button("Label", systemImage: "guidepoint.horizontal", action: {})
        .buttonStyle(.borderedProminent)
    Text.caption("Regular")
}
