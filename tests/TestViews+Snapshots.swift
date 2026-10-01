//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct TestViewsSnapshots {

    @Test(.snapshotTesting) func views() {
        Snapshots.assertView("quinaryGraySquare", colorSchemes: .all) {
            TestViews.quinaryGraySquare
        }
    }

}
