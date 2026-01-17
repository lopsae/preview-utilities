//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


nonisolated
protocol IdentifiableShift: OptionSet {
    associatedtype Shift: RawRepresentable
    where Shift.RawValue == Self.RawValue

    init(shift: Shift)
}


extension IdentifiableShift
where
    Self.RawValue: FixedWidthInteger,
    Self.Element == Self
{

    init(shift: Shift) {
        self.init(shiftedBy: shift.rawValue)
    }

}



extension IdentifiableShift
where
    Self.Element == Self
{

    // Provides an implementation for @dynamicMemberLookup.
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


nonisolated
protocol ShiftKeypathProvider {
    associatedtype Option: OptionSet
    var keyPath: WritableKeyPath<Option, Bool> { get }
}


extension Binding
where
    Value: IdentifiableShift,
    Value.Shift: ShiftKeypathProvider,
    Value.Shift.Option == Value
{
    func binding(for shift: Value.Shift) -> Binding<Bool> {
        // Implemented by IdentifiableShift
        self[dynamicMember: shift.keyPath]
    }
}
