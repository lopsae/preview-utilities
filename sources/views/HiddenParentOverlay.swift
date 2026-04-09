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

    let visibleParent: Bool
    let parent: () -> Parent
    let overlaid: () -> Overlaid


    init(
        visibleParent: Bool = false,
        @ViewBuilder parent: @escaping () -> Parent,
        @ViewBuilder overlaid: @escaping () -> Overlaid
    ) {
        self.visibleParent = visibleParent
        self.parent = parent
        self.overlaid = overlaid
    }


    public init(
        @ViewBuilder parent: @escaping () -> Parent,
        @ViewBuilder overlaid: @escaping () -> Overlaid
    ) {
        self.init(visibleParent: false, parent: parent, overlaid: overlaid)
    }


    public var body: some View {
        Group {
            if visibleParent {
                parent()
            } else {
                parent()
                .hidden()
                .accessibilityHidden(true)
            }
        }
        .overlay(alignment: .center) {
            overlaid()
        }
    }


    /// Returns the view with the parent visible. Intended for preview and troubleshooting.
    public func makeParentVisible() -> Self {
        .init(visibleParent: true, parent: parent, overlaid: overlaid)
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
    .makeParentVisible()
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
    .makeParentVisible()
    .font(.headline)


    HiddenParentOverlay {
        Image(systemName: "circle")
    } overlaid: {
        Text("Overlaid Text")
        .fixedSize()
        .opacity(0.1)
    }
    .makeParentVisible()
    .font(.title)
}
