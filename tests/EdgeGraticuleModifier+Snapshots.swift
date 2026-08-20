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

        Snapshots.assertView("zeroCount") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 10, outsetSpacing: 20,
                .inset(.horizontal, count: 0)
            )
        }

        Snapshots.assertView("countPerEdge") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 5, outsetSpacing: 20,
                .inset(.top, count: 2),
                .inset(.leading, count: 3),
                .inset(.bottom, count: 4),
                .inset(.trailing, count: 5)
            )
        }
    }


    @Test(.snapshots(record: .missing))
    func outsetTrait() {
        Snapshots.assertView("spacingAndCount") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 10, outsetSpacing: 20,
                .outset(.vertical, spacing: 10, count: 2)
            )
        }

        Snapshots.assertView("onlySpacing") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 10, outsetSpacing: 20,
                .outset(.vertical, spacing: 10)
            )
        }

        Snapshots.assertView("onlyCount") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 10, outsetSpacing: 10,
                .outset(.vertical, count: 3)
            )
        }

        Snapshots.assertView("zeroCount") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 10, outsetSpacing: 20,
                .outset(.vertical, count: 0)
            )
        }

        Snapshots.assertView("countPerEdge") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 10, outsetSpacing: 5,
                .outset(.top, count: 2),
                .outset(.leading, count: 3),
                .outset(.bottom, count: 4),
                .outset(.trailing, count: 5)
            )
        }
    }


    @Test(.snapshots(record: .missing))
    func straddleTrait() {
        Snapshots.assertView("spacingAndCount") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 20, outsetSpacing: 20,
                .straddle(.leading, spacing: 10, count: 2)
            )
        }

        Snapshots.assertView("onlySpacing") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 20, outsetSpacing: 20,
                .straddle(.leading, spacing: 10)
            )
        }

        Snapshots.assertView("onlyCount") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 20, outsetSpacing: 20,
                .straddle(.leading, count: 2)
            )
        }

        Snapshots.assertView("zeroCount") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 10, outsetSpacing: 20,
                .straddle(.leading, count: 0)
            )
        }

        Snapshots.assertView("countPerEdge") {
            TestContent.square
            .edgeGraticule(
                insetSpacing: 10, outsetSpacing: 5,
                .straddle(.top, count: 2),
                .straddle(.leading, count: 3),
                .straddle(.bottom, count: 4),
                .straddle(.trailing, count: 5)
            )
        }
    }

    @Test(.snapshots(record: .missing))
    func empties() {
        Snapshots.assertView("zeroSpacing") {
            TestContent.square
            .edgeGraticule(spacing: .zero)
        }

        // Graticule starts empty from no parameters.
        Snapshots.assertView("someEmpty") {
            TestContent.square
            .edgeGraticule(
                .inset(.leading, count: .zero),
                .outset(.trailing, count: .zero)
            )
        }

        // Graticule starts empty from no parameters, spacings set through traits.
        Snapshots.assertView("emptyWithSpacings") {
            TestContent.square
            .edgeGraticule(
                .inset(.top, spacing: 25),
                .outset(.bottom, spacing: 25)
            )
        }
    }

}
