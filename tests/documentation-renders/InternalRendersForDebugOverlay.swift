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
@Suite(.tags(.documentationRender))
struct InternalRendersForDebugOverlay {

    @Test func components() throws {
        let resource = try DocumentationRenderer.render("debug-overlay", "components", height: 200) {
            ExamplesForDebugOverlay.components
        }
        try DocumentationResources.store(resource: resource)
    }

}
