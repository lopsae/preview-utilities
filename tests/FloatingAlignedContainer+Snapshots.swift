//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing
import SwiftUI


struct FloatingAlignedContainerSnapshots {

    @Test(.snapshotTesting) func alignments() {
        Snapshots.assertView("all") {
            Rectangle().fill(.gray.quinary)
            .frame(squareOf: 100)
            .overlay {
                ForEach(FloatingAlignment.allCases) { alignment in
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

}
