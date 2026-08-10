//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import SwiftUI
import Testing


/// Rendering functions for documentation illustrations for `EdgeGraticuleModifier`.
///
/// Each test produces an image saved to the package documentation catalog.
///
/// This file MUST NOT have internal access to the `PreviewUtilities` package, since the code in
/// each function is also used in code snippets.
struct IllustrationsForEdgeGraticule {

    let storage: IllustrationStorage

    init() throws {
        self.storage = try DocumentationResources.storage
    }


    @Test func `default`() throws {
        try storage.renderAndStore("edge-graticule", "default") {
            DocumentationIllustration(sizing: .regular) {
                Capsule()
                .fill(.cyan.gradient.secondary)
                .frame(width: 200, height: 60)
                .edgeGraticule(spacing: 16)
            }
        }
    }


    @Test func simpleTraits() throws {
        try storage.renderAndStore("edge-graticule", "simple-traits") {
            DocumentationIllustration(sizing: .regular) {
                Capsule()
                .fill(.cyan.gradient.secondary)
                .frame(width: 200, height: 60)
                .edgeGraticule(
                    spacing: 20,
                    // modifies the spacing and count for bottom inset lines.
                    .inset(.vertical, spacing: 10, count: 2),
                    // Modifies the count for horizontal outset lines.
                    .outset(.horizontal, count: 3)
                )
            }
        }
    }

}
