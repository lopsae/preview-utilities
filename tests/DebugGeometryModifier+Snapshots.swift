//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct DebugGeometryModifierSnapshots {

    @Test(.snapshotTesting) func defaults() {
        Snapshots.assertView("default", colorSchemes: .all) {
            TestViews.quinaryGraySquare()
            .debugGeometry()
            .safeAreaPadding(20)
        }

        Snapshots.assertView("caption", size: [400, 200], colorSchemes: .all) {
            TestViews.quinaryGraySquare()
            .debugGeometry(.caption("_Formatted_ Caption"), .allGeometry)
            .safeAreaPadding(20)
        }
    }


    @Test(.snapshotTesting) func geometryProperties() {
        Snapshots.assertView("sizes") {
            VStack(spacing: 20) {
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.height)
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.width)
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.size)
            }
        }

        Snapshots.assertView("origin", size: [400, 200]) {
            TestViews.quinaryGraySquare()
            .debugGeometry(.origin)
        }

        Snapshots.assertView("insets") {
            TestViews.quinaryGraySquare()
            .debugGeometry(.safeAreaInsets)
            .safeAreaPadding(20)
        }
    }


    @Test(.snapshotTesting) func visibility() {
        Snapshots.assertView("hidden") {
            VStack(spacing: 20) {
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 40])
                    .debugGeometry(.caption("`~hidden`"), .size)
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 40])
                    .debugGeometry(.caption("`hidden`"), .size, .hidden)
            }
            .safeAreaPadding(.horizontal, 20)
        }

        Snapshots.assertView("visible") {
            VStack(spacing: 20) {
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 40])
                    .debugGeometry(.caption("`~visible`"), .size, .visible(true))
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 40])
                    .debugGeometry(.caption("`visible`"), .size, .visible(false))
            }
            .safeAreaPadding(.horizontal, 20)
        }
    }


    @Test(.snapshotTesting) func borders() {
        Snapshots.assertView("special") {
            VStack(spacing: 20) {
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.hairline, .caption("`hairline`"))
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.noBorders, .caption("`noBorders`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }


        Snapshots.assertView("bordersWidth") {
            // FIXME: Try to use item VStack.
            VStack(spacing: 20) {
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.bordersWidth(1), .caption("`1`"))
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.bordersWidth(2), .caption("`2`"))
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.bordersWidth(4), .caption("`4`"))
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.bordersWidth(8), .caption("`8`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }

        Snapshots.assertView("small") {
            VStack(spacing: 20) {
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.bordersWidth(.zero), .caption("`zero`"))
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.bordersWidth(0.5), .caption("`0.5`"))
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.bordersWidth(.one), .caption("`one`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }

        Snapshots.assertView("large") {
            VStack(spacing: 20) {
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.bordersWidth(8), .caption("`8`"))
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.bordersWidth(10), .caption("`10`"))
                Rectangle()
                    .fill(.gray.quinary)
                    .frame(size: [120, 20])
                    .debugGeometry(.bordersWidth(15), .caption("`15`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }
    }


    // FIXME: Test caption, localized/verbatim
    // FIXME: Test alignments, use drawsCaptionBorder
    // FIXME: Test insets of different sizes.
    // FIXME: Test small and zero sizes.

}
