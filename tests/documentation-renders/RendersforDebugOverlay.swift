//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities


import SwiftUI
import Testing


/// Rendering functions for documentation images for `DebugOverlayModifier`.
///
/// Each test produces an image saved to the package documentation catalog.
///
/// This file MUST NOT have internal access to the `PreviewUtilities` package, since the code in
/// each function is also used in code snippets.
@Suite(.tags(.documentationRender))
struct RendersForDebugOverlay {

    @Test(.tags(.documentationRender))
    func `default`() throws {
        try DocumentationResources.renderAndStore("debug-overlay", "default") {
            DocumentationIllustration(height: 160) {
                Text("Sphinx of Black Quartz")
                    .font(.title)
                Text("Judge my Vow")
                    .font(.title)
                    .debugOverlay()
            }
        }
    }


    @Test(.tags(.documentationRender))
    func simpleTraits() throws {
        try DocumentationResources.renderAndStore("debug-overlay", "simple-traits") {
            DocumentationIllustration(height: 160) {
                Rectangle()
                .fill(.yellow.gradient.secondary)
                .frame(width: 200, height: 80)
                .debugOverlay(
                    .size,                     // prints the size of the parent view
                    .bordersWidth(2),          // sets debug borders width to 2
                    .alignment(.innerTrailing) // aligns caption to trailing-center
                )
            }
        }
    }


    @Test(.tags(.documentationRender))
    func alignments() throws {
        try DocumentationResources.renderAndStore("debug-overlay", "alignments") {
            DocumentationIllustration(height: 180) {
                HStack(spacing: 16) {
                    Rectangle()
                        .fill(.green.gradient)
                        .frame(width: 100, height: 60)
                        .debugOverlay(.caption("Inner Top"), .alignment(.innerTop))
                    Rectangle()
                        .fill(.mint.gradient)
                        .frame(width: 100, height: 60)
                        .debugOverlay(.caption("Outer Bottom\nLeading"), .alignment(.outerBottomLeading))
                    Rectangle()
                        .fill(.teal.gradient)
                        .frame(width: 100, height: 60)
                        .debugOverlay(.caption("Outer Top\nTrailing"), .alignment(.outerTopTrailing))
                }
            }
        }
    }


    @Test(.tags(.documentationRender))
    func torchDefault() throws {
        try DocumentationResources.renderAndStore("debug-overlay", "torch-default") {
            DocumentationIllustration(height: 100) {
                Text("a sort of splendid torch")
                    .debugOverlay()
                Text("which I have got hold of for the moment")
            }
        }
    }


    @Test(.tags(.documentationRender))
    func torchTraits() throws {
        try DocumentationResources.renderAndStore("debug-overlay", "torch-traits") {
            DocumentationIllustration(height: 100) {
                Text("a sort of splendid torch")
                    .debugOverlay(.width, .alignment(.outerTop))
                Text("which I have got hold of for the moment")
            }
        }
    }

}
