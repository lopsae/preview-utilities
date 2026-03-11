//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


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


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeader, PreviewContent.layout) {
    Text("Identity: `\("lorem ipsum", format: .identity)`")
}
