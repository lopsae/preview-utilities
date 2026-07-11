//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities


import SwiftUI
import SnapshotTesting
import Testing

enum Snapshots {

    static let defaultColorSchemes: ColorScheme.AllCases = ColorScheme.allCases

    static func assertView<Content: View>(
        _ name: String,
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

}
