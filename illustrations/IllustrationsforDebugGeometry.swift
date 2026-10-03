//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import SwiftUI
import Testing


/// Rendering functions for documentation illustrations for `DebugGeometryModifier`.
///
/// Each test produces an image saved to the package documentation catalog.
///
/// This file MUST NOT have internal access to the `PreviewUtilities` package, since the code in
/// each function is also used in code snippets.
struct IllustrationsForDebugOverlay {

    // FIXME: use only path storage after testing.
    let storage: IllustrationStorage
    let pathStorage: IllustrationStorage

    init() throws {
        self.storage = try DocumentationResources.storage
        self.pathStorage = try DocumentationResources.storage(at: "debug-geometry")
    }


    @Test func `default`() throws {
        try pathStorage.renderAndStore("debug-geometry-default") {
            DocumentationIllustration(sizing: .regular) {
                Text("Sphinx of Black Quartz")
                    .font(.title)
                Text("Judge my Vow")
                    .font(.title)
                    .debugGeometry()
            }
        }
    }


    @Test func simpleTraits() throws {
        try pathStorage.renderAndStore("debug-geometry-simple-traits") {
            DocumentationIllustration(sizing: .regular) {
                RoundedRectangle(cornerRadius: 16)
                .fill(.yellow.gradient.secondary)
                .frame(width: 200, height: 80)
                .debugGeometry(
                    .size,                     // prints the size of the owner view
                    .bordersWidth(2),          // sets debug borders width to 2
                    .alignment(.innerTrailing) // aligns caption to trailing-center
                )
            }
        }
    }


    @Test func alignments() throws {
        try pathStorage.renderAndStore("debug-geometry-alignments") {
            DocumentationIllustration(height: 180) {
                HStack(spacing: 16) {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.green.gradient)
                        .frame(width: 100, height: 60)
                        .debugGeometry(.caption("Inner Top"), .alignment(.innerTop))
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.mint.gradient)
                        .frame(width: 100, height: 60)
                        .debugGeometry(.caption("Outer Bottom\nLeading"), .alignment(.outerBottomLeading))
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.teal.gradient)
                        .frame(width: 100, height: 60)
                        .debugGeometry(.caption("Outer Top\nTrailing"), .alignment(.outerTopTrailing))
                }
            }
        }
    }


    @Test func torchTraits() throws {
        try storage.renderAndStore("debug-geometry", "torch-traits") {
            DocumentationIllustration(height: 100) {
                Text("a sort of splendid torch")
                    .debugGeometry(.width, .alignment(.outerTop))
                Text("which I have got hold of for the moment")
            }
        }
    }

}
