//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


nonisolated
protocol ShiftIdentifiable: OptionSet {
    associatedtype Shift: RawRepresentable where Shift.RawValue == Self.RawValue
}


extension ShiftIdentifiable where Self.RawValue: FixedWidthInteger {

    init(shift: Shift) {
        self.init(shiftedBy: shift.rawValue)
    }

}
