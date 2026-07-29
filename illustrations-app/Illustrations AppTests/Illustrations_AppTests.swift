//
//  Illustrations_AppTests.swift
//  Illustrations AppTests
//
//  Created by Maic Lopez Saenz on 2026-07-28.
//

@testable import Illustrations_App
import PreviewUtilities
import SwiftUI
import Testing

@MainActor
struct Illustrations_AppTests {

    @Test func glass() throws {
        let storage = try IllustrationStorage(
            filePath: #filePath,
            droppingComponents: 4, // filename, tests, Illustration App, illustration-app
            appendingComponents: ["sources", "documentation.docc", "resources"]
        ) {
            // onImageStored
            cgImage, filename in
            Attachment.record(cgImage, named: filename, as: .png)
        }

        // FIXME: Move to its own folder, likely snippet-illustrations. Get out of debug-overlay.
        try storage.renderAndStore("debug-overlay", "glass", backend: .windowHierarchy) {
            DocumentationIllustration(height: 160) {
                Button("Judge my Vow", systemImage: "circle", action: {})
                    .buttonStyle(.glassProminent)
            }
        }
    }

}
