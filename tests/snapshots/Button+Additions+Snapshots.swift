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
            Button("ContentBuilder") {} icon: {
                FilledRectangle(.orange, size: [30, 30])
            }
        }
    }


//    @Test func titleIconInits() {
//        Snapshots.assertView("autoclosures", spacing: 20, colorSchemes: .all) {
//            Label(
//                title: Text("Title"),
//                icon: FilledRectangle(.mint, size: [20, 20])
//            )
//
//            Label(
//                title: Text("Title").monospaced().border(.blue.secondary, width: 2),
//                icon: FilledRectangle(.orange, size: [30, 30])
//            )
//        }
//    }

}
