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
/// + ``Foundation/FormatStyle/rawValueCapitalized()``
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


    /// Returns a format style that outputs the capitalized string raw value of a `RawRepresentable`.
    ///
    /// Returns a ``CompositeFormatStyle`` configured to retrieve the string raw value with ``RawValueFormatStyle``
    /// and capitalize it through ``CapitalizedFormatStyle``.
    ///
    /// ```swift
    /// enum Quartz: String { case black, rose, amethyst }
    /// Text(Quartz.rose, format: .rawValueCapitalized()) // Displays "Rose"
    /// ```
    nonisolated
    public static func rawValueCapitalized<Value: RawRepresentable>() -> Self
    where
        Value.RawValue: StringProtocol,
        Self == CompositeFormatStyle<RawValueFormatStyle<Value>, CapitalizedFormatStyle>
    {
        return .init(input: RawValueFormatStyle(), output: CapitalizedFormatStyle())
    }

}


// MARK: - PreviewContent


private typealias Quartz = FormatStyleExamples.Quartz


// MARK: - Playgrounds


#Playground("Default") {
    _ = Quartz.amethyst.formatted(.rawValue())
    _ = Quartz.amethyst.formatted(.rawValueCapitalized())
}


// MARK: - Previews


#Preview("Snippets", traits: .sizeThatFitsLayout) {
    Text(Quartz.rose, format: .rawValue()) // Displays "rose"
    .padding()

    Text(Quartz.rose, format: .rawValueCapitalized()) // Displays "Rose"
    .padding()
}
