//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


/// Rendering functions for documentation illustrations for `DebugGeometryModifier`.
///
/// Each test produces an image saved to the package documentation catalog.
///
/// This file has testable access to PreviewUtilities. This code should not be used in documentation
/// snippets.
struct InternalIllustrationsForDebugOverlay {

    // FIXME: use only path storage after testing.
    let storage: IllustrationStorage
    let pathStorage: IllustrationStorage

    init() throws {
        self.storage = try DocumentationResources.storage
        self.pathStorage = try DocumentationResources.storage(at: "debug-geometry")
    }


    @Test func card() throws {
        try storage.renderAndStore("debug-geometry", "card") {
            DebugGeometryModifier.Illustrations.card
        }
    }


    @Test func components() throws {
        try pathStorage.renderAndStore("debug-geometry-components") {
            DebugGeometryModifier.Illustrations.components
        }
    }

}
