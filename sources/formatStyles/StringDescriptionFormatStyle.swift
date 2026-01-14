//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


/// A structure that converts any instance to its string description.
nonisolated
public struct StringDescriptionFormatStyle<Input>: FormatStyle {

    public init() { }

    public func format(_ value: Input) -> String {
        String(describing: value)
    }

}



extension FormatStyle where Self == StringDescriptionFormatStyle<Double> {

    nonisolated
    public static var stringDescription: IdentityFormatStyle<Double> { .init() }

}


extension FormatStyle where Self == StringDescriptionFormatStyle<Int> {

    nonisolated
    public static var stringDescription: IdentityFormatStyle<Int> { .init() }

}
