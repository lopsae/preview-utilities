//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct EdgeGraticuleModifierSnapshots {

    enum TestContent {
        // FIXME: Remove if not used.
//        static let single: some View =
//            Text("Ag")
//            .font(.title.pointSize(100))
//
//        static let multi: some View =
//            Text("Sphinx\nof Black\nQuartz")
//            .font(.largeTitle)

        static let square: some View =
            Rectangle()
            .fill(.gray.quinary)
            .frame(squareOf: 100)
    }


    @Test(.snapshots(record: .missing))
    func spacings() {
        Snapshots.assertView("sameSpacing", colorSchemes: .all) {
            TestContent.square
            .edgeGraticule(spacing: 25)
        }

        Snapshots.assertView("separateSpacing", colorSchemes: .all) {
            TestContent.square
            .edgeGraticule(insetSpacing: 10, insetCount: 3, outsetSpacing: 20, outsetCount: 2)
        }
    }


    // FIXME: Add tests for spacing combinations
    // FIXME: Add tests for traits.

}
