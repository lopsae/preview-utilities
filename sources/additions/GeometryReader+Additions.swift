//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension GeometryReader {

    /// Creates a geometry reader with aligned content.
    ///
    /// Each view in `content` is framed to the geometry proxy size. Alignment guide modifications
    /// act against this frame independently of the other subviews.
    ///
    /// - Parameters:
    ///   - alignment: The guide for aligning the content.
    ///   - content: The content to display.
    init<AlignedContent: View>(
        alignment: Alignment,
        @ViewBuilder content: @escaping (GeometryProxy) -> AlignedContent
    )
    where Content == FixedFrameGroup<AlignedContent>
    {
        self.init { geometry in
            FixedFrameGroup(alignment: alignment, size: geometry.size) {
                content(geometry)
            }
        }
    }

}


/// Views wrapped individually in a frame of fixed size.
///
/// Provides a concrete type for a group of views individually framed with a ``SwiftUICore/View/frame(size:)``
/// modifier.
///
/// Used to provide a concrete type for type constraints. When extending initializers of generic
/// types, the generic types **must** be constrained to concrete types know at build time. Modifiers
/// like `frame()` cannot be used directly when those return an opaque `some View`.
struct FixedFrameGroup<Content>: View where Content: View {
    let alignment: Alignment
    let size: CGSize
    @ViewBuilder let content: Content

    @_documentation(visibility: internal)
    var body: some View {
        // Frame is applied to each view in content individually.
        content.frame(size: size, alignment: alignment)
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


#Preview("FixedFrameAlignments", traits: PreviewContent.layout) {
    FixedFrameGroup(alignment: .center, size: .square(of: 100)) {
        Text("First")
        Text("Second")
        .alignmentGuide(.verticalCenter, offsetBy: -15)
    }
    .border(.indigo.secondary, width: 2)

    FixedFrameGroup(alignment: .topLeading, size: .square(of: 100)) {
        Text("First")
        Text("Second")
        .alignmentGuide(.top, insetBy: 15)
    }
    .border(.purple.secondary, width: 2)

    FixedFrameGroup(alignment: .bottomTrailing, size: .square(of: 100)) {
        Text("Outset")
        .alignmentGuide(.bottom, outsetBy: 20)
    }
    .border(.blue.secondary, width: 2)
}


#Preview("FixedFrameGroup", traits: .fixedHeader, PreviewContent.layout) {
    PreviewCaption("""
        `FixedFrameGroup` frames each subview in its own frame.
        """)
    FixedFrameGroup(alignment: .center, size: .square(of: 100)){
        Text("First")
        Text("Second")
    }
    .border(.indigo.secondary, width: 2)

    PreviewCaption("""
        Same behaviour as `Group`.
        """)
    Group {
        Text("First")
        Text("Second")
    }
    .frame(squareOf: 100)
    .border(.red.secondary, width: 2)
}


#Preview("AlignmentGuides", traits: .fixedHeader, PreviewContent.layout) {
    PreviewCaption("""
        Each view in `content` is aligned independently against its frame.
        """)

    GeometryReader(alignment: .top) { geometry in
        Text("First")
            .alignmentGuide(.horizontalCenter, moveTo: .leading)
        Text("Second")
            .alignmentGuide(.top, insetBy: 15)
        Text("Third")
            .alignmentGuide(.horizontalCenter, moveTo: .trailing, offsetBy: 10)
            .alignmentGuide(.top, insetBy: 30)

    }
    .debugAlignmentGuide(horizontal: .center)
    .border(.indigo.secondary, width: 2)

    PreviewCaption("""
        Stock `GeometryRender` does not use alignment guides for its layout.
        """)

    GeometryReader { geometry in
        Text("First")
            .alignmentGuide(.top, insetBy: 15)
        Text("Second")
            .alignmentGuide(.leading, insetBy: 15)
    }
    .border(.indigo.secondary, width: 2)
}
