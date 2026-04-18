//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Experimental view that displays the given content overlaid on a parent view that is hidden.
///
/// The parent content is hidden visually and for accessibility, but still occupies space normally
/// for layout purpouses.
///
/// The parent content determines the space that will be used. The overlaid content is centered in
/// this space. Overlaid content larger that the parent content does not modify the size occupied by
/// the parent content, the overlaid content just overflows.
///
/// This has the practical result of displaying the overlaid content centered in the space occupied
/// by the parent view, irregardless of the size of the overlaid content.
public struct HiddenParentOverlay<Parent: View, Overlaid: View>: View {

    let parent: () -> Parent
    let overlaid: () -> Overlaid
    let alignment: Alignment
    let isParentVisible: Bool


    public init(
        alignment: Alignment = .center,
        @ViewBuilder parent: @escaping () -> Parent,
        @ViewBuilder overlaid: @escaping () -> Overlaid
    ) {
        self.init(alignment: alignment, parent: parent, overlaid: overlaid, isParentVisible: false)
    }


    /// Private base initializer. Allows for parent visibility.
    private init(
        alignment: Alignment,
        parent: @escaping () -> Parent,
        overlaid: @escaping () -> Overlaid,
        isParentVisible: Bool
    ) {
        self.parent = parent
        self.overlaid = overlaid
        self.alignment = alignment
        self.isParentVisible = isParentVisible
    }


    public var body: some View {
        Group {
            if isParentVisible {
                parent()
            } else {
                parent()
                .hidden()
                .accessibilityHidden(true)
            }
        }
        .overlay(alignment: alignment) {
            overlaid()
        }
    }


    /// Returns the view with the parent visible.
    ///
    /// Intended for preview and troubleshooting.
    public func visibleParent(_ visible: Bool = true) -> Self {
        .init(alignment: alignment, parent: parent, overlaid: overlaid, isParentVisible: visible)
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    HiddenParentOverlay {
        Text("Parent")
    } overlaid: {
        Text("Large Overlaid Text")
        .font(.title)
        .fixedSize()
    }
    .floatingCaption("Hidden Parent", .colorStyle(.purple), .alignment(.outerTop))

    DashedDivider()

    HiddenParentOverlay {
        Text("Parent")
    } overlaid: {
        Text("Large Overlaid Text")
        .font(.title)
        .fixedSize()
        .opacity(0.1)
    }
    .visibleParent()
    .floatingCaption("Visible Parent", .colorStyle(.purple), .alignment(.outerBottom))

    DashedDivider().padding(.top)

    PreviewCaption("Modifiers like `.font` will affect both the hidden parent and the overlaid content.")

    HiddenParentOverlay {
        Text("Parent")
    } overlaid: {
        Text("Long Overlaid Text")
        .fixedSize()
        .opacity(0.1)
    }
    .visibleParent()
    .font(.headline)


    HiddenParentOverlay {
        Image(systemName: "circle")
    } overlaid: {
        Text("Overlaid Text")
        .fixedSize()
        .opacity(0.1)
    }
    .visibleParent()
    .font(.title)
}

#Preview("Alignments", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var horizontalAlignment: HorizontalAlignmentEnum = .center
    @Previewable @State var verticalAlignment: VerticalAlignmentEnum = .bottom

    Picker(
        "Horizontal",
        selection: $horizontalAlignment,
        selectables: HorizontalAlignmentEnum.allCases,
        elementFormat: .capitalized(property: \.displayName)
    ).pickerStyle(.segmented)

    Picker(
        "Vertical",
        selection: $verticalAlignment,
        selectables: VerticalAlignmentEnum.allCases,
        elementFormat: .capitalized(property: \.displayName)
    ).pickerStyle(.segmented)

    let alignment = Alignment(
        horizontal: horizontalAlignment.alignment,
        vertical: verticalAlignment.alignment)

    HiddenParentOverlay(alignment: alignment) {
        Text("Parent")
    } overlaid: {
        Text("Large Overlaid Text")
        .font(.title)
        .fixedSize()
        .floatingCaption("", .colorStyle(.indigo.opacity(0.3)))
    }
    .floatingCaption("Parent", .colorStyle(.purple), .alignment(.outerTrailingUnder))
    .frame(height: 70)

    DashedDivider()

    HiddenParentOverlay(alignment: alignment) {
        Text("Parent")
    } overlaid: {
        Text("Large Overlaid Text")
        .font(.title)
        .fixedSize()
        .opacity(0.1)
        .floatingCaption("", .colorStyle(.indigo.opacity(0.3)))
    }
    .visibleParent()
    .floatingCaption("Visible Parent", .colorStyle(.purple), .alignment(.outerTrailingUnder))
    .frame(height: 70)
}
