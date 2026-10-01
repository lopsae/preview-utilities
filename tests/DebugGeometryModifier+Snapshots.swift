//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct DebugGeometryModifierSnapshots {

    @Test(.snapshotTesting) func defaults() {
        Snapshots.assertView("default", colorSchemes: .all) {
            TestViews.quinaryGraySquare
            .debugGeometry()
            .safeAreaPadding(20)
        }

        Snapshots.assertView("caption", size: [400, 200], colorSchemes: .all) {
            TestViews.quinaryGraySquare
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
            TestViews.quinaryGraySquare
            .debugGeometry(.origin)
        }

        Snapshots.assertView("insets") {
            TestViews.quinaryGraySquare
            .debugGeometry(.safeAreaInsets)
            .safeAreaPadding(20)
        }
    }

    // FIXME: Test hidden/visible.
    // FIXME: Test hairline, no borders, width
    // FIXME: Test caption, localized/verbatim
    // FIXME: Test alignments, use drawsCaptionBorder

}
