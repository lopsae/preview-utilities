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
        self.storage = try DocumentationResources.storage(at: "floating-caption")
    }

    // FIXME: Update code for all snippets.

    @Test func `default`() throws {
        try storage.renderAndStore("floating-caption-default") {
            DocumentationIllustration(sizing: .regular) {
                VStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.blue.gradient.secondary)
                        .frame(width: 100, height: 40)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.indigo.gradient.secondary)
                        .frame(width: 100, height: 40)
                        .floatingCaption(
                            "A floating caption\ntrailing the owner view",
                            alignment: .outerTrailing
                        )
                }
            }
        }
    }


    @Test func traitsExplained() throws {
        try storage.renderAndStore("floating-caption-traits-explained") {
            DocumentationIllustration(sizing: .regular) {
                RoundedRectangle(cornerRadius: 16)
                .fill(.purple.gradient)
                .frame(width: 80, height: 80)
                .floatingCaption(
                    "A **Purple** square\nwith border",
                    alignment: .outerTrailingTop,
                    .borderStyle(.blue.secondary), // draws a border over the owner view
                    .borderWidth(2),               // sets the width of the border
                    .height,                       // prints the height of the owner view
                )
            }
        }
    }


    @Test func styleAndBorder() throws {
        try storage.renderAndStore("floating-caption-style-and-border") {
            DocumentationIllustration(sizing: .regular) {
                Circle()
                .fill(.tertiary)
                .frame(width: 80, height: 80)
                .floatingCaption(
                    "A `Circle` Shape",
                    alignment: .outerLeadingBottom,
                    .captionStyle(.purple),
                    .borderStyle(.indigo.tertiary),
                    .borderWidth(4)
                )
            }
        }
    }


    @Test func simpleTraits() throws {
        try storage.renderAndStore("floating-caption-simple-traits") {
            DocumentationIllustration(sizing: .regular) {
                RoundedRectangle(cornerRadius: 8)
                .fill(.purple.gradient)
                .frame(width: 80, height: 80)
                .floatingCaption("A Square Rectangle", alignment: .outerLeading, .height)
            }
        }
    }


    @Test func readmeTraits() throws {
        try storage.renderAndStore("floating-caption-readme-traits") {
            DocumentationIllustration(sizing: .regular) {
                Circle()
                .fill(.tertiary)
                .frame(width: 80, height: 80)
                .floatingCaption(
                    "A `Circle` Shape",             // caption localized string
                    alignment: .outerLeadingBottom, // the caption alignment
                    .height,                        // prints the height of the owner view
                    .colorStyle(.indigo),           // sets the caption and border color
                    .borderWidth(4)                 // sets the border width
                )
            }
        }
    }

}
