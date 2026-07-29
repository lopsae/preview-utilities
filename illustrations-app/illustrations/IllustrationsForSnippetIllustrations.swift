//
//  illustrations-app
//  Created by Maic Lopez Saenz.
//


@testable import Illustrations_App
import PreviewUtilities
import SwiftUI
import Testing


/// Rendering functions for documentation illustrations for `DocumentationIllustration`.
///
/// Each test produces an image saved to the package documentation catalog.
///
/// This file MUST NOT have internal access to the `PreviewUtilities` package, since the code in
/// each function is also used in code snippets.
@MainActor
struct IllustrationsForSnippetIllustrations {

    let storage: IllustrationStorage

    init() throws {
        self.storage = try DocumentationResources.storage
    }

    @Test func glassWithWindowHierarchy() throws {
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
