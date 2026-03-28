//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import CoreFoundation


extension Numeric where Self: BinaryInteger {

    /// Returns this value converted to a `Double`.
    @inlinable nonisolated
    public var asDouble: Double {
        Double(self)
    }

}


extension Numeric where Self : BinaryFloatingPoint {

    /// Returns this value converted to an `Int`. The conversion truncates any decimal part.
    @inlinable nonisolated
    public var asInt: Int {
        Int(self)
    }


    /// Returns this value converted to a `Double`, rounded to the closest possible representation.
    @inlinable nonisolated
    public var asDouble: Double {
        Double(self)
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


extension Double {

    /// /// The mathematical constant tau (𝜏), approximately equal to `2*pi`: 6.28318.
    ///
    /// When measuring an angle in radians, 𝜏 is equivalent to a one turn.
    /// https://www.tauday.com
    static var tau: Double { .pi * 2 }


    // Marked as `deprecated` to show a warning when used. If marked as `unavailable` the parent
    // `BinaryFloatingPoint` extension implementation is used instead, and no warning is shown.
    @available(*, deprecated, message: "Value is already Double, this call is unnecessary")
    @inlinable nonisolated
    public var asDouble: Double { self }

}
