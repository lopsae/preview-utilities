//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


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

    /// Set of edges where the `ConcentricRectangle` is padded from the edge of content, extending
    /// into the safeareas.
    let backgroundPaddingEdges: Edge.Set

    func body(content: Content) -> some View {
        content
        // One padding always for content.
        .padding()
        // One padding from the background edge.
        .padding(contentPaddingEdges)
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
        backgroundPaddingEdges: Edge.Set = .all,
    ) -> some View {
        let backgroundModifier = ConcentricSafeAreaBackgroundModifier(
            fill: fill,
            contentPaddingEdges: contentPaddingEdges,
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
            backgroundPaddingEdges: paddingEdges
        )
        return modifier(backgroundModifier)
    }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iphoneSize

    static let backgroundFill: some ShapeStyle = .pink.tertiary

}


#Preview("Default", traits: PreviewContent.layout) {
    Text("Along top safe area")
        .maxWidthFrame()
        .debugOutline()
        .concentricSafeAreaBackground(fill: PreviewContent.backgroundFill)
        .debugOutline()

    Spacer()

    Text("Not adyacent to safe areas")
        .maxWidthFrame()
        .debugOutline()
        .concentricSafeAreaBackground(fill: PreviewContent.backgroundFill)
        .debugOutline()

    Spacer()

    Text("Along bottom safe area")
        .maxWidthFrame()
        .debugOutline()
        .concentricSafeAreaBackground(fill: PreviewContent.backgroundFill)
        .debugOutline()
}


#Preview("Paddings", traits: PreviewContent.layout) {
    VStack {
        Text("Content top padding removed")
        Text("Content along the top safe area usually needs only the default top padding.")
            .font(.caption)
    }
    .maxWidthFrame()
    .debugOutline()
    .concentricSafeAreaBackground(
        fill: PreviewContent.backgroundFill,
        contentPaddingEdges: .not(.top))
    .debugOutline()

    Spacer()

    Text("Surrounded by safe areas")
        .maxWidthFrame()
        .debugOutline()
        .concentricSafeAreaBackground(
            fill: PreviewContent.backgroundFill,
            contentPaddingEdges: .vertical,
            backgroundPaddingEdges: .horizontal)
        .debugOutline()
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
    .debugOutline()
    .concentricSafeAreaBackground(
        fill: PreviewContent.backgroundFill,
        contentPaddingEdges: .not(.bottom))
    .debugOutline()
}


#Preview("Adyacent", traits: PreviewContent.layout) {
    Text("Adyacent content above")
        .maxWidthFrame()
        .debugOutline()
        .concentricSafeAreaBackground(
            fill: PreviewContent.backgroundFill,
            paddingEdges: .not(.bottom))
        .debugOutline()

    Text("Content with default paddings")
        .maxWidthFrame()
        .concentricSafeAreaBackground(fill: PreviewContent.backgroundFill)

    VStack {
        Text("Adyacent content below")
        Text("Paddings in content adyacent to other backgrounds can be modified to keep consistent spacing")
            .font(.caption)
    }

        .maxWidthFrame()
        .debugOutline()
        .concentricSafeAreaBackground(
            fill: PreviewContent.backgroundFill,
            paddingEdges: .not(.top))
        .debugOutline()
}
