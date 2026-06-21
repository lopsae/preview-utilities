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


extension FormatStyleExamples.Sphinx: FormatStyleFormattable {}
extension FormatStyleExamples.Quartz: FormatStyleFormattable {}
