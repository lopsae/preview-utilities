//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


nonisolated
enum TextSource {
    case localizedKey(LocalizedStringKey)
    case verbatim(String)

    var text: Text {
        switch self {
        case .localizedKey(let localizedStringKey):
            Text(localizedStringKey)
        case .verbatim(let string):
            Text(verbatim: string)
        }
    }
}
