//
//  illustrations-app
//  Created by Maic Lopez Saenz.
//


@testable import Illustrations_App
import PreviewUtilities
import SwiftUI
import Testing


@MainActor
struct IllustrationsForSnippetIllustrations {

    @Test func glassWithWindowHierarchy() throws {
        let storage = try IllustrationStorage(
            filePath: #filePath,
            droppingComponents: 3, // filename, tests, illustration-app
            appendingComponents: ["sources", "documentation.docc", "resources"]
        ) {
            // onImageStored
            cgImage, filename in
            Attachment.record(cgImage, named: filename, as: .png)
        }

        try storage.renderAndStore("snippet-illustrations", "glass-with-window-hierarchy", backend: .windowHierarchy) {
            DocumentationIllustration(sizing: .regular) {
                VStack {
                    Button("Bordered Button", systemImage: "circle", action: {})
                    .buttonStyle(.bordered)
                    .padding(8)
                    .floatingCaption("Bordered", .colorStyle(.green), .alignment(.outerTrailing))

                    Button("Glass Button", systemImage: "circle", action: {})
                    .buttonStyle(.glassProminent)
                    .padding(8)
                    .floatingCaption("Glass", .colorStyle(.green), .alignment(.outerTrailing))
                }

            }
        }
    }

}
