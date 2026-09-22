//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import Foundation
import SwiftUI
import Playgrounds


/// A format style that performs an identity transformation, returns the input as output with no
/// modifications.
///
/// Use this format style through the `FormatStyle` extension ``Foundation/FormatStyle/identity``:
///
/// ```swift
/// Text("black quartz", format: .identity) // Displays "black quartz"
/// ```
///
/// ## Topics
///
/// ### FormatStyle Extensions
/// + ``Foundation/FormatStyle/identity``
///
public nonisolated
struct IdentityFormatStyle<T>: FormatStyle, Sendable {

    /// Creates an identity format style.
    public init() {}

    @_documentation(visibility: internal)
    public func format(_ value: T) -> T { value }

}


extension FormatStyle where Self == IdentityFormatStyle<String> {

    /// Returns an identity format style that outputs its input with no modifications.
    public nonisolated
    static var identity: IdentityFormatStyle<String> { .init() }

}


// MARK: - Playgrounds


#Playground("Default") {
    _ = "lorem ipsum".formatted(.identity)
}


// MARK: - Previews


#Preview("Snippet") {
    Text("black quartz", format: .identity) // Displays "black quartz"
}
