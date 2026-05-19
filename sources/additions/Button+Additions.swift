//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Button {


    // FUTURE: Would this work better as a button style? Likely no, because then that would exclude
    // other button styles like .iconOnly. Unless styles can be stacked together.

    /// Creates a button that generates its label from a localized string key and system image name,
    /// with the image constrained in size.
    ///
    /// The size of the button will remain consistent irregardless of the image used.
    ///
    /// Different system images have different sizes, which can impact the size of the button. This
    /// is specially noticeable when using the `.iconOnly` label style. The label produced for the
    /// button constrains the space the image can use to the space occupied by a hidden *circle*
    /// image, the displayed image itself is not resized. The image is aligned to the horizontal
    /// center and first text baseline of its available space.
    ///
    /// Large images may appear slightly closer to the label when compared to buttons using the
    /// default initializers.
    ///
    /// This initializer creates a `SwiftUI/Label` view on your behalf, and treats the localized key
    /// similar to `SwiftUI/Text.init(_:tableName:bundle:comment:)`.
    public init(
        _ titleKey: LocalizedStringKey,
        constrainedSystemImage systemImage: String,
        action: @escaping () -> Void
    )
    where Label == SwiftUI.Label<Text, HiddenParentOverlay<Image, ViewWithOpacity<Image>>>
    {
        self.init(
            titleKey,
            constrainedSystemImage: systemImage,
            visibleConstraint: false,
            action: action
        )
    }


    fileprivate init(
        _ titleKey: LocalizedStringKey,
        constrainedSystemImage systemImage: String,
        visibleConstraint: Bool,
        action: @escaping () -> Void
    )
    where Label == SwiftUI.Label<Text, HiddenParentOverlay<Image, ViewWithOpacity<Image>>>
    {
        self.init(action: action) {
            let opacity: Double? = visibleConstraint ? 0.5 : nil
            SwiftUI.Label {
                Text(titleKey)
            } icon: {
                HiddenParentOverlay(alignment: .centerFirstTextBaseline) {
                    // TODO: try "app.grid" instead of circle for base symbol.
                    Image(systemName: "circle")
                } overlaid: {
                    ViewWithOpacity(opacity: opacity) {
                        Image(systemName: systemImage)
                    }
                }
                .visibleParent(visibleConstraint)
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

        Button("Photo", constrainedSystemImage: "photo.badge.shield.exclamationmark", action: {})
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)

    }

    Text.caption("Toggle buttons:")

    Button(
        "Circle/Fill",
        constrainedSystemImage: circleToggle ? "circle.fill" : "circle"
    ) { circleToggle.toggle() }
    .buttonStyle(.borderedProminent)
    .labelStyle(.iconOnly)
    .debugOverlay(.hairline, .size, .infoAlignment(.outerTrailing))

    Button(
        "Vertical/Horizontal",
        constrainedSystemImage: guidepointToggle ? "guidepoint.vertical" : "guidepoint.horizontal"
    ) { guidepointToggle.toggle() }
    .buttonStyle(.borderedProminent)
    .labelStyle(.iconOnly)
    .debugOverlay(.hairline, .size, .infoAlignment(.outerTrailing))

    PreviewCaption("""
        Buttons using the default initializer and the `.iconOnly` style will change its size 
        depending on the image being used.
        """)

    VStack {
        HStack {
            Button("Minus", systemImage: "minus", action: {})
                .buttonStyle(.borderedProminent)
                .labelStyle(.iconOnly)

            Button("Plus", systemImage: "plus", action: {})
                .buttonStyle(.borderedProminent)
                .labelStyle(.iconOnly)

            Button("Photo", systemImage: "photo.badge.shield.exclamationmark", action: {})
                .buttonStyle(.borderedProminent)
                .labelStyle(.iconOnly)
        }

        Text.caption("Toggle buttons:")
        HStack {
            Button(
                "Circle/Fill",
                systemImage: circleToggle ? "circle.fill" : "circle"
            ) { circleToggle.toggle() }
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)

            Button(
                "Vertical/Horizontal",
                systemImage: guidepointToggle ? "guidepoint.vertical" : "guidepoint.horizontal"
            ) { guidepointToggle.toggle() }
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)
        }
    }
}


