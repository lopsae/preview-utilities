//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@_spi(ItemStacks)
@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct AxialLineSnapshots {

    @Test(.snapshotTesting) func lineWidth() {
        Snapshots.assertView("horizontal", colorSchemes: .all) {
            VStack(items: [1, 2, 4, 8], spacing: 20) { lineWidth in
                AxialLine(.horizontal, style: .secondary, lineWidth: lineWidth)
            }
            .padding(.vertical, 16)
            .border(.red.secondary)
            .padding(.horizontal, 16)
        }

        Snapshots.assertView("vertical", colorSchemes: .all) {
            HStack(items: [1, 2, 4, 8], spacing: 20) { lineWidth in
                AxialLine(.vertical, style: .secondary, lineWidth: lineWidth)
            }
            .padding(.horizontal, 16)
            .border(.red.secondary)
            .padding(.vertical, 16)
        }
    }


    @Test(.snapshotTesting) func lineCaps() {
        Snapshots.assertView("horizontal") {
            VStack(items: CGLineCap.allCases, spacing: 20) { lineCap in
                AxialLine(.horizontal, style: .secondary, lineWidth: 16, lineCap: lineCap)
            }
            .padding(.vertical, 16)
            .border(.red.secondary)
            .padding(.horizontal, 16)
        }

        Snapshots.assertView("vertical") {
            HStack(items: CGLineCap.allCases, spacing: 20) { lineCap in
                AxialLine(.vertical, style: .secondary, lineWidth: 16, lineCap: lineCap)
            }
            .padding(.horizontal, 16)
            .border(.red.secondary)
            .padding(.vertical, 16)
        }
    }

}
