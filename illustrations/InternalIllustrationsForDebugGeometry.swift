//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing

// FIXME: File needs rename to DebugGeometry.
// FIXME: Illustrations need rename to debug-geometry.

/// Rendering functions for documentation illustrations for `DebugGeometryModifier`.
///
/// Each test produces an image saved to the package documentation catalog.
///
/// This file has testable access to PreviewUtilities. This code should not be used in documentation
/// snippets.
struct InternalIllustrationsForDebugOverlay {

    let storage: IllustrationStorage

    init() throws {
        self.storage = try DocumentationResources.storage
    }


    @Test func card() throws {
        try storage.renderAndStore("debug-overlay", "card") {
            DebugGeometryModifier.Illustrations.card
        }
    }


    @Test func components() throws {
        try storage.renderAndStore("debug-overlay", "components") {
            DebugGeometryModifier.Illustrations.components
        }
    }

}
