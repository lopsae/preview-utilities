//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


/// Rendering functions for documentation illustrations for ``EdgeGraticuleModifier``.
///
/// Each test produces an image saved to the package documentation catalog.
///
/// This file has testable access to PreviewUtilities. This code should not be used in documentation
/// snippets.
struct InternalIllustrationsForEdgeGraticule {

    let storage: IllustrationStorage

    init() throws {
        self.storage = try DocumentationResources.storage
    }


    @Test func card() throws {
        try storage.renderAndStore("edge-graticule", "card") {
            EdgeGraticuleModifier.Illustrations.card
        }
    }


    @Test func insetComponents() throws {
        try storage.renderAndStore("edge-graticule", "inset-components") {
            EdgeGraticuleModifier.Illustrations.insetComponent
        }
    }


    @Test func outsetComponents() throws {
        try storage.renderAndStore("edge-graticule", "outset-components") {
            EdgeGraticuleModifier.Illustrations.outsetComponent
        }
    }


    @Test func perEdgeTraits() throws {
        try storage.renderAndStore("edge-graticule", "per-edge-traits") {
            EdgeGraticuleModifier.Illustrations.perEdgeTraits
        }
    }

}
