//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension HStack {

    // `ForEach` implicitly constrains `ValuesCollection `to `RandomAccessCollection`, and
    // `ElementID` to `Hashable`, as specified in its struct definition. The constraints in this
    // initializers to `RandomAccessCollection` and `Hashable` are not not strictly necessary, the
    // initializers would work without them. Still, these are left here for completeness.


    /// Creates a horizontal stack that generates its content with the elements of a given
    /// collection identified through a key path.
    init<ValuesCollection, ElementContent, ElementID>(
        _ collection: ValuesCollection,
        id idKeyPath: KeyPath<ValuesCollection.Element, ElementID>,
        @ViewBuilder elementContent: @escaping (ValuesCollection.Element) -> ElementContent
    ) where
        ValuesCollection: RandomAccessCollection,
        ElementContent: View,
        ElementID: Hashable,
        Content == ForEach<ValuesCollection, ElementID, ElementContent>
    {
        self.init {
            ForEach(collection, id: idKeyPath) { element in
                elementContent(element)
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


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    ScrollView(.horizontal) {
        HStack(0...5, id: \.self) { index in
            CaptionRectangle("Item \(index)", color: .green, size: .square(of: 100))
        }
    }
}
