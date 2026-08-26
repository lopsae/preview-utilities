//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import Foundation


/// Convenience protocol with a default implementation of `formatted(_:)`.
///
/// Implementing this protocol extends a type with a default implementation of ``formatted(_:)``
/// that receives `FormatStyle` instances that use `Self` as input.
public protocol FormatStyleFormattable {}

extension FormatStyleFormattable {

    
    /// Formats self through the given format style.
    /// - Parameter style: The format style to format self.
    /// - Returns: The output of the format style.
    public func formatted<Output, Style>(_ style: Style) -> Output
    where
        Style: FormatStyle,
        Style.FormatInput == Self,
        Style.FormatOutput == Output
    {
        style.format(self)
    }

}
