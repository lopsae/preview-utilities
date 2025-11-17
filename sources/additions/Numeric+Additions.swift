//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreFoundation


extension Numeric where Self == Double {

    @inlinable var toCGFloat: CGFloat {
        CGFloat(self)
    }

}


extension Numeric where Self == CGFloat {

    @inlinable var toFloat: Float {
        Float(self)
    }

}
