//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


extension OptionSet where RawValue: FixedWidthInteger {

    init(shiftedBy: Int) {
        self.init(rawValue: 1 << shiftedBy)
    }

}
