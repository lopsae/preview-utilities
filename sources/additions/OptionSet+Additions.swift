//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


extension OptionSet where RawValue: FixedWidthInteger {

    /// Creates a new option set with a raw value of `1` shifted by the given shift value.
    ///
    /// Note that the raw value of the created options set is never the same as he given `shift`
    /// value.
    ///
    /// This initializer always succeeds, even if the value produced exceeds the static properties
    /// declared as part of the option set.
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
