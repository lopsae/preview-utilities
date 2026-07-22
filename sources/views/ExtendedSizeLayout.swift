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
///
/// - Note: This layout is not proposal-stable, it proposes and lays out its views in a size larger
///   that the received proposal. In some cases where the layout operations are performed more that
///   once, the subviews may end with multiples of the size additions. See the file previews for
///   an example.
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
        // TODO: Replace with debugAlignmentGuide when it has support for labels.
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
        // TODO: Replace with debugAlignmentGuide when it has support for labels.
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


#Preview("Overlay with Issue", traits: .fixedHeader, PreviewContent.layout) {
    PreviewCaption("""
        If `ExtendedSizeLayout` is placed within subviews that perform the layout operation more
        that once, the proposed size might be reused, causing the layout to increase the size of the
        subviews multiple times.
        """)
    Text("Ag")
    .font(.title.pointSize(100))
    .overlay(alignment: .trailing) {
        let string = "one"
        Group {
            switch string {
            case "one":
                ExtendedSizeLayout(addHeight: 50) {
                    AxialLine(.vertical, style: .red.secondary, lineWidth: 4)
                }
            default:
                Text("Not used")
            }
        }
        .debugOverlay(.height, .alignment(.outerTrailing))
    }
    .debugOverlay(.hairline, .height, .alignment(.outerBottomTrailing))
}


// MARK: - OverflowSizeLayout


/// A layout that places its subviews with a size extended from its proposed size, while occupying
/// only the un-extended size.
///
/// Subviews of this layout are placed with a size extended by a given width and height from their
/// own size, however the layout itself reports the un-extended size of its subviews. The extension
/// overflows the layout bounds, drawing outside of them without displacing any surrounding views.
///
/// Unlike `ExtendedSizeLayout`, this layout is stable under repeated measurement: proposing back
/// the size reported by `sizeThatFits` returns that same size. This makes it safe in containers
/// that may measure a view more than once, like `overlay` with conditional content, where
/// `ExtendedSizeLayout` inflates by its additions on each measurement pass.
///
/// The subviews are arranged centered with each other, each overflowing equally in both
/// directions of the extended dimensions.
nonisolated
struct OverflowSizeLayout: Layout {

    let widthAddition: CGFloat
    let heightAddition: CGFloat

    init(addWidth: CGFloat = .zero, addHeight: CGFloat = .zero) {
        self.widthAddition = addWidth
        self.heightAddition = addHeight
    }

    /// Reports only the envelope of the subviews, without the additions, keeping the reported
    /// size idempotent under re-measurement.
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
        return containerSize
    }


    /// Each subview is measured individually and placed with its own size extended by the
    /// additions, overflowing the layout bounds.
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        // Using `bounds` instead of `proposal` keeps placement consistent with the size reported
        // by `sizeThatFits`, and avoids handling undefined or infinite proposal dimensions.
        let contentProposal = ProposedViewSize(bounds.size)

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


#Preview("Overlay Overflow", traits: .fixedHeader, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .overlay(alignment: .trailing) {
        let string = "one"
        Group {
            switch string {
            case "one":
                OverflowSizeLayout(addHeight: 50) {
                    AxialLine(.vertical, style: .red.secondary, lineWidth: 4)
                }
            default:
                AxialLine(.vertical, style: .red.secondary, lineWidth: 4)
            }

        }
        .debugOverlay(.height, .alignment(.outerTrailing))

    }
    .debugOverlay(.hairline, .height, .alignment(.outerBottomTrailing))
}


#Preview("Overlay Geometry", traits: .fixedHeader, PreviewContent.layout) {
    PreviewCaption("""
        `GeometryReader` can also be used to achieve the same behavior as `ExtendedSizeLayout`.
        """)
    Text("Ag")
    .font(.title.pointSize(100))
    .overlay(alignment: .trailing) {
        let string = "one"
        Group {
            switch string {
            case "one":
                GeometryReader { geometry in
                    AxialLine(.vertical, style: .red.secondary, lineWidth: 4)
                    .frame(length: geometry.size.height + 20, along: .vertical)
                    .frame(length: geometry.size.height, along: .vertical, alignment: .topTrailing)
                }
                .frame(length: 2, along: .horizontal)
            default:
                Text("Not Used")
            }
        }
        .debugOverlay(.height, .alignment(.outerTrailing))
    }
    .debugOverlay(.hairline, .height, .alignment(.outerBottomTrailing))
}

