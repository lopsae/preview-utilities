//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


extension BinaryFloatingPoint {

    // TODO: Could also be defined for `FixedWidthInteger`.

    /// The one value.
    ///
    /// One is the identity element for multiplication. For any value, `x * .one == x` and
    /// `.one * x == x`.
    nonisolated
    public static var one: Self { Self(1) }

    nonisolated
    static var half: Self { Self(0.5) }

}
