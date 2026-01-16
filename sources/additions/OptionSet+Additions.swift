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
        init(allUpTo upToShift: RawValue) {
            let one = RawValue(1)
            self.init(rawValue: (one << upToShift) - one)
        }

}
