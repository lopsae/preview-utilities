//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Testing
import SwiftUI


struct GlassControlSnapshots {

    /// Records a snapshot of a view using the glass appearance. The `assertView` function does not
    /// uses a hosting app to render its snapshots, so it is unable to render composite effects
    /// like glass. This test is kept as example of a snapshot with glass controls.
    @Test func glassControlsRendering() {
        Snapshots.assertView("glass-control", size: [400,160], record: .missing) {
            VStack {
                Button("Bordered Button", systemImage: "circle", action: {})
                .buttonStyle(.bordered)
                .padding(8)
                .floatingCaption("Bordered", .colorStyle(.green), .alignment(.outerTrailing))

                Button("Glass Button", systemImage: "circle", action: {})
                .buttonStyle(.glassProminent)
                .padding(8)
                .floatingCaption("Glass", .colorStyle(.green), .alignment(.outerTrailing))
            }
        }
    }

}
