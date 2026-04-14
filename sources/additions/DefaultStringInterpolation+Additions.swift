//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


extension DefaultStringInterpolation {

    @inlinable public nonisolated
    mutating func appendInterpolation<T>(nilDefault value: T?) {
        appendInterpolation(value, default: "nil")
    }

    @inlinable public nonisolated
    mutating func appendInterpolation<T>(emptyDefault value: T?) {
        appendInterpolation(value, default: String())
    }


    /// Appends the formatted representation of a nonstring type supported by a corresponding
    /// format style.
    ///
    /// Based on `LocalizedStringKey.StringInterpolation/appendInterpolation(_:format:)`.
    @inlinable public nonisolated
    mutating func appendInterpolation<Format>(_ value: Format.FormatInput, format: Format)
    where Format: FormatStyle, Format.FormatOutput == String {
        let formattedValue = format.format(value)
        appendInterpolation(formattedValue)
    }

}
