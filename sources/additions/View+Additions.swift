//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension View {

    public func maxWidthFrame() -> some View {
        self.frame(maxWidth: .infinity)
    }


    public func maxHeightFrame() -> some View {
        self.frame(maxHeight: .infinity)
    }


    public func maxSizeFrame() -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity)
    }


    public func frame(square side: CGFloat) -> some View {
        self.frame(width: side, height: side)
    }

}
