//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import SwiftUI
import Testing


/// Rendering functions for documentation illustrations for `DebugAlignmentGuideModifier`.
///
/// Each test produces an image saved to the package documentation catalog.
///
/// This file MUST NOT have internal access to the `PreviewUtilities` package, since the code in
/// each function is also used in code snippets.
struct IllustrationsForDebugAlignmentGuideModifier {

    let storage: IllustrationStorage

    init() throws {
        self.storage = try DocumentationResources.storage
    }


    @Test func `default`() throws {
        try storage.renderAndStore("debug-alignment-guide", "default") {
            DocumentationIllustration(sizing: .regular) {
                Text("Sphinx of Black Quartz\nJudge my Vow")
                .font(.title)
                .debugAlignmentGuide(.leadingLastTextBaseline)
            }
        }
    }


    @Test func defaultSingleAxis() throws {
        try storage.renderAndStore("debug-alignment-guide", "default-single-axis") {
            DocumentationIllustration(sizing: .regular) {
                Text("Sphinx of Black Quartz\nJudge my Vow")
                .font(.title)
                .debugAlignmentGuide(horizontal: .trailing)
            }
        }
    }


    @Test func explainedTraits() throws {
        try storage.renderAndStore("debug-alignment-guide", "explained-traits") {
            DocumentationIllustration(sizing: .regular) {
                Text("Lately I saw a house.\nIt was burning.")
                .font(.title)
                .multilineTextAlignment(.center)
                .debugAlignmentGuide(.centerFirstTextBaseline,
                    .style(.mint.secondary),        // Styles both markers to mint.
                    .lineWidth(vertical: 8),        // Sets the vertical line width.
                    .extendedLength(horizontal: 40) // Extends the horizontal marker by 40.
                )
            }
        }
    }


    @Test func explainedTraitsSingleAxis() throws {
        try storage.renderAndStore("debug-alignment-guide", "explained-traits-single-axis") {
            DocumentationIllustration(sizing: .regular) {
                Text("Lately I saw a house.\nIt was burning.")
                .font(.title)
                .multilineTextAlignment(.center)
                .debugAlignmentGuide(
                    horizontal: .leading,
                    .style(.mint.secondary), // Styles markers to mint.
                    .lineWidth(8),           // Sets the line width.
                    .scaledLength(2)         // Scales the marker to double the owner size.
                )
            }
        }
    }


    @Test func simpleTraits() throws {
        try storage.renderAndStore("debug-alignment-guide", "simple-traits") {
            DocumentationIllustration(sizing: .regular) {
                Text("A new age\ndoes not begin all of a sudden")
                .font(.title)
                .multilineTextAlignment(.trailing)
                .debugAlignmentGuide(.trailingFirstTextBaseline,
                    .lineWidth(8),
                    .fixedLength(vertical: 200),
                    .anchor(.trailing)
                )
            }
        }
    }


    @Test func simpleTraitsSingleAxis() throws {
        try storage.renderAndStore("debug-alignment-guide", "simple-traits-single-axis") {
            DocumentationIllustration(sizing: .regular) {
                Text("Wisdom was passed on\nfrom mouth to mouth")
                .font(.title)
                .multilineTextAlignment(.center)
                .debugAlignmentGuide(vertical: .lastTextBaseline,
                    .lineWidth(8),
                    .scaledLength(1.2)
                )
            }
        }
    }


//    @Test func alignments() throws {
//        try storage.renderAndStore("debug-overlay", "alignments") {
//            DocumentationIllustration(height: 180) {
//                HStack(spacing: 16) {
//                    Rectangle()
//                        .fill(.green.gradient)
//                        .frame(width: 100, height: 60)
//                        .debugOverlay(.caption("Inner Top"), .alignment(.innerTop))
//                    Rectangle()
//                        .fill(.mint.gradient)
//                        .frame(width: 100, height: 60)
//                        .debugOverlay(.caption("Outer Bottom\nLeading"), .alignment(.outerBottomLeading))
//                    Rectangle()
//                        .fill(.teal.gradient)
//                        .frame(width: 100, height: 60)
//                        .debugOverlay(.caption("Outer Top\nTrailing"), .alignment(.outerTopTrailing))
//                }
//            }
//        }
//    }


//    @Test func torchTraits() throws {
//        try storage.renderAndStore("debug-overlay", "torch-traits") {
//            DocumentationIllustration(height: 100) {
//                Text("a sort of splendid torch")
//                    .debugOverlay(.width, .alignment(.outerTop))
//                Text("which I have got hold of for the moment")
//            }
//        }
//    }

}
