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
@Suite(.snapshotTesting)
struct DebugGeometryModifierSnapshots {

    @Test func defaults() {
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


    @Test func geometryProperties() {
        Snapshots.assertView("sizes", spacing: 20) {
            TestViews.quinaryGrayRect()
            .debugGeometry(.height)
            TestViews.quinaryGrayRect()
            .debugGeometry(.width)
            TestViews.quinaryGrayRect()
            .debugGeometry(.size)
        }

        Snapshots.assertView("origin", size: [400, 200]) {
            TestViews.quinaryGraySquare()
            .debugGeometry(.origin)
        }

        Snapshots.assertView("insets", spacing: 30) {
            TestViews.quinaryGrayRect(size: [120, 40])
            .debugGeometry(.safeAreaInsets)
            .safeAreaPadding(EdgeInsets(horizontal: 20, vertical: 15))

            TestViews.quinaryGrayRect(size: [120, 40])
            .debugGeometry(.safeAreaInsets)
        }

        // FIXME: This will report unavailable work till snapshots are migrated to iOS 27.
        Snapshots.assertView("radii", spacing: 40) {
            let container = UnevenRoundedRectangle(even: 5, odd: 10)
            TestViews.quinaryGrayRect(size: [120, 40])
            .debugGeometry(.concentricCornerRadii)
            .containerShape(container)

            TestViews.quinaryGrayRect(size: [120, 40])
            .debugGeometry(.concentricCornerRadii)
        }

        // FIXME: Test radii + paddings.

        // FIXME: Test allGeometry.
    }


    @Test func visibility() {
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
                TestViews.quinaryGrayRect(size: [120, 40])
                    .debugGeometry(.caption("`~visible`"), .size, .visible(true))
                TestViews.quinaryGrayRect(size: [120, 40])
                    .debugGeometry(.caption("`visible`"), .size, .visible(false))
            }
            .safeAreaPadding(.horizontal, 20)
        }
    }


    @Test func bordersWidth() {
        Snapshots.assertView("specials") {
            TestViews.quinaryGrayRect()
            .debugGeometry(.hairline, .caption("`hairline`"))
            .safeAreaPadding(.horizontal, 20)
        }

        let borderWidths: [CGFloat] = [.zero, 1, 2, 4, 8]

        Snapshots.assertView("bordersWidth", size: [200, 240]) {
            VStack(items: borderWidths, spacing: 20) { borderWidth in
                TestViews.quinaryGrayRect()
                .debugGeometry(.bordersWidth(borderWidth), .caption("`\(oneFractional: borderWidth)`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }

        Snapshots.assertView("innerBorderWidth", size: [200, 240]) {
            VStack(items: borderWidths, spacing: 20) { borderWidth in
                TestViews.quinaryGrayRect()
                .debugGeometry(.innerBorderWidth(width: borderWidth), .caption("`\(oneFractional: borderWidth)`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }

        Snapshots.assertView("outerBorderWidth", size: [200, 240]) {
            VStack(items: borderWidths, spacing: 20) { borderWidth in
                TestViews.quinaryGrayRect()
                .debugGeometry(.outerBorderWidth(width: borderWidth), .caption("`\(oneFractional: borderWidth)`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }

        // FIXME: Test inner/outer border style.

        // FIXME: Test inner/outer border visibility, if added.

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


    @Test func bordersVisibility() {
        Snapshots.assertView("specials") {
            TestViews.quinaryGrayRect()
            .debugGeometry(.noBorders, .caption("`noBorders`"))
            .safeAreaPadding(.horizontal, 20)
        }
    }


    @Test func captions() {
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


    @Test func alignments() {
        Snapshots.assertView("all") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                ClearRectangle()
                .debugGeometry(
                    .caption(verbatim: alignment.abbreviatedName),
                    .alignment(alignment)
                )
            }
        }

        Snapshots.assertView("traits", spacing: 20) {
            TestViews.quinaryGrayRect()
            .debugGeometry(.caption("Outer"), .outerAlignment)
            TestViews.quinaryGrayRect()
            .debugGeometry(.caption("Inner"), .innerAlignment)
        }

        Snapshots.assertView("allWithBorders") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                ClearRectangle()
                .debugGeometry(
                    .caption(verbatim: alignment.abbreviatedName),
                    .alignment(alignment),
                    .drawsCaptionBorder
                )
            }
        }

        Snapshots.assertView("hairline") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                ClearRectangle()
                .debugGeometry(
                    .caption(verbatim: alignment.abbreviatedName),
                    .alignment(alignment),
                    .hairline,
                    .drawsCaptionBorder
                )
            }
        }

        Snapshots.assertView("thickBorder") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                ClearRectangle()
                .debugGeometry(
                    .caption(verbatim: alignment.abbreviatedName),
                    .alignment(alignment),
                    .bordersWidth(10),
                    .drawsCaptionBorder
                )
            }
        }

        // FIXME: Test alignments with inner/outer border visibility.

        // FIXME: Test alignments with inner/outer border width.
    }


    @Test func smallSizes() {
        // BUG: Snapshot shows a tiny mismatch between safe area rects and outer stroke.
        Snapshots.assertView("zero") {
            VStack.expandingWidth(alignment: .leading) {
                TestViews.quinaryGraySquare(length: .zero)
                    .debugGeometry()
                    .safeAreaPadding([.top, .leading], 20)
                TestViews.quinaryGraySquare(length: .zero)
                    .debugGeometry(.caption("Caption still visible"), .size)
                    .safeAreaPadding([.top, .leading], 20)
            }
            .padding(20)
        }

        Snapshots.assertView("safeAreas", layout: .hStackTop, spacing: 20) {
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

        Snapshots.assertView("horizontal", spacing: 20) {
            ForEach(hashing: [CGFloat(0), 1, 2, 4, 8, 10, 12]) { height in
                TestViews.quinaryGrayRect(size: [120, height])
                .debugGeometry()
                .safeAreaPadding(.horizontal, 20)
            }
        }

        Snapshots.assertView("vertical", layout: .hStack, spacing: 20) {
            ForEach(hashing: [CGFloat(0), 1, 2, 4, 8, 10, 12]) { width in
                TestViews.quinaryGrayRect(size: [width, 120])
                .debugGeometry()
                .safeAreaPadding(.vertical, 20)
            }
        }
    }


    @Test func safeAreaInsets() {
        Snapshots.assertView("all") {
            let edgeInsets = EdgeInsets(top: 10, leading: 20, bottom: 30, trailing: 40)
            TestViews.quinaryGraySquare()
            .debugGeometry(.safeAreaInsets)
            .safeAreaPadding(edgeInsets)
        }

        Snapshots.assertView("each", layout: .hStack, spacing: 20) {
            VStack(spacing: 20) {
                TestViews.quinaryGraySquare(length: 40)
                    .debugGeometry()
                    .safeAreaPadding(.top, 20)
                TestViews.quinaryGraySquare(length: 40)
                    .debugGeometry()
                    .safeAreaPadding(.leading, 20)
            }
            VStack(spacing: 20) {
                TestViews.quinaryGraySquare(length: 40)
                    .debugGeometry()
                    .safeAreaPadding(.trailing, 20)
                TestViews.quinaryGraySquare(length: 40)
                    .debugGeometry()
                    .safeAreaPadding(.bottom, 20)
            }
        }
    }


    // FIXME: Test container radii.

}
