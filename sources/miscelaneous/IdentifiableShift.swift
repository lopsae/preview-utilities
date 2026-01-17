//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


nonisolated
protocol IdentifiableShift: OptionSet {
    associatedtype Shift: RawRepresentable & Hashable
    where Shift.RawValue == Self.RawValue

    init(shift: Shift)
}


extension IdentifiableShift
where
    Self.RawValue: FixedWidthInteger
{

    init(shift: Shift) {
        self.init(shiftedBy: shift.rawValue)
    }

}



extension IdentifiableShift
where
    // Required for `contains` functions to be inherited along most of OptionSet functionality.
    // This equivalency is expected in `OptionSet`s, tho not required.
    Self.Element == Self
{

    subscript(shift shift: Shift) -> Bool {
        get {
            let option = Self.init(shift: shift)
            return self.contains(option)
        }
        mutating set {
            let option = Self.init(shift: shift)
            if newValue {
                self.formUnion(option)
            } else {
                self.subtract(option)
            }
        }
    }

}


extension Binding
where
    Value: IdentifiableShift,
    Value.Element == Value
{
    func binding(for shift: Value.Shift) -> Binding<Bool> {
        self[shift: shift]
    }
}


@dynamicMemberLookup
nonisolated
protocol IdentifiableShiftWithDynamicMemberLookup: IdentifiableShift {

    subscript(dynamicMember keyPath: KeyPath<Shift.Type, Shift>) -> Bool { get mutating set }

}


extension IdentifiableShiftWithDynamicMemberLookup where Element == Self {

    subscript(dynamicMember keyPath: KeyPath<Shift.Type, Shift>) -> Bool {
        get {
            let shift = Shift.self[keyPath: keyPath]
            return self[shift: shift]
        }
        mutating set {
            let shift = Shift.self[keyPath: keyPath]
            self[shift: shift] = newValue
        }
    }

}


extension IdentifiableShift where Element == Self, Element.Shift: DisplayKeyProvider {

    func displayProperty(for shift: Shift) -> DisplayProperty<Bool> {
        return DisplayProperty(displayKey: shift.displayKey, value: self[shift: shift])
    }

}


extension IdentifiableShiftWithDynamicMemberLookup where Element == Self, Element.Shift: DisplayKeyProvider {

    subscript(dynamicMember keyPath: KeyPath<Shift.Type, Shift>) -> DisplayProperty<Bool> {
        let shift = Shift.self[keyPath: keyPath]
        return displayProperty(for: shift)
    }

}
