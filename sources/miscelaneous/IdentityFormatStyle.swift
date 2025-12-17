//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


/// FormatStyle that outputs the exact string taken as input.
struct IdentityFormatStyle<T>: FormatStyle {
    func format(_ value: T) -> T { value }
}

extension FormatStyle where Self == IdentityFormatStyle<String> {

    static var identity: IdentityFormatStyle<String> { .init() }

}
