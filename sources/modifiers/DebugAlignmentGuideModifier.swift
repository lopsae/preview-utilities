//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct DebugVerticalAlignmentGuideModifier: ViewModifier {

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


// MARK: - View Extension


extension View {

    public func debugAlignmentGuide(_ horizontalAlignment: HorizontalAlignment) -> some View {
        return modifier(DebugVerticalAlignmentGuideModifier(horizontalAlignment: horizontalAlignment))
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
    .font(.title.pointSize(100))
    .debugAlignmentGuide(.leading)
    .debugAlignmentGuide(.center)
    .debugAlignmentGuide(.trailing)
    .border(.green.quinary, width: 4)
}

