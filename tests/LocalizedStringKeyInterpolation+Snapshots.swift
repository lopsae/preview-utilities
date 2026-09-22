//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI
import Testing


@MainActor
struct LocalizedStringKeyInterpolationSnapshots {

    @Test(.snapshotTesting) func iconAndLabel() {
        Snapshots.assertView("non-breaking") {
            VStack {
                Text("!Breaking \(systemImage: "ladybug", label: "Icon Label", breaking: true) breaking")
                .expandingWidthFrame(textAlignment: .leading)
                .foregroundStyle(.tertiary)

                Text("!Breaking \(systemImage: "ladybug", label: "Icon Label") should remain connected")
                .expandingWidthFrame(textAlignment: .leading)
            }
            .frame(squareOf: 150)
            .border(.orange.secondary)
        }

        Snapshots.assertView("breaking") {
            Text("Breaking \(systemImage: "ladybug", label: "Icon Label", breaking: true) should break after \"Icon\"")
            .expandingWidthFrame(textAlignment: .leading)
            .frame(squareOf: 150)
            .border(.orange.secondary)
        }

        // Image stays attached to immediate label, even when breaking.
        Snapshots.assertView("image-nbsp") {
            Text("Even breaking \(systemImage: "ladybug", label: "Icon Label", breaking: true) should keep image connected")
            .expandingWidthFrame(textAlignment: .leading)
            .frame(squareOf: 150)
            .border(.orange.secondary)
        }
    }

}
