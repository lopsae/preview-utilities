//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing
import SwiftUI


@Suite(.snapshotTesting)
struct FloatingAlignedContainerSnapshots {

    @Test func alignments() {
        Snapshots.assertView("all") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                FloatingAlignedContainer(alignment: alignment, spacing: 2) { alignments in
                    ZStack(alignment: alignments.content) {
                        Rectangle().fill(.teal.secondary)
                        .frame(squareOf: 25)

                        Text(alignment.abbreviatedName)
                        .font(.caption)
                    }
                }
            }
        }
    }

}
