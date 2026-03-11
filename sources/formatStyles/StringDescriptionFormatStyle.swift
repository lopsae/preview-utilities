//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// A structure that converts any instance to its string description.
nonisolated
public struct StringDescriptionFormatStyle<Input>: FormatStyle {

    public init() { }

    public func format(_ value: Input) -> String {
        String(describing: value)
    }

}


extension FormatStyle {

    /// Returns a format style that outputs the string description of the input.
    nonisolated
    static func description<Input>() -> Self
    where
        Self == StringDescriptionFormatStyle<Input>
    {
        return .init()
    }

}



// TODO: These dont seem to be used anywhere. Mark as deprecated?
extension FormatStyle where Self == StringDescriptionFormatStyle<Double> {

    nonisolated
    public static var stringDescription: IdentityFormatStyle<Double> { .init() }

}


extension FormatStyle where Self == StringDescriptionFormatStyle<Int> {

    nonisolated
    public static var stringDescription: IdentityFormatStyle<Int> { .init() }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    nonisolated
    struct Dummy: CustomStringConvertible {
        var description: String { "string description" }
    }

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable let dummy = PreviewContent.Dummy()
//    Text("Integer: `\(987, format: .stringDescription)`")
//    Text("Double: `\(1.2345, format: .stringDescription)`")
    Text("Custom: `\(dummy, format: .description())`")
}
