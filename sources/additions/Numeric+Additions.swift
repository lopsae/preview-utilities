//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreFoundation


extension Numeric where Self == Int {

    @inlinable nonisolated
    public var asDouble: Double {
        Double(self)
    }

}


extension Numeric where Self : BinaryFloatingPoint {

    @inlinable nonisolated
    public var asInt: Int {
        Int(self)
    }


    @inlinable nonisolated
    public var arithmeticRoundedInt: Int {
        rounded(.toNearestOrEven).asInt
    }

}

