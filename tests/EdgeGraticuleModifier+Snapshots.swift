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

        Snapshots.assertView("empty", colorSchemes: .all) {
            TestContent.square
            .edgeGraticule()
        }
    }


    @Test(.snapshots(record: .missing))
    func spacingParameters() {
        Snapshots.assertView("onlyInsetSpacing") {
            TestContent.square
            .edgeGraticule(insetSpacing: 25)
        }

        Snapshots.assertView("insetSpacingAndCount") {
            TestContent.square
            .edgeGraticule(insetSpacing: 10, insetCount: 2)
        }

        Snapshots.assertView("onlyInsetCount") {
            TestContent.square
            .edgeGraticule(insetCount: 3)
        }

        Snapshots.assertView("onlyOutsetSpacing") {
            TestContent.square
            .edgeGraticule(outsetSpacing: 25)
        }

        Snapshots.assertView("outsetSpacingAndCount") {
            TestContent.square
            .edgeGraticule(outsetSpacing: 20, outsetCount: 2)
        }

        Snapshots.assertView("onlyOutsetCount") {
            TestContent.square
            .edgeGraticule(outsetCount: 3)
        }
    }


    @Test(.snapshots(record: .missing))
    func insetTrait() {
        Snapshots.assertView("spacingAndCount") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 10, outsetSpacing: 20,
                .inset(.horizontal, spacing: 20, count: 2)
            )
        }

        Snapshots.assertView("onlySpacing") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 10, outsetSpacing: 20,
                .inset(.horizontal, spacing: 20)
            )
        }

        Snapshots.assertView("onlyCount") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 10, outsetSpacing: 20,
                .inset(.horizontal, count: 3)
            )
        }
    }

}
