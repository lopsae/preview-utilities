//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities
import SwiftUI


extension View {

    func overlayFloatingAlignments<Content: View>(
        @ViewBuilder content: @escaping (_ alignment: FloatingAlignment) -> Content
    ) -> some View {
        self.overlay {
            ForEach(FloatingAlignment.allCases) { alignment in
                content(alignment)
            }
        }
    }

}


// FIXME: Add tests.
