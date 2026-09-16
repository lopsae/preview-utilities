//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension GeometryReader {

    /// Creates a geometry reader with aligned content.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the content.
    ///   - content: The content to display.
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


/// View wrapped in a frame of fixed size.
///
/// Provides a concrete type for a view with a `frame(width:height:)` modifier.
///
/// Used to provide a concrete type for type constraints. When extending initializers of generic
/// types, the generic **must** be constrained to concrete type know at build time. Modifiers like
/// `frame()` cannot be used when those return an opaque `some View`.
struct FixedFrame<Content>: View where Content: View {
    let alignment: Alignment
    let size: CGSize
    @ViewBuilder let content: Content

    var body: some View {
        content
        .frame(size: size, alignment: alignment)
    }
}


/// Applies a fixed size frame to a given content.
///
/// This view is an example of a view doing a multi-view behavior: when `content` contains multiple
/// views, this view outputs multiple views as well. Each of the views given in `content` will be
/// individually framed.
///
/// Kept as an example of the previous behavior of FixedFrame.
private struct FramedGroup<Content>: View where Content: View {
    @ViewBuilder let content: Content
    var body: some View {
        content
        .frame(squareOf: 100)
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


#Preview("FixedFrame", traits: PreviewContent.layout) {
    FixedFrame(alignment: .center, size: .square(of: 100)) {
        Text("First")
        Text("Second")
    }
    .debugOverlay()

    Group {
        Text("First")
        Text("Second")
    }
    .frame(squareOf: 100)
    .debugOverlay()
    .border(.red)

}


#Preview("FramedGroup", traits: .fixedHeader, PreviewContent.layout) {
    PreviewCaption("""
        `FramedGroup` frames each subview in its own frame, since it outputs multiple views itself.
        """)
    FramedGroup {
        Text("First")
        Text("Second")
    }
    .border(.indigo)

    PreviewCaption("""
        Same behaviour as `Group`.
        """)
    Group {
        Text("First")
        Text("Second")
    }
    .frame(squareOf: 100)
    .border(.red)

}
