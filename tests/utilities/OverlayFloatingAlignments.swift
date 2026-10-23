//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


extension View {

    func overlayFloatingAlignments<Content: View>(
        @ViewBuilder content: @escaping (_ alignment: FloatingAlignment) -> Content
    ) -> some View {
        self.overlay {
            ForEach(FloatingAlignment.allCases) { alignment in
                content(alignment)
            }
        }
    }

}


// FIXME: Add tests.
@Suite(.snapshotTesting) struct OverlayFloatingAlignmentsSnapshots {

    @Test func defaults() {
        Snapshots.assertView("all") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                FloatingAlignedContainer(alignment: alignment, spacing: 4) { alignments in
                    ZStack(alignment: alignments.content) {
                        Rectangle().fill(.brown.secondary)
                        .frame(squareOf: 25)

                        Text(alignment.abbreviatedName)
                        .font(.caption)
                        .border(.brown)
                    }
                }
            }
        }
    }

}
