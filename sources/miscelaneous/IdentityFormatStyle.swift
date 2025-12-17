//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


/// FormatStyle that outputs the exact value taken as input.
public struct IdentityFormatStyle<T>: FormatStyle {

    public init() { }

    public func format(_ value: T) -> T { value }

}

extension FormatStyle where Self == IdentityFormatStyle<String> {

    public static var identity: IdentityFormatStyle<String> { .init() }

}
