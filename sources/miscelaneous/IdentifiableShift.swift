//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


nonisolated
protocol IdentifiableShift: OptionSet {
    associatedtype Shift: RawRepresentable /*& ShiftKeypathProviding*/
    where Shift.RawValue == Self.RawValue/*, Shift.Option == Self*/
}


extension IdentifiableShift
where
    Self.RawValue: FixedWidthInteger,
    Self.Element == Self
{

    init(shift: Shift) {
        self.init(shiftedBy: shift.rawValue)
    }


    // TODO: this might not need FixedWidthInteger RawValue.
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


nonisolated
protocol ShiftKeypathProviding {
    associatedtype Option: OptionSet
    var keyPath: WritableKeyPath<Option, Bool> { get }
}


extension Binding
where
    Value: IdentifiableShift,
    Value.Shift: ShiftKeypathProviding,
    Value.Shift.Option == Value,
    Value.RawValue: FixedWidthInteger,
    Value.Element == Value
{
    func binding(for shift: Value.Shift) -> Binding<Bool> {
        // Implemented by IdentifiableShift
        self[dynamicMember: shift.keyPath]
    }
}
