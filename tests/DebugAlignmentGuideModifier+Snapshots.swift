//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


// FIXME: see if testable can be removed once assetImageSnapshot is moved to another file.
@testable import PreviewUtilities

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

    @Test func axisAlignmentsWithOpacity() {
        assertImageSnapshot(named: "horizontal", record: .never) {
            Text("Ag")
            .font(.title.pointSize(100))
            .debugAlignmentGuide(horizontal: .leading)
            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.half), .visible(true))
            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.half), .visible(false))
            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.half))
            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.half), .hidden)
            .alignmentGuide(.leading, offsetBy: 20)
            .debugAlignmentGuide(horizontal: .leading, .opacity(.one))
        }

        assertImageSnapshot(named: "vertical", record: .never) {
            Text("Ag")
            .font(.title.pointSize(100))
            .debugAlignmentGuide(vertical: .top)
            // FIXME: make it into a local extension
            .overlay {
                FloatingAlignedContainer(alignment: .outerLeadingTop, horizontalSpacing: 4) { _ in
                    Circle().foregroundStyle(.red).frame(squareOf: 4)
                }
            }
            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.half), .visible(true))
            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.half), .visible(false))
            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.half))
            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.half), .hidden)
            .alignmentGuide(.top, offsetBy: 20)
            .debugAlignmentGuide(vertical: .top, .opacity(.one))
        }
    }

}


func assertImageSnapshot<Content: View>(
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

    // 1. Get the directory of the current test file
    let fileURL = URL(fileURLWithPath: "\(filePath)")
    let testFolderName = "testsx"
    let maxDeletions: Int = 4
    guard let testsFolder = fileURL.deletingPathComponents(until: "tests", maxDeletions: maxDeletions) else {
        Issue.record(
          "The root tests folder `\(testFolderName)` could not be found within \(maxDeletions) folders of the test suite file",
          sourceLocation: SourceLocation(
            fileID: fileID.description,
            filePath: filePath.description,
            line: Int(line),
            column: Int(column)
          )
        )
        return
    }

    let snapshotsSuffix = "+Snapshots"
    var testSuiteName = fileURL.deletingPathExtension().lastPathComponent
    if testSuiteName.hasSuffix("+Snapshots") {
        testSuiteName.removeLast(snapshotsSuffix.count)
    }

    let snapshotsFolderName = "recorded-snapshots"
    let snapshotsFolder = testsFolder.appending(pathComponents: [snapshotsFolderName, testSuiteName])

    let failure = verifySnapshot(
      of: content(),
      as: .image(layout: layout),
      named: name,
      record: record,
      snapshotDirectory: snapshotsFolder.path(),
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
