//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


/// A structure that converts a string to its first character, optionally capitalized.
struct FirstCharacterFormatStyle: FormatStyle {

    let capitalized: Bool

    init(capitalized: Bool = false) {
        self.capitalized = capitalized
    }

    func format(_ value: String) -> String {
        let firstCharacted = value.first?.description ?? ""
        return capitalized
            ? firstCharacted.capitalized
            : firstCharacted
    }

}


extension FormatStyle where Self == FirstCharacterFormatStyle {

    static var firstCharacter: FirstCharacterFormatStyle { .init() }

    static func firstCharacter(capitalized: Bool) -> FirstCharacterFormatStyle {
        .init(capitalized: capitalized)
    }

}
