//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import SwiftUI
import Testing


@MainActor
struct CaliperSnapshots {

    @Test(.snapshots(record: .missing, diffTool: .ksdiff))
    func labeled() {
        Snapshots.assertView("all", colorSchemes: .all) {
            Rectangle()
            .fill(.gray.tertiary)
            .frame(squareOf: 50)
            .caliperLabel(
                "top", to: .top,
                span: 30, stem: 20,
                alignment: .outerBottom,
                spacingSize: .all(4)
            )
            .caliperLabel(
                "leading", to: .leading,
                span: 30, stem: 20,
                alignment: .outerTrailing,
                spacingSize: .all(4)
            )
            .caliperLabel(
                "bottom", to: .bottom,
                span: 30, stem: 20,
                alignment: .outerTop,
                spacingSize: .all(4)
            )
            .caliperLabel(
                "trailing", to: .trailing,
                span: 30, stem: 20,
                alignment: .outerLeading,
                spacingSize: .all(4)
            )
        }
    }

}
