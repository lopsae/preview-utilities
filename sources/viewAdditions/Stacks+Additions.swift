//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


// `ForEach` implicitly constrains `ValuesCollection `to `RandomAccessCollection`, and `ElementID`
// to `Hashable`, as specified in its struct definition. The constraints in this initializers to
// `RandomAccessCollection` and `Hashable` are not not strictly necessary (the initializers would
// still work without them) but are made implicit for completeness.

// TODO: Can both stacks share a protocol (AxialStack)? to use the same initializer.

extension HStack {

    /// Creates a horizontal stack that generates its content with the elements of a given
    /// collection, identified through a key path.
    @_spi(ItemStacks)
    public init<ValuesCollection, ElementContent, ElementID>(
        _ collection: ValuesCollection,
        id idKeyPath: KeyPath<ValuesCollection.Element, ElementID>,
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder elementContent: @escaping (ValuesCollection.Element) -> ElementContent
    ) where
        ValuesCollection: RandomAccessCollection,
        ElementContent: View,
        ElementID: Hashable,
        Content == ForEach<ValuesCollection, ElementID, ElementContent>
    {
        self.init(alignment: alignment, spacing: spacing) {
            ForEach(collection, id: idKeyPath) { element in
                elementContent(element)
            }
        }
    }


    @_spi(ItemStacks)
    public init<Items, ItemContent>(
        items: Items,
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder itemContent: @escaping (Items.Element) -> ItemContent
    ) where
        Items: RandomAccessCollection,
        Items.Element: Hashable,
        ItemContent: View,
        Content == ForEach<Items, Items.Element, ItemContent>
    {
        self.init(alignment: alignment, spacing: spacing) {
            ForEach(items, id: \.self) { item in
                itemContent(item)
            }
        }
    }

}


extension VStack {

    /// Creates a vertical stack that generates its content with the elements of a given
    /// collection, identified through a key path.
    @_spi(ItemStacks)
    public init<ValuesCollection, ElementContent, ElementID>(
        _ collection: ValuesCollection,
        id idKeyPath: KeyPath<ValuesCollection.Element, ElementID>,
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder elementContent: @escaping (ValuesCollection.Element) -> ElementContent
    ) where
        ValuesCollection: RandomAccessCollection,
        ElementContent: View,
        ElementID: Hashable,
        Content == ForEach<ValuesCollection, ElementID, ElementContent>
    {
        self.init(alignment: alignment, spacing: spacing) {
            ForEach(collection, id: idKeyPath) { element in
                elementContent(element)
            }
        }
    }


    @_spi(ItemStacks)
    public init<Items, ItemContent>(
        items: Items,
        alignment: HorizontalAlignment = .center,
        spacing: CGFloat? = nil,
        @ViewBuilder itemContent: @escaping (Items.Element) -> ItemContent
    ) where
        Items: RandomAccessCollection,
        Items.Element: Hashable,
        ItemContent: View,
        Content == ForEach<Items, Items.Element, ItemContent>
    {
        self.init(alignment: alignment, spacing: spacing) {
            ForEach(items, id: \.self) { item in
                itemContent(item)
            }
        }
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("HStack", traits: .headerFooter, PreviewContent.layout) {
    VStack {
        HStack(0...2, id: \.self) { index in
            CaptionRectangle("Item \(index)", color: .green, size: .square(of: 50))
        }

        DashedDivider()

        HStack(items: 3...6, spacing: .zero) { index in
            CaptionRectangle("Item \(index)", color: .green, size: .square(of: 50))
        }

        DashedDivider()

        HStack((7...9).enumerated(), id: \.offset, alignment: .bottom) { offset, element in
            CaptionRectangle("Item \(element)", color: .green, size: [50, 50+10*offset.asDouble])
        }
    }
}


#Preview("VStack", traits: .headerFooter, PreviewContent.layout) {
    HStack {
        VStack(0...2, id: \.self) { index in
            CaptionRectangle("Item \(index)", color: .green, size: .square(of: 50))
        }

        DashedDivider(axis: .vertical)

        VStack(items: 3...6, spacing: .zero) { index in
            CaptionRectangle("Item \(index)", color: .green, size: .square(of: 50))
        }

        DashedDivider(axis: .vertical)

        VStack((7...9).enumerated(), id: \.offset, alignment: .trailing) { offset, element in
            CaptionRectangle("Item \(element)", color: .green, size: [50+10*offset.asDouble, 50])
        }
    }
}
