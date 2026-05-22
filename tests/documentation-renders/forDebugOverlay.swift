//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI
import Testing


/// Each test produces an image saved to the package documentation catalog.
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
            .fill(.yellow.gradient)
            .frame(width: 200, height: 100)
            .debugOverlay(
                .hairline, 
                .width,
                .infoAlignment(.innerTrailing)
            )
        }
        try DocumentationResources.store(resource: resource)
    }

    
    @Test func alignments() throws {
        let resource = try DocumentationRenderer.render("debug-overlay", "alignments", height: 160) {
            HStack(spacing: 16) {
                Rectangle()
                    .fill(.green.gradient)
                    .frame(width: 100, height: 60)
                    .debugOverlay(.caption("Inner Top"), .alignment(.innerTop))
                Rectangle()
                    .fill(.mint.gradient)
                    .frame(width: 100, height: 60)
                    .debugOverlay(.caption("Outer Bottom Leading"), .alignment(.outerBottomLeading))
                Rectangle()
                    .fill(.teal.gradient)
                    .frame(width: 100, height: 60)
                    .debugOverlay(.caption("Outer Top Trailing"), .alignment(.outerTopTrailing))
            }
        }
        try DocumentationResources.store(resource: resource)
    }

}
