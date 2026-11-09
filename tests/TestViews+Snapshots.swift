//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import SwiftUI
import Testing


@MainActor
@Suite(.snapshotTesting)
struct TestViewsSnapshots {

    @Test func quinaryGraySquare() {
        Snapshots.assertView("default", colorSchemes: .all) {
            TestViews.quinaryGraySquare()
        }

        Snapshots.assertView("sized") {
            TestViews.quinaryGraySquare(length: 50)
        }
    }


    @Test func quinaryGrayRect() {
        Snapshots.assertView("default", colorSchemes: .all) {
            TestViews.quinaryGrayRect()
        }

        Snapshots.assertView("sized") {
            TestViews.quinaryGrayRect(size: [20, 120])
        }
    }


    @Test func graticuleRect() {
        Snapshots.assertView("defaults") {
            VStack(spacing: 30) { // FIXME: Use snapshot spacing.
                TestViews.GraticuleRect { spacing, frame in
                    // Empty.
                }

                TestViews.GraticuleRect { spacing, frame in
                    let originRect = CGRect(origin: frame.origin, size: .square(of: spacing))
                    Path(originRect)
                    .fill(.green.secondary)

                    let centerRect = CGSize.square(of: spacing).centered(in: frame)
                    Path(centerRect)
                    .fill(.green.secondary)

                    let endRect = CGRect(origin: frame.maxPoint, size: .square(of: spacing))
                    Path(endRect)
                    .fill(.green.secondary)
                }
            }
        }
    }

}
