//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// TODO: update docs after this gets used in HeaderFooter again
/// Pads the modified content and draws behind it a `ConcentricRectangle` that extends into the
/// content safe area.
///
/// Used to contain preview elements with the same visual style as the header and footer produced by
/// `HeaderFooterPreviewModifier`.
struct ConcentricSafeAreaBackgroundModifier<S: ShapeStyle>: ViewModifier {

    /// Shape style to fill the `ConcentricRectagle` background.
    let fill: S

    /// Set of edges where content is padded to separate from the `ConcentricRectangle` background
    /// edge.
    let contentPaddingEdges: Edge.Set

    /// Set of edges where content is padded to separate from the edges of the view.
    let safeAreaPaddingEdges: Edge.Set

    /// Set of edges where the `ConcentricRectangle` is padded from the edge of content, extending
    /// into the safeareas.
    let backgroundPaddingEdges: Edge.Set

    func body(content: Content) -> some View {
        content
        // Padding from the background edge (which is itself padded from the view's edge).
        .padding(contentPaddingEdges)
        // Padding from the edge of the view.
        .padding(safeAreaPaddingEdges)
        .background {
            ConcentricRectangle(minimumConcentricRadius: HeaderFooterContainerView.minimumConcentricRadius)
                .fill(fill)
                .padding(backgroundPaddingEdges)
                .ignoresSafeArea()
        }
    }

}


extension View {

    func concentricSafeAreaBackground(
        fill: some ShapeStyle,
        contentPaddingEdges: Edge.Set = .all,
        safeAreaPaddingEdges: Edge.Set = .all,
        backgroundPaddingEdges: Edge.Set = .all,
    ) -> some View {
        let backgroundModifier = ConcentricSafeAreaBackgroundModifier(
            fill: fill,
            contentPaddingEdges: contentPaddingEdges,
            safeAreaPaddingEdges: safeAreaPaddingEdges,
            backgroundPaddingEdges: backgroundPaddingEdges
        )
        return modifier(backgroundModifier)
    }


    func concentricSafeAreaBackground(
        fill: some ShapeStyle,
        paddingEdges: Edge.Set
    ) -> some View {
        let backgroundModifier = ConcentricSafeAreaBackgroundModifier(
            fill: fill,
            contentPaddingEdges: paddingEdges,
            safeAreaPaddingEdges: .all,
            backgroundPaddingEdges: paddingEdges
        )
        return modifier(backgroundModifier)
    }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    static let backgroundFill: some ShapeStyle = .pink.tertiary

}


#Preview("Default", traits: PreviewContent.layout) {
    Text("Along top safe area")
        .maxWidthFrame()
        .debugOverlay()
        .concentricSafeAreaBackground(fill: PreviewContent.backgroundFill)
        .debugOverlay()

    Spacer()

    Text("Not adyacent to safe areas")
        .maxWidthFrame()
        .debugOverlay()
        .concentricSafeAreaBackground(fill: PreviewContent.backgroundFill)
        .debugOverlay()

    Spacer()

    Text("Along bottom safe area")
        .maxWidthFrame()
        .debugOverlay()
        .concentricSafeAreaBackground(fill: PreviewContent.backgroundFill)
        .debugOverlay()
}


#Preview("Paddings", traits: PreviewContent.layout) {
    VStack {
        Text("Content top padding removed")
        Text("Content along the top safe area usually needs only the default top padding.")
            .font(.caption)
    }
    .maxWidthFrame()
    .debugOverlay()
    .concentricSafeAreaBackground(
        fill: PreviewContent.backgroundFill,
        contentPaddingEdges: .not(.top))
    .debugOverlay()

    Spacer()

    Text("Surrounded by safe areas")
        .maxWidthFrame()
        .debugOverlay()
        .concentricSafeAreaBackground(
            fill: PreviewContent.backgroundFill,
            contentPaddingEdges: .vertical,
            backgroundPaddingEdges: .horizontal)
        .debugOverlay()
        .safeAreaPadding(100)

    Spacer()

    VStack {
        Text("Along bottom safe area")
        Text("Content along the bottom safe area usually needs only the default bottom padding.")
            .font(.caption)
        Text("However, in macOS this leaves the content touching the bottom of the background.")
            .font(.caption)
    }
    .maxWidthFrame()
    .debugOverlay()
    .concentricSafeAreaBackground(
        fill: PreviewContent.backgroundFill,
        contentPaddingEdges: .not(.bottom))
    .debugOverlay()
}


#Preview("Adyacent", traits: PreviewContent.layout) {
    Text("Adyacent content above")
        .maxWidthFrame()
        .debugOverlay()
        .concentricSafeAreaBackground(
            fill: PreviewContent.backgroundFill,
            paddingEdges: .not(.bottom))
        .debugOverlay()

    Text("Content with default paddings")
        .maxWidthFrame()
        .concentricSafeAreaBackground(fill: PreviewContent.backgroundFill)

    VStack {
        Text("Adyacent content below")
        Text("Paddings in content adyacent to other backgrounds can be modified to keep consistent spacing")
            .font(.caption)
    }

        .maxWidthFrame()
        .debugOverlay()
        .concentricSafeAreaBackground(
            fill: PreviewContent.backgroundFill,
            paddingEdges: .not(.top))
        .debugOverlay()
}


#Preview("HeaderFooter", traits: PreviewContent.layout) {
    VStack {
        Text("Header")
        Text("In iOS, since it does have a safe area, all content paddings are removed to allow the header to hug the top.")
            .font(.caption)
    }
    .maxWidthFrame()
    .debugOverlay()
    .concentricSafeAreaBackground(
        fill: PreviewContent.backgroundFill,
        contentPaddingEdges: .not(.top),
        safeAreaPaddingEdges: .not(.top))
    .debugOverlay()

    Spacer()

    VStack {
        Text("Footer")
        Text("In iOS, since it does have a safe area, all content paddings are removed to allow the footer to hug the bottom.")
            .font(.caption)
    }
    .maxWidthFrame()
    .debugOverlay()
    .concentricSafeAreaBackground(
        fill: PreviewContent.backgroundFill,
        contentPaddingEdges: .not(.bottom),
        safeAreaPaddingEdges: .not(.bottom))
    .debugOverlay()
}
