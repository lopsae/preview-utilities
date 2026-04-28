//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


extension Hashable {

    /// Returns the hash value produced by combining self along a given hashable.
    func hash(with hashable: any Hashable) -> Int {
        Hasher.combining(self, hashable)
    }

}


extension Hasher {

    /// Returns the has value produced by combining a number of hashables.
    static func combining(_ hashables: any Hashable...) -> Int {
        var hasher = Hasher()
        for hashable in hashables {
            hasher.combine(hashable)
        }
        return hasher.finalize()
    }

}
