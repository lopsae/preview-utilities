//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


extension Sequence where Element: OptionSet {

    /// Returns a new option set with the union of all elements contained in this set.
    @inlinable func union() -> Element {
        var unionOptions: Element = []
        for item in self {
            unionOptions.formUnion(item)
        }
        return unionOptions
    }

}
