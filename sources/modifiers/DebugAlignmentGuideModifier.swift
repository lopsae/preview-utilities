//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct DebugAlignmentGuideModifier: ViewModifier {

    let alignment: Alignment

    func body(content: Content) -> some View {
        content
        .debugAlignmentGuide(horizontal: alignment.horizontal)
        .debugAlignmentGuide(vertical:  alignment.vertical)
    }

}


struct DebugHorizontalAlignmentGuideModifier: ViewModifier {

    let horizontalAlignment: HorizontalAlignment
    let extend: CGFloat
    let anchor: VerticalAlignment

    func body(content: Content) -> some View {
        let alignment = Alignment(horizontal: horizontalAlignment, vertical: anchor)
        content.overlay(alignment: alignment) {
            ExtendedHeightLayout(extend: extend) {
                Rectangle()
                .fill(.red.secondary)
                .frame(width: 2)
            }
        }
    }

}


struct DebugVerticalAlignmentGuideModifier: ViewModifier {

    let verticalAlignment: VerticalAlignment

    func body(content: Content) -> some View {
        let alignment = Alignment(horizontal: .center, vertical: verticalAlignment)
        content.overlay(alignment: alignment) {
            Rectangle()
            .fill(.red.secondary)
            .frame(height: 2)
        }
    }

}


// MARK: - View Extension


extension View {

    public func debugAlignmentGuide(_ alignment: Alignment) -> some View {
        return modifier(DebugAlignmentGuideModifier(alignment: alignment))
    }

    public func debugAlignmentGuide(
        horizontal horizontalAlignment: HorizontalAlignment,
        extend: CGFloat = .zero,
        anchor: VerticalAlignment = .center
    ) -> some View {
        let guideModifier = DebugHorizontalAlignmentGuideModifier(
            horizontalAlignment: horizontalAlignment,
            extend: extend,
            anchor: anchor
        )
        return modifier(guideModifier)
    }

    public func debugAlignmentGuide(vertical verticalAlignment: VerticalAlignment) -> some View {
        return modifier(DebugVerticalAlignmentGuideModifier(verticalAlignment: verticalAlignment))
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.body.pointSize(60))
    .debugAlignmentGuide(.topLeading)
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(60))
    .debugAlignmentGuide(.centerCenter)
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(60))
    .debugAlignmentGuide(.trailingLastTextBaseline)
    .border(.green.tertiary, width: 8)
}


#Preview("Horizontal", traits: .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(horizontal: .leading)
    .debugAlignmentGuide(horizontal: .center, extend: -50)
    .debugAlignmentGuide(horizontal: .trailing, extend: 50)
    .border(.green.tertiary, width: 8)
}


#Preview("Horizontal Anchored", traits: .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(horizontal: .leading, extend: 50, anchor: .top)
    .debugAlignmentGuide(horizontal: .center, extend: 50, anchor: .firstTextBaseline)
    .debugAlignmentGuide(horizontal: .trailing, extend: 50, anchor: .bottom)
    .border(.green.tertiary, width: 8)
}


#Preview("Vertical", traits: .fixedHeader, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(vertical: .top)
    .debugAlignmentGuide(vertical: .firstTextBaseline)
    .debugAlignmentGuide(vertical: .verticalCenter)
    .debugAlignmentGuide(vertical: .lastTextBaseline)
    .debugAlignmentGuide(vertical: .bottom)
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Sphinx\nof Black\nQuartz")
    .font(.largeTitle)
    .debugAlignmentGuide(vertical: .top)
    .debugAlignmentGuide(vertical: .firstTextBaseline)
    .debugAlignmentGuide(vertical: .verticalCenter)
    .debugAlignmentGuide(vertical: .lastTextBaseline)
    .debugAlignmentGuide(vertical: .bottom)
    .border(.green.tertiary, width: 8)
}

