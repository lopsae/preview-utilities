//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@_spi(ItemStacks)
@_spi(FractionalInterpolation)
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
            VStack(items: [CGFloat(1), 2, 4, 8], spacing: 20) { borderWidth in
                TestViews.quinaryGrayRect()
                .debugGeometry(.bordersWidth(borderWidth), .caption("`\(oneFractional: borderWidth)`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }

        Snapshots.assertView("small") {
            VStack(items: [CGFloat.zero, 0.5, 1], spacing: 20) { borderWidth in
                TestViews.quinaryGrayRect()
                .debugGeometry(.bordersWidth(borderWidth), .caption("`\(oneFractional: borderWidth)`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }

        Snapshots.assertView("large") {
            VStack(items: [CGFloat(8), 10, 15], spacing: 20) { borderWidth in
                TestViews.quinaryGrayRect()
                .debugGeometry(.bordersWidth(borderWidth.asDouble), .caption("`\(oneFractional: borderWidth)`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }
    }


    @Test(.snapshotTesting) func captions() {
        Snapshots.assertView("localized") {
            TestViews.quinaryGraySquare()
                .debugGeometry(.caption("Caption `monospaced`\nNewLine _Formatted_"))
            .safeAreaPadding(20)
        }

        Snapshots.assertView("verbatim") {
            TestViews.quinaryGraySquare()
            .debugGeometry(.caption(verbatim: "Verbatim caption\nNewLines\n_No Formatting_"))
            .safeAreaPadding(20)
        }
    }


    @Test(.snapshotTesting) func smallSizes() {
        // FIXME: Snapshot shows a tiny mismatch between safe area rects and outer stroke.
        Snapshots.assertView("zero") {
            VStack.maxWidth(alignment: .leading) {
                TestViews.quinaryGraySquare(length: .zero)
                    .debugGeometry()
                    .safeAreaPadding([.top, .leading], 20)
                TestViews.quinaryGraySquare(length: .zero)
                    .debugGeometry(.caption("Caption still visible"), .size)
                    .safeAreaPadding([.top, .leading], 20)
            }
            .padding(20)
        }

        Snapshots.assertView("safeAreas") {
            HStack(alignment: .top, spacing: 20) {
                VStack(items: [CGFloat(0), 0.5, 1, 2, 4], spacing: 10) { length in
                    TestViews.quinaryGraySquare(length: length)
                    .debugGeometry()
                    .safeAreaPadding(10)
                }
                VStack(items: [CGFloat(6), 8, 10, 12], spacing: 10) { length in
                    TestViews.quinaryGraySquare(length: length)
                    .debugGeometry()
                    .safeAreaPadding(10)
                }
            }
        }

        Snapshots.assertView("horizontal") {
            VStack(items: [CGFloat(0), 1, 2, 4, 8, 10, 12], spacing: 20) { height in
                TestViews.quinaryGrayRect(size: [120, height])
                .debugGeometry()
                .safeAreaPadding(.horizontal, 20)
            }
        }

        Snapshots.assertView("vertical") {
            HStack(items: [CGFloat(0), 1, 2, 4, 8, 10, 12], spacing: 20) { width in
                TestViews.quinaryGrayRect(size: [width, 120])
                .debugGeometry()
                .safeAreaPadding(.vertical, 20)
            }
        }
    }


    // FIXME: Test alignments, use drawsCaptionBorder
    // FIXME: Test insets of different sizes.

}
