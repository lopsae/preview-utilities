//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


/// Convenience protocol with a default implementation of `formatted(_:)`.
///
/// Implementing this protocol extends a type with a default implementation of ``formatted(_:)``
/// that receives `FormatStyle` instances that use `Self` as input.
public protocol FormatStyleFormattable {}

extension FormatStyleFormattable {

    public func formatted<Output, Style>(_ style: Style) -> Output
    where
        Style: FormatStyle,
        Style.FormatInput == Self,
        Style.FormatOutput == Output
    {
        style.format(self)
    }

}
