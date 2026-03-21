//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


/// A collection view that pairs each index and element of an underlying collection.
///
/// To create an instance of `IndexedCollection`, call `indexed()` on a collection.
nonisolated
public struct IndexedCollection<Base: Collection>: Collection {

    public typealias Element = (index: Base.Index, element: Base.Element)

    let base: Base

    public var startIndex: Base.Index { base.startIndex }
    public var endIndex: Base.Index { base.endIndex }

    public func index(after i: Base.Index) -> Base.Index {
        base.index(after: i)
    }

    public subscript(position: Base.Index) -> Element {
        return (index: position, element: base[position])
    }

}


extension IndexedCollection: BidirectionalCollection where Base: BidirectionalCollection {

    public func index(before i: Base.Index) -> Base.Index {
        base.index(before: i)
    }

}


extension IndexedCollection: RandomAccessCollection where Base: RandomAccessCollection {}


// MARK: - Extension


extension Collection {

    nonisolated
    public func indexed() -> IndexedCollection<Self> {
        IndexedCollection(base: self)
    }

}
