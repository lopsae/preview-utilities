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
struct CaptionRectangleSnapshots {

    @Test func defaults() {
        let rectSize: CGSize = [120, 40]

        Snapshots.assertView("default", spacing: 10, colorSchemes: .all) {
            CaptionRectangle("Default", size: rectSize)
            CaptionRectangle("Thick Border", borderWidth: 4, size: rectSize)
        }

        Snapshots.assertView("color", spacing: 10, colorSchemes: .all) {
            CaptionRectangle("Color", color: .pink, size: rectSize)
            CaptionRectangle("_Formatted_ Caption", color: .pink, size: rectSize)
            CaptionRectangle("Thick Border", color: .pink, borderWidth: 4, size: rectSize)
        }

        Snapshots.assertView("styled", spacing: 10, colorSchemes: .all) {
            CaptionRectangle("Styled", fill: .brown, stroke: .pink, size: rectSize)
            CaptionRectangle("_Formatted_ Caption", fill: .brown, stroke: .pink, size: rectSize)
            CaptionRectangle("Thick Border", fill: .brown, stroke: .pink, borderWidth: 4, size: rectSize)
        }
    }


    @Test func sizes() {
        let long: CGFloat = 120
        let short: CGFloat = 40

        Snapshots.assertView("expanding", spacing: 10) {
            CaptionRectangle("Expanding\nTall", color: .pink)
            .frame(size: [short, long])

            CaptionRectangle("Expanding\nWide", color: .pink)
            .frame(size: [long, short])
        }

        Snapshots.assertView("fixedWidth") {
            CaptionRectangle("Expanding", color: .pink, width: short)
            .frame(size: .square(of: long))
            .background(.quinary)
        }

        Snapshots.assertView("fixedHeight") {
            CaptionRectangle("Expanding", color: .pink, height: short)
            .frame(size: .square(of: long))
            .background(.quinary)
        }
    }


    @Test func alignments() {
        Snapshots.assertView("all") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                let stroke: Color = alignment == .center ? .pink : .clear
                // TODO: Needs verbatim.
                CaptionRectangle("\(alignment.abbreviatedName)", fill: .clear, stroke: stroke, traits: .alignment(alignment))
            }
        }

        Snapshots.assertView("allWithBorders") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                let stroke: Color = alignment == .center ? .pink : .clear
                // TODO: Needs verbatim.
                CaptionRectangle("\(alignment.abbreviatedName)", fill: .clear, stroke: stroke, traits: .alignment(alignment), .drawsCaptionBorder)
            }
        }

        Snapshots.assertView("thickBorder") {
            TestViews.quinaryGraySquare()
            .overlayFloatingAlignments { alignment in
                let stroke: Color = alignment == .center ? .pink : .clear
                // TODO: Needs verbatim.
                CaptionRectangle("\(alignment.abbreviatedName)", fill: .clear, stroke: stroke, borderWidth: 4, traits: .alignment(alignment))
            }
        }
    }


    @Test func geometry() {
        let rectSize: CGSize = [120, 40]
        Snapshots.assertView("all", spacing: 10) {
            CaptionRectangle("Caption", color: .pink, size: rectSize, traits: .size)
            CaptionRectangle("Caption", color: .pink, size: rectSize, traits: .width)
            CaptionRectangle("Caption", color: .pink, size: rectSize, traits: .height)
        }
    }

}
