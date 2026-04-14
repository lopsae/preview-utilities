//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


extension BidirectionalCollection {

    public func clampIndex(_ index: Index) -> Index? {
        guard !isEmpty else { return nil }
        let inclusiveUpperBound = self.index(before: endIndex)
        return index.clamped(to: startIndex...inclusiveUpperBound)
    }


    public var finalIndex: Index { index(before: endIndex) }


    // TODO: remove once deprecations are deleted.
    @available(*, deprecated, renamed: "finalIndex")
    public var beforeEndIndex: Index { finalIndex }


    // TODO: is array the appropriate return for a mapping/replace function? check what does a BidirectionalCollection.map implements to
    // Initially copied from ScrumDinger project.
    func replaceLast(_ transform: (inout Element) throws -> Void) rethrows -> [Element] {
        if isEmpty { return Array(self) }

        // TODO: is there a way to createa a view that replaces only the last?
        var result = Array(self)
        if var resultLast = last {
            try transform(&resultLast)
            result[result.endIndex - 1] = resultLast
        }
        return result
    }

}

