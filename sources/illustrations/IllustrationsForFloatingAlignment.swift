//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct IllustrationsForFloatingAlignment {

    /// Illustration of ``FloatingAlignment`` examples.
    static var alignmentExamples: DocumentationIllustration {
        DocumentationIllustration(height: 160) {
            Rectangle()
            .fill(.orange.gradient.secondary)
            .frame(size: [260, 80])
            .overlay {
                FloatingAlignedContainer(
                    alignment: .outerTopLeading,
                    horizontalSpacing: .zero,
                    verticalSpacing: 2
                ) { contentAlignments in
                    Text("Content aligned to\nOuter Top Leading")
                    .font(.caption)
                    .multilineTextAlignment(contentAlignments.text)
                }
                FloatingAlignedContainer(
                    alignment: .innerBottomTrailing,
                    spacing: 2
                ) { contentAlignments in
                    Text("Content aligned to\nInner Bottom Trailing")
                    .font(.caption)
                    .multilineTextAlignment(contentAlignments.text)
                }
            }
            .offset(y: 10)
        }
    }

    /// Illustration of the inner alignments of ``FloatingAlignment``.
    ///
    /// Intended for a height of 240.
    @ViewBuilder static var innerAlignments: some View {
        HStack {
            ForEach(FloatingAlignment.HorizontalAlignment.allCases) { horizontalAlignment in
                Rectangle()
                    .fill(.orange.gradient.secondary)
                .frame(size: [100, 140])
                .overlay {
                    ForEach(FloatingAlignment.VerticalAlignment.allCases) { verticalAlignment in
                        let alignment: FloatingAlignment = .inner(.init(
                            horizontal: horizontalAlignment,
                            vertical: verticalAlignment
                        ))
                        let alignmentName = alignment.displayNameComponents
                            .suffix(2)
                            .map(formatting: .capitalized)
                            .joined(separator: "\n")

                        FloatingAlignedContainer(
                            alignment: alignment,
                            spacing: 4
                        ) { contentAlignments in
                            Text.caption("\(alignmentName)")
                                .multilineTextAlignment(contentAlignments.text)
                        }
                    }
                }
            }
        }
        .overlay {
            FloatingAlignedContainer(
                alignment: .outerTopLeading,
                horizontalSpacing: .zero,
                verticalSpacing: 4
            ) { contentAlignments in
                Text.caption("Inner Alignments")
                    .foregroundStyle(.orange)
            }
        }
    }


    /// Illustration of the outer alignments of ``FloatingAlignment``.
    static var outerAlignments: DocumentationIllustration {
        DocumentationIllustration(height: 300) {
            Rectangle()
            .fill(.orange.gradient.secondary)
            .frame(size: [200, 140])
            .overlay {
                ForEach(FloatingAlignment.HorizontalAlignment.allCases) { horizontalAlignment in
                    let alignments = FloatingAlignment.allCases(withHorizontal: horizontalAlignment)
                        .filter { $0.key == .outer }
                    ForEach(alignments) { alignment in
                        let alignmentName = alignment.displayNameComponents
                            .suffix(2)
                            .map(formatting: .capitalized)
                            .joined(separator: "\n")

                        FloatingAlignedContainer(
                            alignment: alignment,
                            spacing: 4
                        ) { contentAlignments in
                            Text.caption("\(alignmentName)")
                                .multilineTextAlignment(contentAlignments.text)
                        }
                    }
                } // ForEach

                FloatingAlignedContainer(
                    alignment: .center,
                    spacing: 4
                ) { contentAlignments in
                    Text.caption("Outer Alignments")
                        .foregroundStyle(.orange)
                }

                // Dashed dividers.
                FloatingAlignedContainer(alignment: .top, spacing: .zero) { contentAlignments in
                    DashedDivider().frame(width: 340)
                }
                FloatingAlignedContainer(alignment: .bottom, spacing: .zero) { contentAlignments in
                    DashedDivider().frame(width: 340)
                }
                FloatingAlignedContainer(alignment: .leading, spacing: .zero) { contentAlignments in
                    DashedDivider(axis: .vertical).frame(height: 240)
                }
                FloatingAlignedContainer(alignment: .trailing, spacing: .zero) { contentAlignments in
                    DashedDivider(axis: .vertical).frame(height: 240)
                }
            } // overlay
        } // DocumentationIllustration
    }

}


// MARK: Previews


#Preview("alignment-examples", traits: .docsIllustration) {
    IllustrationsForFloatingAlignment.alignmentExamples
}


#Preview("inner-alignments", traits: .docsRender(height: 240)) {
    IllustrationsForFloatingAlignment.innerAlignments
}


#Preview("outer-alignments", traits: .docsIllustration) {
    IllustrationsForFloatingAlignment.outerAlignments
}
