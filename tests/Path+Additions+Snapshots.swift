//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct PathAdditionsSnapshots {

    @Test(.snapshotTesting) func rect() {
        Snapshots.assertView("init") {
            VStack(spacing: 30) {
                TestViews.GraticuleRect { spacing, frame in
                    let square: CGSize = .square(of: spacing*2)
                    Path(rect: CGRect(origin: .zero, size: square))
                    .stroke(.green)

                    Path(rect: CGRect(origin: [50, spacing], size: [spacing*3, spacing]))
                    .stroke(.green)
                }

                TestViews.GraticuleRect { spacing, frame in
                    let square: CGSize = .square(of: spacing*2)
                    Path(rect: CGRect(origin: [-spacing, -spacing], size: square))
                    .stroke(.green)

                    Path(rect: CGRect(origin: [120, spacing * 2], size: square))
                    .stroke(.green)
                }
            }
        }
    }

}
