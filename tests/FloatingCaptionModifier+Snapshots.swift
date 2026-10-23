//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@_spi(ItemStacks)
import PreviewUtilities

import SwiftUI
import Testing


@MainActor
@Suite(.snapshotTesting)
struct FloatingCaptionModifierSnapshots {

    @Test func defaults() {
        let rectSize: CGSize = [120, 40]
        Snapshots.assertView("default", spacing: 10, colorSchemes: .all) {
            TestViews.quinaryGrayRect(size: rectSize)
            .floatingCaption("Floating Caption")

            TestViews.quinaryGrayRect(size: rectSize)
            .floatingCaption("_Formatted_ `Caption`")

            TestViews.quinaryGrayRect(size: rectSize)
            .floatingCaption(verbatim: "_Verbatim_ Caption")
        }

        Snapshots.assertView("noCaptions", spacing: 10, colorSchemes: .all) {
            TestViews.quinaryGrayRect(size: rectSize)
            .floatingCaption()

            TestViews.quinaryGrayRect(size: rectSize)
            .floatingCaption(.size)

            TestViews.quinaryGrayRect(size: rectSize)
            .floatingCaption(.captionStyle(.orange), .borderStyle(.teal))
        }

        Snapshots.assertView("styles", spacing: 10, colorSchemes: .all) {
            TestViews.quinaryGrayRect(size: rectSize)
            .floatingCaption("Styled Caption", .captionStyle(.orange), .borderStyle(.teal))

            TestViews.quinaryGrayRect(size: rectSize)
            .floatingCaption("Color Caption", .colorStyle(.teal))
        }
    }



    @Test func alignments() {
        Snapshots.assertView("all") {
            TestViews.quinaryGraySquare()
            .overlay {
                ForEach(FloatingAlignment.allCases) { alignment in
                    ClearRectangle()
                    .floatingCaption(verbatim: alignment.abbreviatedName, alignment: alignment)
                }
            }
        }

        Snapshots.assertView("defaultBorder") {
            TestViews.quinaryGraySquare()
            .overlay {
                ForEach(FloatingAlignment.allCases) { alignment in
                    ClearRectangle()
                    .floatingCaption(
                        verbatim: alignment.abbreviatedName,
                        alignment: alignment,
                        .borderStyle(.teal)
                    )
                }
            }
        }

        Snapshots.assertView("hairlineBorder") {
            TestViews.quinaryGraySquare()
            .overlay {
                ForEach(FloatingAlignment.allCases) { alignment in
                    ClearRectangle()
                    .floatingCaption(
                        verbatim: alignment.abbreviatedName,
                        alignment: alignment,
                        .borderStyle(.teal),
                        .borderWidth(1)
                    )
                }
            }
        }

        Snapshots.assertView("thickBorder") {
            TestViews.quinaryGraySquare()
            .overlay {
                ForEach(FloatingAlignment.allCases) { alignment in
                    ClearRectangle()
                    .floatingCaption(
                        verbatim: alignment.abbreviatedName,
                        alignment: alignment,
                        .borderStyle(.teal),
                        .borderWidth(10)
                    )
                }
            }
        }
    }


    @Test func padding() {
        Snapshots.assertView("default") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                ClearRectangle()
                .floatingCaption(
                    verbatim: alignment.abbreviatedName,
                    alignment: alignment,
                    // TODO: actually sets the padding to default padding. In the future default
                    // padding should be a fixed value: 2.
                    .padding(nil)
                )
            }
        }

        Snapshots.assertView("zero") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                ClearRectangle()
                .floatingCaption(
                    verbatim: alignment.abbreviatedName,
                    alignment: alignment,
                    .padding(.zero)
                )
            }
        }

        Snapshots.assertView("thick") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                ClearRectangle()
                .floatingCaption(
                    verbatim: alignment.abbreviatedName,
                    alignment: alignment,
                    .padding(10)
                )
            }
        }
    }


    @Test func geometry() {
        let rectSize: CGSize = [120, 40]
        Snapshots.assertView("all", spacing: 10) {
            TestViews.quinaryGrayRect(size: rectSize)
            .floatingCaption("Caption", .size)

            TestViews.quinaryGrayRect(size: rectSize)
            .floatingCaption("Caption", .width)

            TestViews.quinaryGrayRect(size: rectSize)
            .floatingCaption("Caption", .height)
        }

        Snapshots.assertView("aligned", spacing: 10) {
            TestViews.quinaryGrayRect(size: rectSize)
            .floatingCaption("Caption", alignment: .leading, .size)

            TestViews.quinaryGrayRect(size: rectSize)
            .floatingCaption("Caption", alignment: .leading, .width)

            TestViews.quinaryGrayRect(size: rectSize)
            .floatingCaption("Caption", alignment: .leading, .height)
        }
    }

    @Test func smallSizes() {
        Snapshots.assertView("zero", spacing: 10) {
            TestViews.quinaryGraySquare(length: .zero)
            .floatingCaption()
            .padding(10)
            .border(.gray.quinary)

            TestViews.quinaryGraySquare(length: .zero)
            .floatingCaption("Caption")
            .padding(10)
            .border(.gray.quinary)

            TestViews.quinaryGraySquare(length: .zero)
            .floatingCaption("Caption", alignment: .leading)
            .padding(10)
            .border(.gray.quinary)

            TestViews.quinaryGraySquare(length: .zero)
            .floatingCaption("Caption", alignment: .leading, .colorStyle(.teal))
            .padding(10)
            .border(.gray.quinary)
        }

        // BUG: At small sizes, the border disappears. May need special treatment like DebugGeometry.
        Snapshots.assertView("square") {
            VStack(items: [CGFloat(0.5), 1, 2, 4], spacing: 10) { length in
                TestViews.quinaryGraySquare(length: length)
                .floatingCaption("Caption", alignment: .outerTrailing, .colorStyle(.teal))
            }
        }

        Snapshots.assertView("wide") {
            VStack(items: [CGFloat(0.5), 1, 2, 4, 8], spacing: 20) { height in
                TestViews.quinaryGrayRect(size: [120, height])
                .floatingCaption(.borderStyle(.teal))
            }
        }

        Snapshots.assertView("tall") {
            HStack(items: [CGFloat(0.5), 1, 2, 4, 8], spacing: 20) { width in
                TestViews.quinaryGrayRect(size: [width, 120])
                .floatingCaption(.borderStyle(.teal))
            }
        }
    }

}
