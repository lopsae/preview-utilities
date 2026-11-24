//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


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


    @Test func titleIconInits() {
        Snapshots.assertView("autoclosures", spacing: 20, colorSchemes: .all) {
            Label(
                title: Text("Title"),
                icon: FilledRectangle(.mint, size: [20, 20])
            )

            Label(
                title: Text("Title").monospaced().border(.blue.secondary, width: 2),
                icon: FilledRectangle(.orange, size: [30, 30])
            )
        }
    }

}
