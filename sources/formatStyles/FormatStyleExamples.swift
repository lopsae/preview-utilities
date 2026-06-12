//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Type containing internal struct and enum used in previews, playgrounds, and snippets.
enum FormatStyleExamples {

    nonisolated struct Sphinx: Equatable {
        let material = "quartz"
    }

    enum Quartz: String { case black, rose, amethyst }

}


protocol StyleFormattable {}

extension StyleFormattable {

    func formatted<Output, Style>(_ style: Style) -> Output
    where
        Style: FormatStyle,
        Style.FormatInput == Self,
        Style.FormatOutput == Output
    {
        style.format(self)
    }

}


extension FormatStyleExamples.Sphinx: StyleFormattable {}
extension FormatStyleExamples.Quartz: StyleFormattable {}
