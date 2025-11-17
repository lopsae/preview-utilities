//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreFoundation


extension Numeric where Self == Double {

    @inlinable public var toInt: Int {
        Int(self)
    }

    @inlinable  public var toCGFloat: CGFloat {
        CGFloat(self)
    }

}


extension Numeric where Self == CGFloat {

    @inlinable  public var toFloat: Float {
        Float(self)
    }

}
