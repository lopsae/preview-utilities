//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities


import SwiftUI
import SnapshotTesting
import Testing

enum Snapshots {

    static let defaultColorSchemes: Set<ColorScheme> = [.light]

    static func assertView<Content: View>(
        _ name: String,
        size: CGSize = .square(of: 200),
        colorSchemes: Set<ColorScheme> = defaultColorSchemes,
        timeout: TimeInterval = 5,
        record: SnapshotTestingConfiguration.Record? = nil,
        fileID: StaticString = #fileID,
        file filePath: StaticString = #filePath,
        testName: String = #function,
        line: UInt = #line,
        column: UInt = #column,
        @ViewBuilder content: () -> Content
    ) {
        let fileURL = URL(fileURLWithPath: "\(filePath)")
        let testFolderName = "tests"
        let maxDeletions: Int = 4
        guard let testsFolder = fileURL.deletingPathComponents(until: testFolderName, maxDeletions: maxDeletions) else {
            Issue.record(
                comment: "The root tests folder `\(testFolderName)` could not be found within \(maxDeletions) folders of the test suite file",
                fileID: fileID, filePath: filePath,
                line: line, column: column
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

        for scheme in colorSchemes {
            let snapshotName: String
            switch scheme {
            case .light: snapshotName = name
            case .dark: snapshotName = name + "~dark"
            @unknown default:
                Issue.record(
                    comment: "Unknown color scheme: \(scheme)",
                    fileID: fileID, filePath: filePath,
                    line: line, column: column
                )
                continue
            }

            let configuredContent = content()
                .frame(size: size)
                .background(.background)
                .environment(\.colorScheme, scheme)

            #if canImport(UIKit)
                let layout:SwiftUISnapshotLayout = .fixed(width: size.width, height: size.height)
                let failureMessage = verifySnapshot(
                  of: configuredContent,
                  as: .image(layout: layout),
                  named: snapshotName,
                  record: record,
                  snapshotDirectory: snapshotsFolder.path(),
                  timeout: timeout,
                  fileID: fileID,
                  file: filePath,
                  testName: testName,
                  line: line,
                  column: column
                )
            #endif

            #if canImport(AppKit)
                let hostingView = NSHostingView(rootView: configuredContent)
                hostingView.frame = .init(origin: .zero, size: size)
                let failureMessage = verifySnapshot(
                  of: hostingView,
                  as: .image,
                  named: snapshotName,
                  record: record,
                  snapshotDirectory: snapshotsFolder.path(),
                  timeout: timeout,
                  fileID: fileID,
                  file: filePath,
                  testName: testName,
                  line: line,
                  column: column
                )
            #endif

            if let failureMessage {
                Issue.record(
                    comment: failureMessage,
                    fileID: fileID, filePath: filePath,
                    line: line, column: column
                )
            }

            // Test succeeded!
        }
    }

}


extension Issue {

    /// Records an issue that a test encounters while it's running.
    ///
    /// Convenience function to record an issue with the types used by `#fileID`, `#filePath`,
    /// `#line`, and `#column`.
    static func record(
        comment: String,
        fileID: StaticString,
        filePath: StaticString,
        line: UInt,
        column: UInt
    ) {
        Issue.record(
            Comment(rawValue: comment),
            sourceLocation: SourceLocation(
                fileID: fileID.description,
                filePath: filePath.description,
                line: Int(line),
                column: Int(column)
            )
        )
    }

}
