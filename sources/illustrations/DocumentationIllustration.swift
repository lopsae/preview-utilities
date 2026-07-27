//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Wraps content for rendering an illustration generated from a SwiftUI view body.
public struct DocumentationIllustration: View {

    let size: CGSize
    let drawsBorder: Bool
    let alignment: Alignment
    let content: AnyView
    let background: AnyView

    // FIXME: replace with a size .height, that uses the default width.
    public init<Content: View>(
        height: CGFloat,
        drawsBorder: Bool = true,
        alignment: Alignment = .center,
        background: Background = .emptyView,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.size = Sizing.height(height).size
        self.alignment = alignment
        self.drawsBorder = drawsBorder
        self.content = AnyView(content())
        self.background = background.makeView()
    }


    public init<Content: View>(
        size: CGSize,
        alignment: Alignment = .center,
        drawsBorder: Bool = true,
        background: Background = .emptyView,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.size = size
        self.alignment = alignment
        self.drawsBorder = drawsBorder
        self.content = AnyView(content())
        self.background = background.makeView()
    }


    public init<Content: View>(
        sizing: Sizing,
        alignment: Alignment = .center,
        drawsBorder: Bool = true,
        background: Background = .emptyView,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.size = sizing.size
        self.alignment = alignment
        self.drawsBorder = drawsBorder
        self.content = AnyView(content())
        self.background = background.makeView()
    }


    @_documentation(visibility: internal)
    public var body: some View {
        VStack {
            content
        }
        .frame(size: size, alignment: alignment)
        .background { background }
        .background(.background, in: .rect)
        .border(.tertiary, width: drawsBorder ? .one : .zero)
    }

}


// MARK: - Sizing


extension DocumentationIllustration {

    /// Size in points of a documentation illustration.
    ///
    /// This structure contains static members with the recommended sizes for illustrations, like
    /// ``regular`` or ``card``.
    public struct Sizing {

        /// The default width for illustrations of `regular` size.
        ///
        /// Sizes like ``regular`` and functions like ``height(_:)`` use this default width.
        public static var defaultWidth: CGFloat = 400

        let size: CGSize

        init(size: CGSize) {
            self.size = size
        }

        init(height: CGFloat) {
            self.size = CGSize(
                width: Self.defaultWidth,
                height: height
            )
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
        /// This illustration size uses the ``defaultWidth`` (`400`) and an aspect ration of `5/2`.
        public static let regular: Self = .init(height: 160)

        /// Size for snippet illustrations with the default width and a given height.
        ///
        /// This illustration size uses the ``defaultWidth`` (`400`).
        public static func height(_ illHeight: CGFloat) -> Self {
            .init(height: illHeight)
        }

    }

}


// MARK: - Background


extension DocumentationIllustration {

    /// A background for a ``DocumentationIllustration``.
    ///
    /// Use a predefined background such as ``moltenHorizonMesh``, define your own as a static
    /// member in an extension, or wrap an arbitrary view with ``view(_:)``.
    public struct Background {

        let makeView: @MainActor () -> AnyView

        init(_ makeView: @escaping @MainActor () -> some View) {
            self.makeView = {
                let view = makeView()
                return AnyView(view)
            }
        }

    }

}


extension DocumentationIllustration.Background {

    /// An empty background.
    public static var emptyView: Self {
        .init { EmptyView() }
    }

    /// A background that uses the given view.
    /// - Parameter view: The view to use as the background.
    public static func view(_ view: @autoclosure @escaping @MainActor () -> some View) -> Self {
        .init { view() }
    }

    /// A mesh gradient background.
    public static var moltenHorizon: Self {
        .init { PrettyMesh.moltenHorizon.rotated() }
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
        CaptionRectangle("Api Collection Card\nUsing `half` size", color: .orange)
        .padding(40)
    }
    .padding()
}


#Preview("Background", traits: .docsIllustration) {
    DocumentationIllustration(sizing: .regular, background: .moltenHorizon) {
        Text("Documentation Illustration\nWith Background")
    }
    .padding()
}


#Preview("Aligned", traits: .docsIllustration) {
    DocumentationIllustration(sizing: .regular, alignment: .top) {
        Text("Top Aligned Content")
        Text("with regular sizing")
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
    .background(.quinary)
}
