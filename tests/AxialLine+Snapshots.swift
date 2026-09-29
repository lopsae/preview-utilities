//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct AxialLineSnapshots {

    @Test(.snapshotTesting) func lineWidth() {
        Snapshots.assertView("horizontal", colorSchemes: .all) {
            VStack(spacing: 20) {
                ForEach([1, 2, 4, 8], id: \.self) { lineWidth in
                    AxialLine(.horizontal, style: .secondary, lineWidth: lineWidth)
                }
            }
            .padding(.vertical, 16)
            .border(.red.secondary)
            .padding(.horizontal, 16)
        }

        Snapshots.assertView("vertical", colorSchemes: .all) {
            HStack(spacing: 20) {
                ForEach([1, 2, 4, 8], id: \.self) { lineWidth in
                    AxialLine(.vertical, style: .secondary, lineWidth: lineWidth)
                }
            }
            .padding(.horizontal, 16)
            .border(.red.secondary)
            .padding(.vertical, 16)
        }
    }


    @Test(.snapshotTesting) func lineCaps() {
        Snapshots.assertView("horizontal") {
            VStack(spacing: 20) {
                ForEach([CGLineCap.butt, .round, .square], id: \.self) { lineCap in
                    AxialLine(.horizontal, style: .secondary, lineWidth: 16, lineCap: lineCap)
                }
            }
            .padding(.vertical, 16)
            .border(.red.secondary)
            .padding(.horizontal, 16)
        }

        Snapshots.assertView("vertical") {
            HStack(spacing: 20) {
                ForEach([CGLineCap.butt, .round, .square], id: \.self) { lineCap in
                    AxialLine(.vertical, style: .secondary, lineWidth: 16, lineCap: lineCap)
                }
            }
            .padding(.horizontal, 16)
            .border(.red.secondary)
            .padding(.vertical, 16)
        }
    }

}
