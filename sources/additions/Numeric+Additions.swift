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

}

