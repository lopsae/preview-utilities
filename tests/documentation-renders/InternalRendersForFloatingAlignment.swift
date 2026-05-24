//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities


import SwiftUI
import Testing


/// Rendering functions for documentation images for `FloatingAlignment`.
///
/// Each test produces an image saved to the package documentation catalog.
///
/// This file has testable access to PreviewUtilities. This code should not be used in documentation
/// snippets.
@Suite(.tags(.documentationRender))
struct InternalRendersForFloatingAlignment {

    @Test func innerAlignments() throws {
        let resource = try DocumentationRenderer.render("floating-alignment", "inner-alignments", height: 240) {
            ExamplesForFloatingAlignment.innerAlignments
        }
        try DocumentationResources.store(resource: resource)
    }


    @Test func outerAlignments() throws {
        let resource = try DocumentationRenderer.render("floating-alignment", "outer-alignments", height: 300) {
            ExamplesForFloatingAlignment.outerAlignments
        }
        try DocumentationResources.store(resource: resource)
    }

}