#Preview("Labeled", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var circleToggle: Bool = false
    @Previewable @State var guidepointToggle: Bool = false

    PreviewCaption("""
        The image is aligned to `centerFirstTextBaseline`, which is the same behaviour as using the
        stock initializer when using system images.
        """)

    Text.caption("Constrained")
    HStack {
        Button("Ag", constrainedSystemImage: "circle", action: {})
            .buttonStyle(.borderedProminent)
            .debugAlignmentOverlay(.firstTextBaseline)

        Button("Ag", constrainedSystemImage: "guidepoint.horizontal", action: {})
            .buttonStyle(.borderedProminent)
            .debugAlignmentOverlay(.firstTextBaseline)

        Button("Ag", constrainedSystemImage: "envelope.badge.shield.half.filled", action: {})
            .buttonStyle(.borderedProminent)
            .debugAlignmentOverlay(.firstTextBaseline)
    }

    HStack {
        Button("Ag", systemImage: "circle", action: {})
            .buttonStyle(.borderedProminent)
            .debugAlignmentOverlay(.firstTextBaseline)

        Button("Ag", systemImage: "guidepoint.horizontal", action: {})
            .buttonStyle(.borderedProminent)
            .debugAlignmentOverlay(.firstTextBaseline)

        Button("Ag", systemImage: "envelope.badge.shield.half.filled", action: {})
            .buttonStyle(.borderedProminent)
            .debugAlignmentOverlay(.firstTextBaseline)
    }
    Text.caption("Stock")

    PreviewCaption("""
        The difference in size is particularly noticeable when the icon has protuding elements in
        bottom.
        """)

    HStack {
        Button("Ag", systemImage: "envelope.badge.shield.half.filled", action: {})
        .buttonStyle(.borderedProminent)
        .debugAlignmentOverlay(.firstTextBaseline)
        .stackAbove {
            Text.caption("Stock")
        }
        // FIXME: compare stock using Image, against a constrained one
        Button("Ag", image: .moduleCatalog(.envelopeOffcenterBadgeBottomTrailing), action: {})
        .buttonStyle(.borderedProminent)
        .debugAlignmentOverlay(.firstTextBaseline)
        .stackAbove {
            Text.caption("Custom")
        }
    }
}


#Preview("Icon", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var circleToggle: Bool = false
    @Previewable @State var guidepointToggle: Bool = false

    PreviewCaption("""
        Buttons providing an `Image` directly as  also have size size issues.
        """)
    .paragraph("""
        This direct `Image` case is necessary for using custom symbols.
        """)

    VStack {
        Text.caption("Custom Symbols")
        HStack {
            // FIXME: for custom symbols, button can be created using `image:` or creating the Label directly.
            // There is no single api to use either system symbols or custom symbols. One might need to be created.
            Button("Offcenter", image: .moduleCatalog(.envelopeOffcenterBadgeTopTrailing), action: {})
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)

            // FIXME: Bring specialized Button(icon) init from separate project.
            Button(action: {}) {
                Label(title: { Text("Offcenter") }, icon: { Image(.moduleCatalog(.envelopeOffcenterBadgeTopTrailing)) } )
            }
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)

            Button(action: {}) {
                Label(title: { Text("Offcenter") }, icon: { Image(.moduleCatalog(.envelopeOffcenterBadgeBottomTrailing)) } )
            }
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)

            Button("Offcenter", image: .moduleCatalog(.envelopeOffcenterBadgeBottomTrailing), action: {})
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)
        }

        Text.caption("System Symbols")
        HStack {
            Button(action: {}) {
                Label(title: { Text("Minus") }, icon: { Image(systemName: "minus") } )
            }
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)

            Button(action: {}) {
                Label(title: { Text("Horizontal") }, icon: { Image(systemName: "guidepoint.horizontal") } )
            }
            .buttonStyle(.borderedProminent)
            .labelStyle(.iconOnly)

            Button(action: {}) {
                Label(title: { Text("Circle") }, icon: { Image(systemName: "circle") } )
            }
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


