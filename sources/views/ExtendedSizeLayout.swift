//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// A layout that always places its subviews with a size extended from its proposed view.
///
/// Subviews of this layout are always placed with a size extended by a given width and height from
/// its proposed size. This has the practical effect of adding spacing similar to a padding around
/// the subviews that have an ideal size. For views that can expand their width or height, the view
/// can use the expanded placement size, drawing outside of its proposed size.
///
/// The subviews are arranged centered with each other.
nonisolated
struct ExtendedSizeLayout: Layout {

    let widthAddition: CGFloat
    let heightAddition: CGFloat


    init(addWidth: CGFloat = .zero, addHeight: CGFloat = .zero) {
        self.widthAddition = addWidth
        self.heightAddition = addHeight
    }


    /// Reports the extended size so the extension is reserved in layout space, similar to
    /// padding. The envelope of all subviews plus additions is equal to the maximum size all views
    /// will take in `placeSubviews`.
    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        var containerSize: CGSize = .zero
        for subview in subviews {
            let size = subview.sizeThatFits(proposal)
            containerSize.envelop(size)
        }
        let extended = containerSize.adding(width: widthAddition, height: heightAddition)
        return extended
    }


    /// Each subview is measured individually and placed with its own size extended by the
    /// additions, so multiple subviews each expand relative to their own size.
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        // Un-extended size, recovered from the concrete bounds. Using `bounds` instead of
        // `proposal` keeps placement consistent with the size reported by `sizeThatFits`, and
        // avoids handling undefined or infinite proposal dimensions.
        let contentSize = bounds.size.adding(width: -widthAddition, height: -heightAddition)
        let contentProposal = ProposedViewSize(contentSize)

        for subview in subviews {
            let subviewSize = subview.sizeThatFits(contentProposal)
            let extendedSize = subviewSize.adding(width: widthAddition, height: heightAddition)
            subview.place(
                at: bounds.center,
                anchor: .center,
                proposal: ProposedViewSize(extendedSize)
            )
        }
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing, .fixedHeaderFooter, PreviewContent.layout) {
    PreviewCaption("""
        Subviews of the `ExtendedSizeLayout` are always placed with a size extended from the 
        proposed size.
        """)
    .paragraph("""
        This behavior is similar to adding padding to a view, with the difference that it allows
        the view to use the extended space, for example a `Rectangle` will draw in the extended
        size.
        """)

    HStack(spacing: .zero) {
        ExtendedSizeLayout(addWidth: 100) {
            Text("Extended\nWidth")
            .floatingCaption("Text", .colorStyle(.green), .alignment(.outerTop))
        }
        .floatingCaption("Layout", .colorStyle(.blue), .alignment(.outerBottom))
        .padding()

        Text("Text")
    }
    .floatingCaption("HStack", .colorStyle(.purple), .alignment(.outerBottomTrailing))

    DashedDivider()
    .padding(.vertical)

    VStack(spacing: .zero) {
        ExtendedSizeLayout(addHeight: 60) {
            Text("Extended\nHeigth")
            .floatingCaption("Text", .colorStyle(.green), .alignment(.outerLeading))
        }
        .floatingCaption("Layout", .colorStyle(.blue), .alignment(.outerTrailing))
        .padding()

        Text("Text")
    }
    .floatingCaption("VStack", .colorStyle(.purple), .alignment(.outerBottomTrailing))

    DashedDivider()
    .padding(.vertical)

    HStack(spacing: .zero) {
        ExtendedSizeLayout(addWidth: 100, addHeight: 60) {
            Text("Extended\nSize")
            .floatingCaption("Text", .colorStyle(.green), .alignment(.outerTop))
        }
        .floatingCaption("Layout", .colorStyle(.blue), .alignment(.outerBottom))
        .padding()

        Text("Text")
    }
    .floatingCaption("HStack", .colorStyle(.purple), .alignment(.outerBottomTrailing))

    VisibleSpacer()

}


#Preview("Width", traits: .fixedHeader, PreviewContent.layout) {
    VStack(alignment: .leading) {
        ExtendedSizeLayout(addWidth: 50) {
            Rectangle()
            .fill(.indigo)
            .frame(height: 20)
        }
        .alignmentGuide(.leading, offsetBy: 20)
        .floatingCaption("Extended", .width, .captionStyle(.indigo), .alignment(.outerTopTrailing))

        ExtendedSizeLayout(addWidth: 50) {
            Rectangle()
            .fill(.indigo)
            .frame(height: 20)
        }
        // FIXME: try to use debugAlignmentGuide
        .overlay(alignment: .leading) {
            ZStack(alignment: .leading) {
                Rectangle()
                .fill(.red.secondary)
                .frame(width: 4)

                TransposeLayout {
                    Text("Leading")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .maxWidthFrame(alignment: .leading)
                    .rotationEffect(.turn(-1/4))
                }
                .padding(.leading, 4)
                .padding(.bottom, 4)
            }
            .frame(height: 200)
        }

        ExtendedSizeLayout(addWidth: 50) {
            Rectangle()
            .fill(.indigo)
            .frame(height: 20)
        }
        .alignmentGuide(.leading, offsetBy: -20)
    }
    .floatingCaption("VStack", .colorStyle(.purple), .alignment(.outerBottomTrailing))
    .frame(squareOf: 200, alignment: .leading)
    .debugOverlay(.hairline, .width, .alignment(.bottomTrailing))
}


#Preview("Height", traits: .fixedHeader, PreviewContent.layout) {
    HStack(alignment: .top) {
        ExtendedSizeLayout(addHeight: 50) {
            Rectangle()
            .fill(.indigo)
            .frame(width: 20)
        }
        .alignmentGuide(.top, offsetBy: 20)
        .floatingCaption("Extended", .height, .captionStyle(.indigo), .alignment(.outerLeadingBottom))

        ExtendedSizeLayout(addHeight: 50) {
            Rectangle()
            .fill(.indigo)
            .frame(width: 20)
        }
        // FIXME: try to use debugAlignmentGuide
        .overlay(alignment: .top) {
            ZStack(alignment: .top) {
                Rectangle()
                .fill(.red.secondary)
                .frame(height: 4)

                Text("Top")
                .font(.caption)
                .foregroundStyle(.red)
                .maxWidthFrame(alignment: .trailing)
                .padding(.trailing, 4)
                .padding(.top, 4)
            }
            .frame(width: 200)
        }

        ExtendedSizeLayout(addHeight: 50) {
            Rectangle()
            .fill(.indigo)
            .frame(width: 20)
        }
        .alignmentGuide(.top, offsetBy: -20)
    }
    .floatingCaption("HStack", .colorStyle(.purple), .alignment(.outerTrailingBottom))
    .frame(squareOf: 200, alignment: .top)
    .debugOverlay(.hairline, .height, .alignment(.outerBottomTrailing))
}


#Preview("Multiple", traits: .fixedHeader, PreviewContent.layout) {
    ExtendedSizeLayout(addWidth: 50, addHeight: 50) {
        Rectangle()
        .fill(.indigo.secondary)
        .frame(height: 20)
        .floatingCaption("Fixed Height", .width, .captionStyle(.purple), .alignment(.outerBottomTrailing))

        Rectangle()
        .fill(.indigo.secondary)
        .frame(width: 20)
        .floatingCaption("Fixed Width", .height, .captionStyle(.purple), .alignment(.outerTrailingTop))
    }
    .frame(squareOf: 200)
    .debugOverlay(.hairline, .size, .alignment(.outerBottomTrailing))

}
