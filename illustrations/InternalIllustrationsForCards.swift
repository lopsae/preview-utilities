//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


/// Rendering functions for documentation illustrations for general cards.
///
/// Each test produces an image saved to the package documentation catalog.
///
/// This file has testable access to PreviewUtilities. This code should not be used in documentation
/// snippets.
struct InternalIllustrationsForCards {

    let storage: IllustrationStorage

    init() throws {
        self.storage = try DocumentationResources.storage
    }


    @Test func formatStyles() throws {
        try storage.renderAndStore("cards", "format-styles") {
            CardIllustrations.formatStyles
        }
    }


    @Test func floatingCaption() throws {
        try storage.renderAndStore("cards", "floating-caption") {
            CardIllustrations.floatingCaption
        }
    }

}
