//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import SwiftUI
import Testing
import SnapshotTesting


@MainActor
struct DebugAlignmentGuideModifierSnapshots {

    @Test func horizontalAlignments() {
        let view = Text("Ag")
        .font(.title.pointSize(100))
        .debugAlignmentGuide(horizontal: .leading)
        .debugAlignmentGuide(horizontal: .center)
        .debugAlignmentGuide(horizontal: .trailing)
        .frame(squareOf: 200)

        assertSnapshot(of: view, as: .image, record: .never)
    }


    @Test func verticalAlignments() {
        let view = Text("Sphinx\nof Black\nQuartz")
        .font(.largeTitle)
        .debugAlignmentGuide(vertical: .top)
        .debugAlignmentGuide(vertical: .firstTextBaseline)
        .debugAlignmentGuide(vertical: .center)
        .debugAlignmentGuide(vertical: .lastTextBaseline)
        .debugAlignmentGuide(vertical: .bottom)
        .frame(squareOf: 200)

        assertSnapshot(of: view, as: .image, record: .never)
    }

}
