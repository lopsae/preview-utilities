//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


extension OptionSet where RawValue: FixedWidthInteger {

    nonisolated
    init(shiftedBy shift: RawValue) {
        let one = RawValue(1)
        self.init(rawValue: one << shift)
    }


    nonisolated
    init<R>(shiftedBy rawRepresentable: R)
    where
        R: RawRepresentable,
        R.RawValue == RawValue
    {
        let one = RawValue(1)
        self.init(rawValue: one << rawRepresentable.rawValue)
    }


    nonisolated
    init(allUpTo upToShift: RawValue) {
        let one = RawValue(1)
        self.init(rawValue: (one << upToShift) - one)
    }

}


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
