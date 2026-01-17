//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


nonisolated
protocol ShiftIdentifiable: OptionSet {
    associatedtype Shift: RawRepresentable where Shift.RawValue == Self.RawValue
}


extension ShiftIdentifiable where Self.RawValue: FixedWidthInteger, Self.Element == Self {

    init(shift: Shift) {
        self.init(shiftedBy: shift.rawValue)
    }


    // Provides implementation for @dynamicMemberLookup.
    subscript(dynamicMember keyPath: KeyPath<Shift.Type, Shift>) -> Bool {
        get {
            let shift = Shift.self[keyPath: keyPath]
            let option = Self.init(shift: shift)
            return self.contains(option)
        }
        mutating set {
            let shift = Shift.self[keyPath: keyPath]
            let option = Self.init(shift: shift)
            if newValue {
                self.formUnion(option)
            } else {
                self.subtract(option)
            }
        }
    }

}
