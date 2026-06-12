//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation
import Playgrounds
import SwiftUI


/// A format style that outputs the string raw value of a `RawRepresentable`.
///
/// Use this format style through the `FormatStyle` extension ``Foundation/FormatStyle/rawValue()``:
///
/// ```swift
/// enum Quartz: String { case black, rose, amethyst }
/// Text(Quartz.rose, format: .rawValue()) // Displays "rose"
/// ```
///
/// ## Topics
///
/// ### FormatStyle Extensions
/// + ``Foundation/FormatStyle/rawValue()``
///
nonisolated
public struct RawValueFormatStyle<Value: RawRepresentable>: FormatStyle, Sendable
where Value.RawValue: StringProtocol {

    public init() { }

    @_documentation(visibility: internal)
    public func format(_ value: Value) -> String { String(value.rawValue) }

}


extension FormatStyle {

    /// Returns a format style that outputs the string raw value of a `RawRepresentable`.
    ///
    /// Returns a ``RawValueFormatStyle`` that outputs the string raw value of a `RawRepresentable`.
    ///
    /// ```swift
    /// enum Quartz: String { case black, rose, amethyst }
    /// Text(Quartz.rose, format: .rawValue()) // Displays "rose"
    /// ```
    nonisolated
    public static func rawValue<Value: RawRepresentable>() -> RawValueFormatStyle<Value>
    where
        Value.RawValue: StringProtocol,
        Self == RawValueFormatStyle<Value>
    {
        RawValueFormatStyle()
    }

}


// MARK: - PreviewContent


private typealias Quartz = FormatStyleExamples.Quartz


// MARK: - Playgrounds


#Playground("Default") {
    _ = Quartz.amethyst.formatted(.rawValue())
}


// MARK: - Previews


#Preview("Snippets", traits: .sizeThatFitsLayout) {
    Text(Quartz.rose, format: .rawValue()) // Displays "rose"
    .padding()
}
