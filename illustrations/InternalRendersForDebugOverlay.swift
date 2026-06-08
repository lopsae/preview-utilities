//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities


import SwiftUI
import Testing


/// Rendering functions for documentation images for `DebugOverlayModifier`.
///
/// Each test produces an image saved to the package documentation catalog.
///
/// This file has testable access to PreviewUtilities. This code should not be used in documentation
/// snippets.
struct InternalRendersForDebugOverlay {

    let storage: IllustrationStorage

    init() throws {
        self.storage = try DocumentationResources.storage
    }


    @Test func components() throws {
        try storage.renderAndStore("debug-overlay", "components") {
            DebugOverlayModifier.Illustrations.components
        }
    }

}
