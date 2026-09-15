//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension GeometryReader {

    init<AlignedContent: View>(
        alignment: Alignment,
        @ViewBuilder content: @escaping (GeometryProxy) -> AlignedContent
    )
    where Content == FixedFrame<AlignedContent>
    {
        self.init { geometry in
            FixedFrame(alignment: alignment, size: geometry.size) {
                content(geometry)
            }
        }
    }

}


struct FixedFrame<Content>: View where Content: View {
    let alignment: Alignment
    let size: CGSize
    @ViewBuilder let content: Content

    var body: some View {
        content
        .frame(size: size, alignment: alignment)
    }
}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeForcedLayout

}


// MARK: - Previews


#Preview("Default", traits: .spacing(100), PreviewContent.layout) {
    GeometryReader(alignment: .topLeading) { geometry in
        CaptionRectangle("Fixed Size", color: .brown, size: .square(of: 120), traits: .alignment(.outerBottomTrailing))
        CaptionRectangle("Geometry Size", color: .indigo, size: geometry.size, traits: .size, .alignment(.leading))
    }
    .frame(squareOf: 100)

    GeometryReader(alignment: .bottomTrailing) { geometry in
        CaptionRectangle("Fixed Size", color: .brown, size: .square(of: 120), traits: .alignment(.outerBottomTrailing))
        CaptionRectangle("Geometry Size", color: .indigo, size: geometry.size, traits: .size, .alignment(.leading))
    }
    .frame(squareOf: 100)

    GeometryReader(alignment: .center) { geometry in
        CaptionRectangle("Fixed Size", color: .brown, size: .square(of: 120), traits: .alignment(.outerBottomTrailing))
        CaptionRectangle("Geometry Size", color: .indigo, size: geometry.size, traits: .size, .alignment(.leading))
    }
    .frame(squareOf: 100)
}
