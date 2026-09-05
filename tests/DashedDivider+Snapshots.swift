//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct DashedDividerSnapshots {

    @Test(.snapshotTesting) func lineWidth() {
        Snapshots.assertView("horizontal", colorSchemes: .all) {
            VStack(spacing: 20) {
                DashedDivider()
                DashedDivider(lineWidth: 2)
                DashedDivider(lineWidth: 4)
                DashedDivider(lineWidth: 8)
            }
            .padding(.vertical, 16)
            .border(.red.secondary)
            .padding(.horizontal, 16)
        }

        Snapshots.assertView("vertical", colorSchemes: .all) {
            HStack(spacing: 20) {
                DashedDivider(axis: .vertical)
                DashedDivider(axis: .vertical, lineWidth: 2)
                DashedDivider(axis: .vertical, lineWidth: 4)
                DashedDivider(axis: .vertical, lineWidth: 8)
            }
            .padding(.horizontal, 16)
            .border(.red.secondary)
            .padding(.vertical, 16)
        }
    }

}
