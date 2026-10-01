//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@_spi(ItemStacks) import PreviewUtilities

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
                TestViews.quinaryGrayRect()
                    .debugGeometry(.height)
                TestViews.quinaryGrayRect()
                    .debugGeometry(.width)
                TestViews.quinaryGrayRect()
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
                TestViews.quinaryGrayRect(size: [120, 40])
                    .debugGeometry(.caption("`~hidden`"), .size)
                TestViews.quinaryGrayRect(size: [120, 40])
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
                TestViews.quinaryGrayRect()
                    .debugGeometry(.hairline, .caption("`hairline`"))
                TestViews.quinaryGrayRect()
                    .debugGeometry(.noBorders, .caption("`noBorders`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }

        Snapshots.assertView("bordersWidth") {
            // FIXME: Try to use item VStack.
            VStack(items: [Int(1), 2, 4, 8], spacing: 20) { borderWidth in
                TestViews.quinaryGrayRect()
                .debugGeometry(.bordersWidth(borderWidth.asDouble), .caption("`\(borderWidth)`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }

        Snapshots.assertView("small") {
            VStack(items: [CGFloat.zero, 0.5, 1], spacing: 20) { borderWidth in
                TestViews.quinaryGrayRect()
                .debugGeometry(.bordersWidth(borderWidth), .caption("`\(borderWidth, format: .fractionLength(1))`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }

        Snapshots.assertView("large") {
            VStack(items: [Int(8), 10, 15], spacing: 20) { borderWidth in
                TestViews.quinaryGrayRect()
                .debugGeometry(.bordersWidth(borderWidth.asDouble), .caption("`\(borderWidth)`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }
    }


    // FIXME: Test caption, localized/verbatim
    // FIXME: Test alignments, use drawsCaptionBorder
    // FIXME: Test insets of different sizes.
    // FIXME: Test small and zero sizes.

}
