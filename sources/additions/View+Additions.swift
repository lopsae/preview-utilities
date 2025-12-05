//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension View {

    @inlinable public func maxWidthFrame(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }


    @inlinable public func maxHeightFrame(alignment: Alignment = .center) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }


    @inlinable public func maxSizeFrame(alignment: Alignment = .center) -> some View {
        self.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }


    @inlinable public func frame(square side: CGFloat, alignment: Alignment = .center) -> some View {
        self.frame(width: side, height: side, alignment: alignment)
    }


    @inlinable public func frame(size: CGSize, alignment: Alignment = .center) -> some View {
        self.frame(width: size.width, height: size.height, alignment: alignment)
    }

}
