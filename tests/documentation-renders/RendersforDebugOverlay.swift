//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI
import Testing


/// Rendering functions for documentation images for `DebugOverlayModifier`.
///
/// Each test produces an image saved to the package documentation catalog.
///
/// This file MUST NOT have internal access to the `PreviewUtilities` package, since the code in
/// each function is also used in code snippets.
@Suite(.tags(.documentationRender))
struct RendersForDebugOverlay {

    @Test func `default`() throws {
        let resource = try DocumentationRenderer.render("debug-overlay", "default", height: 160) {
            Text("Sphinx of Black Quartz")
                .font(.title)
            Text("Judge my Vow")
                .font(.title)
                .debugOverlay()
        }
        try DocumentationResources.store(resource: resource)
    }


    @Test func simpleTraits() throws {
        let resource = try DocumentationRenderer.render("debug-overlay", "simple-traits", height: 160) {
            Rectangle()
            .fill(.yellow.gradient.secondary)
            .frame(width: 200, height: 80)
            .debugOverlay(
                .size,                     // prints the size of the parent view
                .bordersWidth(2),          // sets debug borders width to 2
                .alignment(.innerTrailing) // aligns caption to trailing-center
            )
        }
        try DocumentationResources.store(resource: resource)
    }


    @Test func alignments() throws {
        let resource = try DocumentationRenderer.render("debug-overlay", "alignments", height: 180) {
            HStack(spacing: 16) {
                Rectangle()
                    .fill(.green.gradient)
                    .frame(width: 100, height: 60)
                    .debugOverlay(.caption("Inner Top"), .alignment(.innerTop))
                Rectangle()
                    .fill(.mint.gradient)
                    .frame(width: 100, height: 60)
                    .debugOverlay(.caption("Outer Bottom\nLeading"), .alignment(.outerBottomLeading))
                Rectangle()
                    .fill(.teal.gradient)
                    .frame(width: 100, height: 60)
                    .debugOverlay(.caption("Outer Top\nTrailing"), .alignment(.outerTopTrailing))
            }
        }
        try DocumentationResources.store(resource: resource)
    }


    @Test func torchDefault() throws {
        let resource = try DocumentationRenderer.render("debug-overlay", "torch-default", height: 100) {
            Text("a sort of splendid torch")
                .debugOverlay()
            Text("which I have got hold of for the moment")
        }
        try DocumentationResources.store(resource: resource)
    }


    @Test func torchTraits() throws {
        let resource = try DocumentationRenderer.render("debug-overlay", "torch-traits", height: 100) {
            Text("a sort of splendid torch")
                .debugOverlay(.width, .alignment(.outerTop))
            Text("which I have got hold of for the moment")
        }
        try DocumentationResources.store(resource: resource)
    }

}
