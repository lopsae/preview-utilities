//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct DebugHorizontalAlignmentGuideModifier: ViewModifier {

    let horizontalAlignment: HorizontalAlignment

    func body(content: Content) -> some View {
        let alignment = Alignment(horizontal: horizontalAlignment, vertical: .center)
        content.overlay(alignment: alignment) {
            Rectangle()
            .fill(.red.secondary)
            .frame(width: 2)
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

    public func debugAlignmentGuide(_ horizontalAlignment: HorizontalAlignment) -> some View {
        return modifier(DebugHorizontalAlignmentGuideModifier(horizontalAlignment: horizontalAlignment))
    }


    public func debugAlignmentGuide(_ verticalAlignment: VerticalAlignment) -> some View {
        return modifier(DebugVerticalAlignmentGuideModifier(verticalAlignment: verticalAlignment))
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Horizontal", traits: .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(.leading)
    .debugAlignmentGuide(.horizontalCenter)
    .debugAlignmentGuide(.trailing)
    .border(.green.tertiary, width: 8)
}


#Preview("Vertical", traits: .fixedHeader, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(.top)
    .debugAlignmentGuide(.firstTextBaseline)
    .debugAlignmentGuide(.verticalCenter)
    .debugAlignmentGuide(.lastTextBaseline)
    .debugAlignmentGuide(.bottom)
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Sphinx\nof Black\nQuartz")
    .font(.largeTitle)
    .debugAlignmentGuide(.top)
    .debugAlignmentGuide(.firstTextBaseline)
    .debugAlignmentGuide(.verticalCenter)
    .debugAlignmentGuide(.lastTextBaseline)
    .debugAlignmentGuide(.bottom)
    .border(.green.tertiary, width: 8)
}

