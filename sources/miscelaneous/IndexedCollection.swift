//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


/// A collection view that pairs each index and element of an underlying collection.
///
/// To create an instance of `IndexedCollection`, call `indexed()` on a collection.
nonisolated
struct IndexedCollection<Base: Collection>: Collection {

    typealias Element = (index: Base.Index, element: Base.Element)

    let base: Base

    var startIndex: Base.Index { base.startIndex }
    var endIndex: Base.Index { base.endIndex }

    func index(after i: Base.Index) -> Base.Index {
        base.index(after: i)
    }

    subscript(position: Base.Index) -> Element {
        return (index: position, element: base[position])
    }

}


extension IndexedCollection: BidirectionalCollection where Base: BidirectionalCollection {

    func index(before i: Base.Index) -> Base.Index {
        base.index(before: i)
    }

}


extension IndexedCollection: RandomAccessCollection where Base: RandomAccessCollection {}


// MARK: - Extension


extension Collection {

    func indexed() -> IndexedCollection<Self> {
        IndexedCollection(base: self)
    }

}
