//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


/// A structure that performs an identity transformation, always returns the input as output with no
/// modifications.
nonisolated
public struct IdentityFormatStyle<T>: FormatStyle {

    public init() { }

    public func format(_ value: T) -> T { value }

}


extension FormatStyle where Self == IdentityFormatStyle<String> {

    nonisolated
    public static var identity: IdentityFormatStyle<String> { .init() }

}
