//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation
import Playgrounds


/// A structure that converts an input `RawRepresentable` to its raw value.
nonisolated
public struct RawValueFormatStyle<Value: RawRepresentable>: FormatStyle, Sendable
where Value.RawValue: StringProtocol {

    public init() { }

    @_documentation(visibility: internal)
    public func format(_ value: Value) -> String { String(value.rawValue) }

}


extension FormatStyle {

    /// Returns a format style that outputs the raw value of a `RawRepresentable` with
    /// a string representation.
    nonisolated
    public static func rawValue<Value: RawRepresentable>() -> RawValueFormatStyle<Value>
    where
        Value.RawValue: StringProtocol,
        Self == RawValueFormatStyle<Value>
    {
        .init()
    }

}


// MARK: - Playgrounds


// FIXME: move to a shared example enum in FormatStyle.
private enum ExampleEnum: String {
    case alfa, bravo, charlie

    func format<Output, Formatter>(_ formatter: Formatter) -> Output
    where
        Formatter: FormatStyle,
        Formatter.FormatInput == Self,
        Formatter.FormatOutput == Output
    {
        formatter.format(self)
    }

}


#Playground("Default") {
    _ = ExampleEnum.bravo.format(.rawValue())
    _ = ExampleEnum.charlie.format(.rawValueCapitalized())
}