#Preview("Alignment", traits: .headerFooter, PreviewContent.layout) {
    PreviewCaption("""
        The image is aligned to `centerFirstTextBaseline`, so that asymetrical images remain
        aligned with the label text.
        """)

    HStack {
        VStack {
            Text.caption("Constrained")
            Group {
                let imageName = "photo.badge.shield.exclamationmark"
                Button("Align", constrainedSystemImage: imageName, action: {})
                    .buttonStyle(.borderedProminent)
                    .debugAlignmentOverlay(.firstTextBaseline)
                Button("Align", constrainedSystemImage: imageName, visibleConstraint: true, action: {})
                    .buttonStyle(.borderedProminent)
                    .debugAlignmentOverlay(.firstTextBaseline)
                Button("Align", systemImage: imageName, action: {})
                    .buttonStyle(.borderedProminent)
                    .debugAlignmentOverlay(.firstTextBaseline)
            }
            .font(.title)
            Text.caption("Regular")
        }

        VStack {
            Text.caption("Constrained")
            Group {
                let imageName = "envelope.badge.shield.half.filled"
                Button("Align", constrainedSystemImage: imageName, action: {})
                    .buttonStyle(.borderedProminent)
                    .debugAlignmentOverlay(.firstTextBaseline)
                Button("Align", constrainedSystemImage: imageName, visibleConstraint: true, action: {})
                    .buttonStyle(.borderedProminent)
                    .debugAlignmentOverlay(.firstTextBaseline)
                Button("Align", systemImage: imageName, action: {})
                    .buttonStyle(.borderedProminent)
                    .debugAlignmentOverlay(.firstTextBaseline)
            }
            .font(.title)
            Text.caption("Regular")
        }
    }
}


#Preview("VisibleConstrain", traits: .headerFooter, PreviewContent.layout) {
    PreviewCaption("""
        The `visibleConstrain` parameter can be used to debug the hidden image constrain.
        """)

    HStack {
        VStack {
            Text.caption("Constrained")
            Group {
                let imageName = "guidepoint.horizontal"
                Button("Horiz", constrainedSystemImage: imageName, action: {})
                    .buttonStyle(.borderedProminent)
                Button("Horiz", constrainedSystemImage: imageName, visibleConstraint: true, action: {})
                    .buttonStyle(.borderedProminent)
                Button("Horiz", systemImage: imageName, action: {})
                    .buttonStyle(.borderedProminent)
            }
            .font(.title)
            Text.caption("Regular")
        }

        VStack {
            Text.caption("Constrained")
            Group {
                let imageName = "photo.badge.shield.exclamationmark"
                Button("Off", constrainedSystemImage: imageName, action: {})
                    .buttonStyle(.borderedProminent)
                Button("Off", constrainedSystemImage: imageName, visibleConstraint: true, action: {})
                    .buttonStyle(.borderedProminent)
                Button("Off", systemImage: imageName, action: {})
                    .buttonStyle(.borderedProminent)
            }
            .font(.title)
            Text.caption("Regular")
        }
    }
}



// MARK: EXPERIMENTAL: ViewWithOpacity

// FUTURE: if used elsewhere consider moving to its own file and add previews to ascertain it works.

/// View with an opacity modifier. Used instead of the `.opacity` modifier when a concrete type is
/// necessary.
///
/// Used to provide a concrete-type for type-constraints in extended inits, since operators like
/// `.opacity` often return an opaque `some View`.
public struct ViewWithOpacity<Content>: View where Content: View {
    let content: () -> Content
    let opacity: Double?

    init(opacity: Double?, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.opacity = opacity
    }

    public var body: some View {
        if let opacity {
            content().opacity(opacity)
        } else {
            // No opacity is applied, to allow external modifiers to apply.
            content()
        }
    }
}


// TODO: Move to additions.

extension View {

    func debugAlignmentOverlay(_ verticalAlignment: VerticalAlignment) -> some View {
        let alignment: Alignment = .init(horizontal: .center, vertical: verticalAlignment)
        return self.overlay(alignment: alignment) {
            Rectangle()
                .fill(.red.secondary)
                .frame(height: 2)
        }
    }


    func debugAlignmentOverlay(_ horizontalAlignment: HorizontalAlignment) -> some View {
        let alignment: Alignment = .init(horizontal: horizontalAlignment, vertical: .center)
        return self.overlay(alignment: alignment) {
            Rectangle()
                .fill(.red.secondary)
                .frame(width: 2)
        }
    }

}
