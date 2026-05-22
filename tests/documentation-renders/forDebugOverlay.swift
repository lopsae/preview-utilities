//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI
import Testing


/// Each test uses a `DocScreenshotRenderer` to produce an image that is saved to the package
/// documentation catalog.
@Suite(.tags(.documentationRender))
struct RendersForDebugOverlay {

    @Test func testRender() throws {
        let resource = try DocumentationRenderer.render("debug-overlay-default-test", height: 160) {
            Text("Sphinx of Black Quartz")
                .font(.title)
            Text("Judge my Vow")
                .font(.title)
                .debugOverlay()
        }
        try DocumentationResources.store(resource: resource)
    }

}
