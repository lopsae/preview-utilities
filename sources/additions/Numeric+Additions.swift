//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreFoundation


extension Numeric where Self == Int {

    /// Returns this value converted to an double.
    @inlinable nonisolated
    public var asDouble: Double {
        Double(self)
    }

}


extension Numeric where Self : BinaryFloatingPoint {

    
    /// Returns this value converted to an integer. The conversion truncates any decimal part.
    @inlinable nonisolated
    public var asInt: Int {
        Int(self)
    }


    /// Returns this value rounded using the `.toNearestOrEven` rule, also known as arithmetic or
    /// bankers rounding, as an integer.
    @inlinable nonisolated
    public var arithmeticRoundedInt: Int {
        rounded(.toNearestOrEven).asInt
    }


    /// Returns this value if the absolute distance between `self` and `newValue` is smaller that
    /// `threshold`; otherwise returns `newValue`.
    ///
    /// - Parameters:
    ///   - newValue: The new value to compare to `self`.
    ///   - threshold: Minimum inclusive threshold after which `newValue` is returned.
    /// - Returns: `self` when the distance to `newValue` is under `threshold`, otherwise returns
    ///     `newValue`.
    @inlinable nonisolated
    func stabilizedValue(_ newValue: Self, threshold: Stride.Magnitude) -> Self {
        let absDistance = self.distance(to: newValue).magnitude
        if absDistance < threshold {
            return self
        } else {
            return newValue
        }
    }

}

