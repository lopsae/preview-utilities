//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension View {

    func maxWidthFrame() -> some View {
        self.frame(maxWidth: .infinity)
    }


    func maxHeightFrame() -> some View {
        self.frame(maxHeight: .infinity)
    }


    func maxSizeFrame() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
    }


    func frame(square side: CGFloat) -> some View {
        self.frame(width: side, height: side)
    }

}
