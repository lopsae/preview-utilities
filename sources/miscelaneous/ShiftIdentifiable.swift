//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


nonisolated
protocol ShiftIdentifiable: OptionSet {
    associatedtype Shift: Hashable
}


extension ShiftIdentifiable
where
    Shift: RawRepresentable,
    Shift.RawValue == Self.RawValue,
    Self.RawValue: FixedWidthInteger
{

    init(shift: Shift) {
        self.init(shiftedBy: shift.rawValue)
    }

}
