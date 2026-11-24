//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
@Suite(.snapshotTesting)
struct CaliperSnapshots {

    @Test func labeledTo() {
        Snapshots.assertView("all", colorSchemes: .all) {
            TestViews.quinaryGraySquare(length: 50)
            .caliperLabel(
                "towards\ntop", to: .top,
                span: 30, stem: 20,
                alignment: .outerBottom,
                spacingSize: .square(of: 8)
            )
            .caliperLabel(
                "towards\nleading", to: .leading,
                span: 10, stem: 10,
                alignment: .outerTrailing,
                spacingSize: .square(of: 4)
            )
            .caliperLabel(
                "towards\nbottom", to: .bottom,
                span: 30, stem: 20,
                alignment: .outerTop,
                spacingSize: .square(of: 8)
            )
            .caliperLabel(
                "towards\ntrailing", to: .trailing,
                span: 10, stem: 10,
                alignment: .outerLeading,
                spacingSize: .square(of: 4)
            )
        }
    }


    @Test func labeledFrom() {
        Snapshots.assertView("defaults", colorSchemes: .all) {
            TestViews.quinaryGraySquare(length: 50)
            .caliperLabel("from\ntop",      from: .top)
            .caliperLabel("from\nleading",  from: .leading)
            .caliperLabel("from\nbottom",   from: .bottom)
            .caliperLabel("from\ntrailing", from: .trailing)
        }

        Snapshots.assertView("custom") {
            TestViews.quinaryGraySquare(length: 50)
            .caliperLabel(
                "from\ntop", from: .top,
                span: 20, stem: 10, spacing: 8
            )
            .caliperLabel(
                "from\nleading", from: .leading,
                span: 40, stem: 20, spacing: .zero
            )
            .caliperLabel(
                "from\nbottom", from: .bottom,
                span: 20, stem: 10, spacing: 8
            )
            .caliperLabel(
                "from\ntrailing", from: .trailing,
                span: 40, stem: 20, spacing: .zero
            )
        }
    }

}
