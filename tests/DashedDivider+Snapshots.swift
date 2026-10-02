//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@_spi(ItemStacks)
import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct DashedDividerSnapshots {

    @Test(.snapshotTesting) func lineWidth() {
        Snapshots.assertView("defaults", colorSchemes: .all) {
            ZStack {
                VStack(spacing: 10) {
                    DashedDivider()
                    DashedDivider(axis: .horizontal)
                }
                DashedDivider(axis: .vertical)
            }
            .padding(20)
        }

        Snapshots.assertView("horizontal", colorSchemes: .all) {
            VStack(items: [1, 2, 4, 8], spacing: 20) { lineWidth in
                DashedDivider(lineWidth: lineWidth)
            }
            .padding(.vertical, 16)
            .border(.red.secondary)
            .padding(.horizontal, 16)
        }

        Snapshots.assertView("vertical", colorSchemes: .all) {
            HStack(items: [1, 2, 4, 8], spacing: 20) { lineWidth in
                DashedDivider(axis: .vertical, lineWidth: lineWidth)
            }
            .padding(.horizontal, 16)
            .border(.red.secondary)
            .padding(.vertical, 16)
        }
    }

}
