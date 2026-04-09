//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Button {


    /// Creates a button that generates its label from a localized string key
    /// and system image name constrained in size.
    ///
    /// The size of the button will remain consistent irregardless of the image used.
    ///
    /// Different system images have different sizes, which can impact the size of the button. This
    /// is specially noticeable when using the `.iconOnly` label style. The label for the button
    /// constrains the space the image uses to the space occupied by a hidden `Text` containing
    /// only the string `M`. The image is not resized, it is centered over its available space.
    /// Large images may appear closer to the label compared to when using the stock button
    /// initializers.
    ///
    /// This initializer creates a ``Label`` view on your behalf, and treats the localized key
    /// similar to ``Text/init(_:tableName:bundle:comment:)``.
    public init(
        _ titleKey: LocalizedStringKey,
        constrainedSystemImage systemImage: String,
        action: @escaping () -> Void
    )
        where Label == SwiftUI.Label<Text, HiddenParentOverlay<Text, Image>>
    {
        self.init(action: action) {
            SwiftUI.Label {
                Text(titleKey)
            } icon: {
                HiddenParentOverlay {
                    Text(verbatim: "M")
                } content: {
                    Image(systemName: systemImage)
                }
            }
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
        Buttons using the `constrainedSystemImage` initializer have a constrained size, irregardless
        of the image used.
        """)

    HStack {
        Button("Minus", constrainedSystemImage: "minus", action: {})
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)

        Button("Plus", constrainedSystemImage: "plus", action: {})
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)
    }

    Text.caption("Toggle buttons:")

    Button(
        "Circle",
        constrainedSystemImage: circleToggle ? "circle.fill" : "circle"
    ) { circleToggle.toggle() }
    .buttonStyle(.borderedProminent)
    .labelStyle(.iconOnly)
    .debugOverlay(.hairline, .size, .infoAlignment(.outerTrailing))

    Button(
        "Vertical",
        constrainedSystemImage: guidepointToggle ? "guidepoint.vertical" : "guidepoint.horizontal"
    ) { guidepointToggle.toggle() }
    .buttonStyle(.borderedProminent)
    .labelStyle(.iconOnly)
    .debugOverlay(.hairline, .size, .infoAlignment(.outerTrailing))

    PreviewCaption("""
        Buttons using the `.iconOnly` style will change its size depending on the image being used.
        """)

    VStack {
        HStack {
            Button("Minus", systemImage: "minus", action: {})
                .buttonStyle(.borderedProminent)
                .labelStyle(.iconOnly)

            Button("Plus", systemImage: "plus", action: {})
                .buttonStyle(.borderedProminent)
                .labelStyle(.iconOnly)
        }

        Text.caption("Toggle buttons:")
        HStack {
            Button(
                "Circle",
                systemImage: circleToggle ? "circle.fill" : "circle"
            ) { circleToggle.toggle() }
                .buttonStyle(.borderedProminent)
                .labelStyle(.iconOnly)

            Button(
                "Vertical",
                systemImage: guidepointToggle ? "guidepoint.vertical" : "guidepoint.horizontal"
            ) { guidepointToggle.toggle() }
                .buttonStyle(.borderedProminent)
                .labelStyle(.iconOnly)
        }
    }
}


#Preview("Comparison", traits: .headerFooter, PreviewContent.layout) {
    PreviewCaption("""
        For wide images, the label may appear closer to the image that when using regular stock
        button initializers.
        """)

    HStack {
        VStack {
            Text.caption("Constrained")
            Button("Label", constrainedSystemImage: "guidepoint.horizontal", action: {})
                .buttonStyle(.borderedProminent)
            Button("Label", systemImage: "guidepoint.horizontal", action: {})
                .buttonStyle(.borderedProminent)
            Text.caption("Regular")
        }

        VStack {
            Text.caption("Constrained")
            Button("Label", constrainedSystemImage: "guidepoint.vertical", action: {})
                .buttonStyle(.borderedProminent)
            Button("Label", systemImage: "guidepoint.vertical", action: {})
                .buttonStyle(.borderedProminent)
            Text.caption("Regular")
        }

        VStack {
            Text.caption("Constrained")
            Button("Label", constrainedSystemImage: "circle", action: {})
                .buttonStyle(.borderedProminent)
            Button("Label", systemImage: "circle", action: {})
                .buttonStyle(.borderedProminent)
            Text.caption("Regular")
        }
    }

    PreviewCaption("""
        Font modifiers still work as expected.
        """)

    HStack {
        VStack {
            Text.caption("Constrained")
            Button("Caption", constrainedSystemImage: "circle", action: {})
                .buttonStyle(.borderedProminent)
            Button("Caption", systemImage: "circle", action: {})
                .buttonStyle(.borderedProminent)
            Text.caption("Regular")
        }.font(.caption)

        VStack {
            Text.caption("Constrained")
            Button("Body", constrainedSystemImage: "circle", action: {})
                .buttonStyle(.borderedProminent)
            Button("Body", systemImage: "circle", action: {})
                .buttonStyle(.borderedProminent)
            Text.caption("Regular")
        }

        VStack {
            Text.caption("Constrained")
            Button("Title", constrainedSystemImage: "circle", action: {})
                .buttonStyle(.borderedProminent)
            Button("Title", systemImage: "circle", action: {})
                .buttonStyle(.borderedProminent)
            Text.caption("Regular")
        }.font(.title)
    }
}
