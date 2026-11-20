//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@_spi(ItemStacks)
import PreviewUtilities

import SwiftUI
import Testing


@MainActor
@Suite(.snapshotTesting)
struct LabelAdditionsSnapshots {

    @Test func iconInits() {
        Snapshots.assertView("all", spacing: 20, colorSchemes: .all) {
            Label("AutoClosure", icon: FilledRectangle(.mint, size: [20, 20]))
            Label("ContentBuilder") {
                FilledRectangle(.green, size: [20, 20])
            }
        }
    }

    @Test func uniformIcon() {
        Snapshots.assertView("alone", spacing: 20, colorSchemes: .all) {
            let symbolNames = ["guidepoint.horizontal", "guidepoint.vertical"]
            VStack(items: symbolNames, spacing: 10) { symbolName in
                Label("Default", systemImage: symbolName)
                .border(.mint.secondary, width: 2)
            }

            VStack(items: symbolNames, spacing: 10) { symbolName in
                Label("Uniform", systemImage: symbolName)
                .border(.mint.secondary, width: 2)
            }
            .labelStyle(.uniformIcon)
        }

        Snapshots.assertView("withIconOnly", spacing: 20) {
            let symbolNames = ["guidepoint.horizontal", "guidepoint.vertical"]
            VStack(items: symbolNames, spacing: 10) { symbolName in
                Label("Default", systemImage: symbolName)
                .border(.mint.secondary, width: 2)
            }
            .labelStyle(.iconOnly)

            VStack(items: symbolNames, spacing: 10) { symbolName in
                Label("Uniform", systemImage: symbolName)
                .border(.mint.secondary, width: 2)
            }
            .labelStyle(.uniformIcon)
            .labelStyle(.iconOnly)
        }
    }

}
