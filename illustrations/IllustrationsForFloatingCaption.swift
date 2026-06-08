//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities


import SwiftUI
import Testing


/// Rendering functions for documentation illustrations for `FloatingCaptionModifier`.
///
/// Each test produces an image saved to the package documentation catalog.
///
/// This file MUST NOT have internal access to the `PreviewUtilities` package, since the code in
/// each function is also used in code snippets.
struct IllustrationsForFloatingCaption {

    let storage: IllustrationStorage

    init() throws {
        self.storage = try DocumentationResources.storage
    }


    @Test func `default`() throws {
        try storage.renderAndStore("floating-caption", "default") {
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


    @Test func traitsExplained() throws {
        try storage.renderAndStore("floating-caption", "traits-explained") {
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


    @Test func styleAndBorder() throws {
        try storage.renderAndStore("floating-caption", "style-and-border") {
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


    @Test func simpleTraits() throws {
        try storage.renderAndStore("floating-caption", "simple-traits") {
            DocumentationIllustration(height: 160) {
                Rectangle()
                .fill(.purple.gradient)
                .frame(width: 80, height: 80)
                .floatingCaption("A Square Rectangle", .height, .alignment(.outerTrailingTop))
            }
        }
    }


    @Test func readmeTraits() throws {
        try storage.renderAndStore(
            "floating-caption", "readme-traits",
            colorScheme: .light
        ) {
            DocumentationIllustration(height: 160) {
                Circle()
                .fill(.tertiary)
                .frame(width: 80, height: 80)
                .floatingCaption(
                    "A `Circle` Shape",              // caption localized string
                    .height,                         // prints the height of the parent view
                    .alignment(.outerLeadingBottom), // alignment for the caption
                    .colorStyle(.indigo),            // sets the caption and border color
                    .borderWidth(4)                  // sets the border width
                )
            }
        }
    }

}
