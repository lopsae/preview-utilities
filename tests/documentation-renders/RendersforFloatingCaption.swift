//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


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

    @Test func `default`() throws {
        let resource = try DocumentationRenderer.render("floating-caption", "default", height: 160) {
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
        try DocumentationResources.store(resource: resource)
    }


    @Test func traitsExplained() throws {
        let resource = try DocumentationRenderer.render("floating-caption", "traits-explained", height: 160) {
            Rectangle()
            .fill(.purple.gradient)
            .frame(width: 80, height: 80)
            .floatingCaption(
                "A **Purple**\nSquare `Rectangle`",
                .alignment(.outerTrailingTop), // alignment for the caption
                .height                        // prints the height of the parent view
            )
        }
        try DocumentationResources.store(resource: resource)
    }


    @Test func styleAndBorder() throws {
        let resource = try DocumentationRenderer.render("floating-caption", "style-and-border", height: 160) {
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
        try DocumentationResources.store(resource: resource)
    }


    @Test func simpleTraits() throws {
        let resource = try DocumentationRenderer.render("floating-caption", "simple-traits", height: 160) {
            Rectangle()
            .fill(.purple.gradient)
            .frame(width: 80, height: 80)
            .floatingCaption("A Square Rectangle", .height, .alignment(.outerTrailingTop))
        }
        try DocumentationResources.store(resource: resource)
    }

}
