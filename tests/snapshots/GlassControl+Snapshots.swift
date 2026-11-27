//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing
import SwiftUI


@Suite(.snapshotTesting)
struct GlassControlSnapshots {

    /// Records a snapshot of a view using the glass appearance. The `assertView` function does not
    /// uses a hosting app to render its snapshots, so it is unable to render composite effects
    /// like glass. This test is kept as example of a snapshot with glass controls.
    @Test func glassControlsRendering() {
        // This snapshot shows a empty background and only the "Test" floating caption.
        Snapshots.assertView("glass-control", size: [400,160], colorSchemes: .all) {
            testView("Glass", testButtonStyle: .glassProminent)
        }

        // This snapshot correctly displays both buttons.
        Snapshots.assertView("no-glass", size: [400,160], colorSchemes: .all) {
            testView("Prominent", testButtonStyle: .borderedProminent)
        }
    }

    @ViewBuilder
    private func testView(
        _ caption: LocalizedStringKey,
        testButtonStyle: some PrimitiveButtonStyle
    ) -> some View {
        Button("Bordered Button", systemImage: "circle", action: {})
        .buttonStyle(.bordered)
        .padding(8)
        .floatingCaption("Bordered", .colorStyle(.green), .alignment(.outerTrailing))

        Button("Test Button", systemImage: "circle", action: {})
        .buttonStyle(testButtonStyle)
        .padding(8)
        .floatingCaption(caption, .colorStyle(.green), .alignment(.outerTrailing))
    }

}
