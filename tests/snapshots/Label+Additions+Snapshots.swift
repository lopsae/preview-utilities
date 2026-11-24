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

}
