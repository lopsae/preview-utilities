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
        assertImageSnapshot(named: "alignments", record: .never) {
            Text("Ag")
            .font(.title.pointSize(100))
            .debugAlignmentGuide(horizontal: .leading)
            .debugAlignmentGuide(horizontal: .center)
            .debugAlignmentGuide(horizontal: .trailing)
        }
    }


    @Test func verticalAlignments() {
        assertImageSnapshot(named: "alignments", record: .never) {
            Text("Sphinx\nof Black\nQuartz")
            .font(.largeTitle)
            .debugAlignmentGuide(vertical: .top)
            .debugAlignmentGuide(vertical: .firstTextBaseline)
            .debugAlignmentGuide(vertical: .center)
            .debugAlignmentGuide(vertical: .lastTextBaseline)
            .debugAlignmentGuide(vertical: .bottom)
        }
    }

}

func assertImageSnapshot<Content: View/*, Format*/>(
    named name: String? = nil,
    layout: SwiftUISnapshotLayout = .fixed(width: 200, height: 200),
    record: SnapshotTestingConfiguration.Record? = nil,
    timeout: TimeInterval = 5,
    fileID: StaticString = #fileID,
    file filePath: StaticString = #filePath,
    testName: String = #function,
    line: UInt = #line,
    column: UInt = #column,
    @ViewBuilder content: () -> Content
) {
    let failure = verifySnapshot(
      of: content(),
      as: .image(layout: layout),
      named: name,
      record: record,
      timeout: timeout,
      fileID: fileID,
      file: filePath,
      testName: testName,
      line: line,
      column: column
    )
    guard let message = failure else { return }
    Issue.record(
      Comment(rawValue: message),
      sourceLocation: SourceLocation(
        fileID: fileID.description,
        filePath: filePath.description,
        line: Int(line),
        column: Int(column)
      )
    )
}
