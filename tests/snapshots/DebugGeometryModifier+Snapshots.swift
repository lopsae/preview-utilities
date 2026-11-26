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
        Snapshots.assertView("hidden", spacing: 20) {
            TestViews.quinaryGrayRect(size: [120, 40])
            .debugGeometry(.caption("`~hidden`"), .size)
            .safeAreaPadding(.horizontal, 20)
            TestViews.quinaryGrayRect(size: [120, 40])
            .debugGeometry(.caption("`hidden`"), .size, .hidden)
            .safeAreaPadding(.horizontal, 20)
        }

        Snapshots.assertView("visible", spacing: 20) {
            TestViews.quinaryGrayRect(size: [120, 40])
            .debugGeometry(.caption("`~visible`"), .size, .visible(true))
            .safeAreaPadding(.horizontal, 20)
            TestViews.quinaryGrayRect(size: [120, 40])
            .debugGeometry(.caption("`visible`"), .size, .visible(false))
            .safeAreaPadding(.horizontal, 20)
        }

        Snapshots.assertView("noBorders") {
            TestViews.quinaryGrayRect()
            .debugGeometry(.noBorders, .caption("`noBorders`"))
            .safeAreaPadding(.horizontal, 20)
        }

        // FIXME: Test inner/outer border visibility, if added.

        // FIXME: Move border visibility here.

        Snapshots.assertView("noSafeAreas", spacing: 10) {
            Group {
                TestViews.quinaryGrayRect()
                .debugGeometry(.caption("`noSafeAreas`"), .noSafeAreas)
                TestViews.quinaryGrayRect()
                .debugGeometry(.caption("precedence"), .noSafeAreas, .safeAreasStyle(.orange))
                TestViews.quinaryGrayRect()
                .debugGeometry(.caption("styled"), .safeAreasStyle(.orange))
            }
            .safeAreaPadding(10)
        }
    }


    @Test func bordersWidth() {
        Snapshots.assertView("hairline", spacing: 20) {
            TestViews.quinaryGrayRect()
            .debugGeometry(.hairline, .caption("`hairline`"))
            .safeAreaPadding(.horizontal, 20)
            TestViews.quinaryGrayRect()
            .debugGeometry(
                .caption("override"),
                .innerBorderWidth(10),
                .outerBorderWidth(10),
                .hairline,
            )
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
                .debugGeometry(.innerBorderWidth(borderWidth), .caption("`\(oneFractional: borderWidth)`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }

        Snapshots.assertView("outerBorderWidth", size: [200, 240]) {
            VStack(items: borderWidths, spacing: 20) { borderWidth in
                TestViews.quinaryGrayRect()
                .debugGeometry(.outerBorderWidth(borderWidth), .caption("`\(oneFractional: borderWidth)`"))
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
                .debugGeometry(.bordersWidth(borderWidth), .caption("`\(oneFractional: borderWidth)`"))
            }
            .safeAreaPadding(.horizontal, 20)
        }
    }


    // FIXME: Move to styles, add safeareas styles too.
    @Test func bordersStyle() {
        Snapshots.assertView("innerBorderStyle", spacing: 20, colorSchemes: .all) {
            TestViews.quinaryGrayRect()
            .debugGeometry(.innerBorderStyle(.orange))
            .safeAreaPadding(.horizontal, 20)
            TestViews.quinaryGrayRect()
            .debugGeometry(.innerBorderStyle(.primary))
            .safeAreaPadding(.horizontal, 20)
            TestViews.quinaryGrayRect()
            .debugGeometry(.innerBorderStyle(.clear))
            .safeAreaPadding(.horizontal, 20)
        }

        Snapshots.assertView("outerBorderStyle", spacing: 20, colorSchemes: .all) {
            TestViews.quinaryGrayRect()
            .debugGeometry(.outerBorderStyle(.orange))
            .safeAreaPadding(.horizontal, 20)
            TestViews.quinaryGrayRect()
            .debugGeometry(.outerBorderStyle(.primary))
            .safeAreaPadding(.horizontal, 20)
            TestViews.quinaryGrayRect()
            .debugGeometry(.outerBorderStyle(.clear))
            .safeAreaPadding(.horizontal, 20)
        }

        // FIXME: Test clearStyles.
    }


    @Test func styles() {
        Snapshots.assertView("clearStylesExceptOnCenter", spacing: 20) {
            TestViews.quinaryGrayRect()
            .debugGeometry(.caption("leading"), .alignment(.leading), .clearStylesExceptOnCenter)
            .safeAreaPadding(.horizontal, 20)
            TestViews.quinaryGrayRect()
            .debugGeometry(.caption("center"), .alignment(.center), .clearStylesExceptOnCenter)
            .safeAreaPadding(.horizontal, 20)
            TestViews.quinaryGrayRect()
            .debugGeometry(.caption("trailing"), .alignment(.trailing), .clearStylesExceptOnCenter)
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
        // FIXME: Figure out if style can be used to paint borders only once.

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

        let baseTraits: (FloatingAlignment) -> DebugGeometryModifier.Configuration.Trait = { alignment in
            .traits([
                .caption(verbatim: alignment.abbreviatedName),
                .alignment(alignment),
                .innerBorderStyle(.red.opacity(0.6)),
                .outerBorderStyle(.blue.opacity(0.6)),
                .clearStylesExceptOnCenter,
                .drawsCaptionBorder
            ])
        }

        Snapshots.assertView("allWithBorders") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                ClearRectangle()
                .debugGeometry(
                    baseTraits(alignment)
                )
            }
        }

        // FIXME: With clear borders.

        Snapshots.assertView("hairline") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                ClearRectangle()
                .debugGeometry(
                    baseTraits(alignment),
                    .hairline,
                )
            }
        }

        Snapshots.assertView("thickBorders") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                ClearRectangle()
                .debugGeometry(
                    baseTraits(alignment),
                    .bordersWidth(10),
                )
            }
        }

        Snapshots.assertView("thickInner") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                ClearRectangle()
                .debugGeometry(
                    baseTraits(alignment),
                    .innerBorderWidth(10),
                    .outerBorderWidth(2),
                )
            }
        }



        // FIXME: Test alignments with inner/outer border width.

        // FIXME: Test alignments with inner/outer border visibility.
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

        // FIXME: Test safeAreas set in the owner stack.
        // FIXME: Test safeAreas set in the owner stack with negative paddings?
    }


    // FIXME: Test container radii.

}
