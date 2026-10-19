//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct TestViewsSnapshots {

    @Test(.snapshotTesting) func quinaryGraySquare() {
        Snapshots.assertView("default", colorSchemes: .all) {
            TestViews.quinaryGraySquare()
        }

        Snapshots.assertView("sized") {
            TestViews.quinaryGraySquare(length: 50)
        }
    }


    @Test(.snapshotTesting) func quinaryGrayRect() {
        Snapshots.assertView("default", colorSchemes: .all) {
            TestViews.quinaryGrayRect()
        }

        Snapshots.assertView("sized") {
            TestViews.quinaryGrayRect(size: [20, 120])
        }
    }

}
