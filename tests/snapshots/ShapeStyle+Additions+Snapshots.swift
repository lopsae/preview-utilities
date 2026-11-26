//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import SwiftUI
import Testing


@MainActor
@Suite(.snapshotTesting)
struct ShapeStyleAdditionsSnapshots {

    @Test func anyShapeStyle() {
        Snapshots.assertView("ifThenElse", layout: .hStack, spacing: 20) {
            Image(systemName: "ladybug")

            Image(systemName: "ladybug")
            .foregroundStyle(.if(true, then: .green, else: .secondary))

            Image(systemName: "ladybug")
            .foregroundStyle(.if(false, then: .green, else: .secondary))
        }
    }

}
