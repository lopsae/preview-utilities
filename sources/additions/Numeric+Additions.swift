//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreFoundation


extension Numeric where Self == Int {

    @inlinable public var asDouble: Double {
        Double(self)
    }


    @inlinable public func clamped(to range: Range<Self>) -> Self {
        // TODO: test return for empty ranges
        Swift.max(range.lowerBound, Swift.min(self, range.upperBound - 1))
    }

}


extension Numeric where Self == Double {

    @inlinable public var asInt: Int {
        Int(self)
    }

    // TODO: is this actually necessary? since CGFloat is a Double
    @inlinable  public var asCGFloat: CGFloat {
        CGFloat(self)
    }

}


// TODO: move this to Double, which should be the same as CGFloat
// TODO: double check uses of this, might be possile to remove and use Double only
extension Numeric where Self == CGFloat {

    @inlinable  public var asFloat: Float {
        Float(self)
    }

}
