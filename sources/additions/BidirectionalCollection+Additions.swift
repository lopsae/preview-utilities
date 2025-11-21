//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


extension BidirectionalCollection {
//extension MutableCollection {

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

