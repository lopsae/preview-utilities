//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


/// A structure that converts a `RawRepresentable` to its raw value.
nonisolated
struct RawValueFormatStyle<Value: RawRepresentable>: FormatStyle
where Value.RawValue: StringProtocol {

    public init() { }

    public func format(_ value: Value) -> String { String(value.rawValue) }

}


extension FormatStyle {

    /// Returns a format style that outputs the raw value of a `RawRepresentable`.
    nonisolated
    static func rawValue<Value: RawRepresentable>() -> RawValueFormatStyle<Value>
    where
        Value.RawValue: StringProtocol,
        Self == RawValueFormatStyle<Value>
    {
        .init()
    }

}
