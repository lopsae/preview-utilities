//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities


import SwiftUI
import Testing


/// Rendering functions for documentation images for `FloatingCaptionModifier`.
///
/// Each test produces an image saved to the package documentation catalog.
///
/// This file MUST NOT have internal access to the `PreviewUtilities` package, since the code in
/// each function is also used in code snippets.
@Suite(.tags(.documentationRender))
struct RendersForFloatingCaption {

    @Test(.tags(.documentationRender))
    func `default`() throws {
        try DocumentationResources.renderAndStore("floating-caption", "default") {
            DocumentationIllustration(height: 160) {
                HStack {
                    Rectangle()
                        .fill(.blue.gradient.secondary)
                        .frame(width: 80, height: 80)
                    Rectangle()
                        .fill(.indigo.gradient.secondary)
                        .frame(width: 80, height: 80)
                        .floatingCaption("A floating caption\noverflowing the parent view")
                }
            }
        }
    }


    @Test(.tags(.documentationRender))
    func traitsExplained() throws {
        try DocumentationResources.renderAndStore("floating-caption", "traits-explained") {
            DocumentationIllustration(height: 160) {
                Rectangle()
                .fill(.purple.gradient)
                .frame(width: 80, height: 80)
                .floatingCaption(
                    "A **Purple**\nSquare `Rectangle`",
                    .alignment(.outerTrailingTop), // alignment for the caption
                    .height                        // prints the height of the parent view
                )
            }
        }
    }


    @Test(.tags(.documentationRender))
    func styleAndBorder() throws {
        try DocumentationResources.renderAndStore("floating-caption", "style-and-border") {
            DocumentationIllustration(height: 160) {
                Circle()
                .fill(.tertiary)
                .frame(width: 80, height: 80)
                .floatingCaption(
                    "A `Circle` Shape",
                    .alignment(.outerLeadingBottom),
                    .captionStyle(.purple),
                    .borderStyle(.indigo.tertiary),
                    .borderWidth(4)
                )
            }
        }
    }


    @Test(.tags(.documentationRender))
    func simpleTraits() throws {
        try DocumentationResources.renderAndStore("floating-caption", "simple-traits") {
            DocumentationIllustration(height: 160) {
                Rectangle()
                .fill(.purple.gradient)
                .frame(width: 80, height: 80)
                .floatingCaption("A Square Rectangle", .height, .alignment(.outerTrailingTop))
            }
        }
    }

}
