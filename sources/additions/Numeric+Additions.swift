//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreFoundation


extension Numeric where Self == Int {

    @inlinable public var asDouble: Double {
        Double(self)
    }

}


extension Numeric where Self == Double {

    @inlinable public var asInt: Int {
        Int(self)
    }

}

