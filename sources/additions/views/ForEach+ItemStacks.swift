//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


extension ForEach {

    /// Creates an instance that uniquely identifies and creates map content across updates based on
    /// the identity of each element in the collection.
    ///
    /// The collection elements must be `Hashable`, since the element itself is used as identifier
    /// of its mapped content.
    ///
    /// - Parameters:
    ///   - items: The collection of hashable items to create map content dynamically.
    ///   - content: The map content builder that creates map content dynamically.
    @_spi(ItemStacks)
    public init(
        hashing items: Data,
        @ContentBuilder content: @escaping (Data.Element) -> Content
    ) where
        Data.Element: Hashable,
        Data.Element == ID
    {
        self.init(items, id: \.self, content: content)
    }

}
