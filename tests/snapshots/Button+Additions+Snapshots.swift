//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
@Suite(.snapshotTesting)
struct ButtonAdditionsSnapshots {

    @Test func iconInits() {
        Snapshots.assertView("all", spacing: 20, colorSchemes: .all) {
            Button("AutoClosure", action: {}, icon: FilledRectangle(.mint, size: [20, 20]))
            .buttonStyle(.borderedProminent)
            Button("ContentBuilder") {} icon: {
                FilledRectangle(.orange, size: [30, 30])
            }
            .buttonStyle(.bordered)
        }
    }


    @Test func labelInits() {
        Snapshots.assertView("autoclosures", spacing: 20, colorSchemes: .all) {
            Button(label: Text("AutoClosure")) { }
            .buttonStyle(.borderedProminent)
            Button(label: Text("AutoClosure").monospaced().border(.blue.secondary, width: 2)) { }
            .buttonStyle(.bordered)
        }
    }


    @Test func titleIconInits() {
        Snapshots.assertView("contentBuilders", spacing: 20, colorSchemes: .all) {
            Button {
                // No-op.
            } title: {
                Text("Title")
            } icon: {
                FilledRectangle(.mint, size: [20, 20])
            }
            .buttonStyle(.borderedProminent)

            Button {
                // No-op.
            } title: {
                Text("Title").monospaced().border(.blue.secondary, width: 2)
            } icon: {
                FilledRectangle(.orange, size: [30, 30])
            }
            .buttonStyle(.bordered)
        }

        Snapshots.assertView("autoclosures", spacing: 20, colorSchemes: .all) {
            Button(
                action: {},
                title: Text("Title"),
                icon: FilledRectangle(.mint, size: [20, 20])
            )
            .buttonStyle(.borderedProminent)

            Button(
                action: {},
                title: Text("Title").monospaced().border(.blue.secondary, width: 2),
                icon: FilledRectangle(.orange, size: [30, 30])
            )
            .buttonStyle(.bordered)
        }
    }

}
