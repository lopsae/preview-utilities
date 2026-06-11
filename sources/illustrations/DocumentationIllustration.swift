//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Wraps content for rendering an illustration generated from a SwiftUI view body.
public struct DocumentationIllustration: View {

    static var defaultWidth: CGFloat { 400 }

    let size: CGSize
    let drawsBorder: Bool
    let content: AnyView

    // FIXME: replace with a size .height, that uses the default width.
    public init<Content: View>(
        height: CGFloat,
        drawsBorder: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.size = [Self.defaultWidth, height]
        self.drawsBorder = drawsBorder
        self.content = AnyView(content())
    }


    public init<Content: View>(
        size: CGSize,
        drawsBorder: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.size = size
        self.drawsBorder = drawsBorder
        self.content = AnyView(content())
    }


    public init<Content: View>(
        sizing: Sizing,
        drawsBorder: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.size = sizing.size
        self.drawsBorder = drawsBorder
        self.content = AnyView(content())
    }


    @_documentation(visibility: internal)
    public var body: some View {
        VStack {
            content
        }
        .frame(size: size)
        .background(.background, in: .rect)
        .border(.tertiary, width: drawsBorder ? 1 : .zero)
    }

}


extension DocumentationIllustration {

    /// Size in points of a documentation illustration.
    ///
    /// This structure contains static members with the recommended sizes for illustrations, like
    /// ``regular`` or ``card``.
    public struct Sizing {

        let size: CGSize

        init(size: CGSize) {
            self.size = size
        }

        init(_ width: CGFloat, _ height: CGFloat) {
            self.size = CGSize(width: width, height: height)
        }

        var half: Self {
            let halfSize = size.multiplying(by: 0.5)
            return .init(size: halfSize)
        }

        /// Size for card illustrations.
        ///
        /// This is the expected size for images setup with the `@PageImage(purpose: card, [...])`
        /// Docc directive. Use `card.half` to create illustrations with a zoomed in effect.
        public static let card: Self = .init(640, 360)

        /// Regular size for snippet illustrations
        ///
        /// This illustration size uses the default width (`400`) and an aspect ration of `5/2`.
        public static let regular: Self = .init(DocumentationIllustration.defaultWidth, 160)
    }

}


// MARK: - Preview Trait


extension PreviewTrait where T == Preview.ViewTraits {

    /// Applies the preview traits needed for documentation illustration.
    public static var docsIllustration: PreviewTrait {
        .sizeThatFitsLayout
    }

}


// MARK: - Previews


#Preview("Default", traits: .docsIllustration) {
    DocumentationIllustration(sizing: .regular) {
        Text("Documentation Illustration")
    }
    .padding()
}


#Preview("Card", traits: .docsIllustration) {
    DocumentationIllustration(sizing: .card.half) {
        // Half card is 320 x 180.
        // Recommended content size is 220 x 100.
        // Distance from edge is 50 x 40.
        ZStack {
            // FUTURE: A expanding view that supports drawing guidelines inset of any edge or alignment.
            ClearRectangle()
            .overlay(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    DashedDivider(axis: .horizontal)
                    Text("40")
                    .font(.caption.pointSize(8))
                    .foregroundStyle(.secondary)
                    .padding(.leading, 2)
                }
                .alignmentGuide(.top, insetBy: 40)
            }
            .overlay(alignment: .leading) {
                HStack(alignment: .top, spacing: 2) {
                    DashedDivider(axis: .vertical)
                    Text("50")
                    .font(.caption.pointSize(8))
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
                }
                .alignmentGuide(.leading, insetBy: 50)
            }
            CaptionRectangle("Api Collection Card", color: .orange, size: [220, 100], traits: .size)
        }

    }
    .padding()
}


#Preview("Size", traits: .docsIllustration) {
    DocumentationIllustration(size: [160, 160]) {
        Text("Custom Size\nIllustration")
    }
    .padding()
}


#Preview("NoBorder", traits: .docsIllustration) {
    DocumentationIllustration(sizing: .regular, drawsBorder : false) {
        Text("No Border Illustration")
    }
    .padding()
}
