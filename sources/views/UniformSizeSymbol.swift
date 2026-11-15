//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


// FIXME: Add tests.
// TODO: Check what happens to the accessibility label of a label with this style.


/// A view that displays a symbol image framed in an uniform symbol square size.
///
/// This view places the displayed image in an overlay with a fixed size based on the `circle`
/// symbol, and aligned to `centerFirstTextBaseline`. The result is a system symbol that is always
/// laid out with a uniform size, irregardless of the size of the displayed symbol.
///
/// The displayed image uses the environment font, foreground style, image scale, and related
/// modifiers.
///
/// Based on: https://trailing-closure.com/2026/intricacies-of-circular-buttons.
public struct UniformSizeSymbol<Content>: View where Content: View {

    private let content: () -> Content


    /// Creates a view displaying a system symbol image.
    ///
    /// - Parameter systemName: The name of the system symbol image.
    public init(systemName: String) where Content == Image {
        self.content = { Image(systemName: systemName) }
    }


    /// Creates a view displaying the given content as a symbol image.
    ///
    /// The displayed content is not required to be a symbol image, but it will be displayed
    /// aligned to the uniform symbol size.
    ///
    /// - Parameter content: The symbol image content.
    public init(@ContentBuilder content: @escaping () -> Content) {
        self.content = content
    }


    /// Creates a view displaying the given content as a symbol image.
    ///
    /// The displayed content is not required to be a symbol image, but it will be displayed
    /// aligned to the uniform symbol size.
    ///
    /// - Parameter content: The symbol image content.
    public init(content: Content) {
        self.content = { content }
    }


    @_documentation(visibility: internal)
    public var body: some View {
        SquareFillLayout {
            Image(systemName: "circle")
        }
        .hidden()
        .overlay(alignment: .centerFirstTextBaseline) {
            content()
        }
        .contentShape(.circle)
    }

}


/// Lays out its contents in a square frame, with content filling the square.
///
/// The side length of the frame is the shortest dimension of the content. All content is centered
/// in the frame and overflows along its longer axis.
private struct SquareFillLayout: Layout {

    // FIXME: Have layout get the smallest length of all subviews, not just the first.
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        guard let subview = subviews.first else { return .zero }
        let size = subview.sizeThatFits(proposal)
        let side = min(size.width, size.height)
        return CGSize(width: side, height: side)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        subviews.first?.place(
            at: CGPoint(x: bounds.midX, y: bounds.midY),
            anchor: .center,
            proposal: proposal
        )
    }
}


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing) {
    // TODO: Collection Extension method .appending(contentsOf:) that returns a collection view.
    let imageNames = Image.awkwardSizeSystemImageNames + ["ladybug", "circle"]
    // TODO: This could use ForEach(items:) if public.
    ForEach(imageNames, id: \.self) { imageName in
        UniformSizeSymbol(systemName: imageName)
        .floatingCaption(alignment: .outerTrailingTop, .colorStyle(.cyan), .size)
    }

    DashedDivider()

    HStack(items: imageNames, spacing: 8) { imageName in
        UniformSizeSymbol(content: Image(systemName: imageName))
    }
    .debugAlignmentGuide(vertical: .firstTextBaseline)
    .font(.title)
}


// MARK: Sizes
#Preview("Sizes") {
    let imageNames = Image.awkwardSizeSystemImageNames + ["ladybug", "circle"]
    HStack(items: imageNames, spacing: 8) { imageName in
        UniformSizeSymbol {
            Image(systemName: imageName)
            .background(.orange.secondary)
        }
        .border(.teal.secondary, width: 3)
    }
    .debugAlignmentGuide(vertical: .firstTextBaseline)
    .font(.largeTitle)
}


// MARK: SquareFillLayout
#Preview("SquareFillLayout", traits: .spacing(20)) {
    // FIXME: Dry.
    Image(systemName: "circle")
    .floatingCaption("Circle Image", alignment: .outerTrailing, .colorStyle(.teal), .size)

    SquareFillLayout {
        Image(systemName: "circle")
    }
    .floatingCaption("Square Layout", alignment: .outerTrailing, .colorStyle(.teal), .size)

    Image(systemName: "guidepoint.vertical")
    .floatingCaption("Guidepoint Image", alignment: .outerTrailing, .colorStyle(.teal), .size)

    SquareFillLayout {
        Image(systemName: "guidepoint.vertical")
    }
    .floatingCaption("Square Layout", alignment: .outerTrailing, .colorStyle(.teal), .size)

    Image(systemName: "guidepoint.horizontal")
    .floatingCaption("Guidepoint Image", alignment: .outerTrailing, .colorStyle(.teal), .size)

    SquareFillLayout {
        Image(systemName: "guidepoint.horizontal")
    }
    .floatingCaption("Square Layout", alignment: .outerTrailing, .colorStyle(.teal), .size)
}


extension Image {

    static let awkwardSizeSystemImageNames: [String] = [
        "guidepoint.horizontal",
        "guidepoint.vertical",
        "minus",
        "photo.badge.shield.exclamationmark",
        "clock.badge.airplane"
    ]

}
