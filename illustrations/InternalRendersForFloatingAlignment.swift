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
struct InternalRendersForFloatingAlignment {

    let storage: IllustrationStorage

    init() throws {
        self.storage = try DocumentationResources.storage
    }


    @Test func alignmentExamples() throws {
        try storage.renderAndStore("floating-alignment", "alignment-examples") {
            IllustrationsForFloatingAlignment.alignmentExamples
        }
    }


    @Test func innerAlignments() throws {
        try storage.renderAndStore("floating-alignment", "inner-alignments") {
            IllustrationsForFloatingAlignment.innerAlignments
        }
    }


    @Test func outerAlignments() throws {
        try storage.renderAndStore("floating-alignment", "outer-alignments") {
            IllustrationsForFloatingAlignment.outerAlignments
        }
    }


    @Test func outerWithVerticalMajor() throws {
        try storage.renderAndStore("floating-alignment", "outer-with-vertical-major") {
            IllustrationsForFloatingAlignment.outerAlignmentWithVerticalMajor
        }
    }


    @Test func outerWithHorizontalMajor() throws {
        try storage.renderAndStore("floating-alignment", "outer-with-horizontal-major") {
            IllustrationsForFloatingAlignment.outerAlignmentWithHorizontalMajor
        }
    }

}
