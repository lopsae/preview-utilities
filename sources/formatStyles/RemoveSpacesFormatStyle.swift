//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


// FIXME: Document, publicize, test, list in api-docs.
nonisolated
struct RemoveSpacesFormatStyle: FormatStyle, Sendable {

    public init() {}

    public func format(_ value: String) -> String {
        return value.components(separatedBy: .whitespaces).joined()
    }

}


extension FormatStyle where Self == RemoveSpacesFormatStyle {

    nonisolated
    static var removeSpaces: Self { RemoveSpacesFormatStyle() }

}


extension FormatStyle where Self: Sendable, FormatOutput == String {

    nonisolated
    var removingSpaces: CompositeFormatStyle<Self, RemoveSpacesFormatStyle> {
        return CompositeFormatStyle(input: self, output: .removeSpaces)
    }

}
