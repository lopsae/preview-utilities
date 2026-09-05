//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct DebugTextRendererSnapshots {

    enum TestContent {
        static let multi = Text("""
            sphinx of
            black Quartz
            judge my Vow
            """
        ).foregroundStyle(.tertiary)
    }


    @Test(.snapshotTesting) func defaultConfig() {
        Snapshots.assertView("body", colorSchemes: .all) {
            TestContent.multi
            .textRenderer(DebugTextRenderer())
        }

        Snapshots.assertView("title", colorSchemes: .all) {
            TestContent.multi
            .font(.title)
            .textRenderer(DebugTextRenderer())
        }
    }


    @Test(.snapshotTesting) func otherConfigs() {
        Snapshots.assertView("none") {
            TestContent.multi
            .textRenderer(DebugTextRenderer(configuration: .none))
        }

        Snapshots.assertView("onlyRect") {
            TestContent.multi
            .textRenderer(DebugTextRenderer(configuration: .onlyRect))
        }
    }

}
