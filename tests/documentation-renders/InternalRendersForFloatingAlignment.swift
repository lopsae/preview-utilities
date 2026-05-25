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

    @Test func alignmentExamples() throws {
        try DocumentationResources.renderAndStore("floating-alignment", "alignment-examples") {
            IllustrationsForFloatingAlignment.alignmentExamples
        }
    }


    @Test func innerAlignments() throws {
        try DocumentationResources.renderAndStore("floating-alignment", "inner-alignments") {
            IllustrationsForFloatingAlignment.innerAlignments
        }
    }


    @Test func outerAlignments() throws {
        try DocumentationResources.renderAndStore("floating-alignment", "outer-alignments") {
            IllustrationsForFloatingAlignment.outerAlignments
        }
    }

}
