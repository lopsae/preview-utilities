//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


/// A structure that performs an identity transformation converting an instance to itself.
nonisolated
public struct IdentityFormatStyle<T>: FormatStyle {

    public init() { }

    public func format(_ value: T) -> T { value }

}


extension FormatStyle where Self == IdentityFormatStyle<String> {

    nonisolated
    public static var identity: IdentityFormatStyle<String> { .init() }

}
