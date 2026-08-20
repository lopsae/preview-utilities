//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct CardIllustrations {

    /// The recommended content size for cards using a `card.half` sizing.
    ///
    /// A half card is 320 x 180, and the recommended content size is 220 x 100.
    /// The content distance from the edge is 50 x 40.
    static let contentSize: CGSize = [220, 100]


    /// Recommended card layout.
    static var recommended: DocumentationIllustration {
        DocumentationIllustration(sizing: .card.half) {
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
                CaptionRectangle(
                    "Recommended Content Size\nUsing `card.half`",
                    color: .orange, size: CardIllustrations.contentSize,
                    traits: .size
                )
            }

        }
    }


    static var debugAlignmentGuide: DocumentationIllustration {
        DocumentationIllustration(sizing: .card.half, drawsBorder: false) {
            Text("Ag")
            .fixedSize()
            .font(.largeTitle.pointSize(140))
//            .alignmentGuide(.bottom, outsetBy: 8)
//            .debugAlignmentGuide(vertical: .bottom)
            .frame(size: contentSize)
            .debugAlignmentGuide(
                .centerFirstTextBaseline,
                .length(horizontal: .extended(50))
            )
        }
    }


    static var floatingCaption: DocumentationIllustration {
        DocumentationIllustration(sizing: .card.half, drawsBorder: false) {
            RoundedRectangle(cornerRadius: 44)
                .fill(.tertiary)
            .frame(size: contentSize)
            .floatingCaption(
                "Floating Caption",
                .captionStyle(.purple),
                .borderStyle(.purple.secondary),
                .borderWidth(4),
                .alignment(.outerBottomTrailing)
            )
        }
    }


    static var formatStyles: DocumentationIllustration {
        DocumentationIllustration(sizing: .card.half, drawsBorder: false) {
            VStack {
                Text("alice, bob, carlos")
                    .monospaced()
                Image(systemName: "arrow.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("a, b, c")
                    .monospaced()
                Image(systemName: "arrow.down")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("A, B, C")
                    .monospaced()
            }
            .frame(size: [220, 100])
            .background {
                RoundedRectangle(cornerRadius: Defaults.padding / 3)
                .fill(.indigo.gradient.secondary)
            }

        }
    }

}


// MARK: Previews


#Preview("Recommended", traits: .docsIllustration) {
    CardIllustrations.recommended
    .padding()
}


#Preview("debugAlignmentGuide", traits: .docsIllustration) {
    CardIllustrations.debugAlignmentGuide
    .border(.quinary)
    .padding()
}


#Preview("floatingCaption", traits: .docsIllustration) {
    CardIllustrations.floatingCaption
    .border(.quinary)
    .padding()
}


#Preview("formatStyles", traits: .docsIllustration) {
    CardIllustrations.formatStyles
    .border(.quinary)
    .padding()
}
