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


extension IdentifiableShift
where
    Element == Self,
    Element.Shift: DisplayKeyProvider
{

    func displayProperty(for shift: Shift) -> DisplayProperty<Bool> {
        return DisplayProperty(displayKey: shift.displayKey, value: self[shift: shift])
    }

}


extension IdentifiableShiftWithDynamicMemberLookup
where
    Element == Self,
    Element.Shift: DisplayKeyProvider
{

    subscript(dynamicMember keyPath: KeyPath<Shift.Type, Shift>) -> DisplayProperty<Bool> {
        let shift = Shift.self[keyPath: keyPath]
        return displayProperty(for: shift)
    }

}


extension Binding
where
    Value: IdentifiableShift,
    Value.Element == Value,
    Value.Shift: DisplayKeyProvider
{

    func displayProperty(for shift: Value.Shift) -> BindingDisplayProperty<Bool> {
        let property = self.wrappedValue.displayProperty(for: shift)
        return .init(property: property, binding: self[shift: shift])
    }

}



// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    struct Firings: OptionSet {
        let rawValue: Int

        
    }

}


//public struct HeaderFooterContainerOptions:
//    OptionSet, IdentifiableShiftWithDynamicMemberLookup, Sendable
//{
//    public let rawValue: Int
//
//    public init(rawValue: Int) {
//        self.rawValue = rawValue
//    }
//
//    enum Shift: Int, CaseIterable, SelfIdentifiable, DisplayKeyProvider {
//        case fixedHeaderShift = 0,
//             fixedFooterShift,
//             showDividersShift,
//             padContentShift
//
//        // These properties are required for KeyPath. Sadly, keypath cannot access enums cases.
//        static var fixedHeader:  Self { .fixedHeaderShift }
//        static var fixedFooter:  Self { .fixedFooterShift }
//        static var showDividers: Self { .showDividersShift }
//        static var padContent:   Self { .padContentShift }
//
//        var displayKey: LocalizedStringKey {
//            switch self {
//            case .fixedHeaderShift:  "Fixed Header"
//            case .fixedFooterShift:  "Fixed Footer"
//            case .showDividersShift: "Show Dividers"
//            case .padContentShift:   "Pad Content"
//            }
//        }
//
//        // Can be used for direct access to [dynamicMember:] subscript.
//        var keyPath: WritableKeyPath<HeaderFooterContainerOptions, Bool> {
//            switch self {
//            case .fixedHeaderShift:  \.fixedHeader
//            case .fixedFooterShift:  \.fixedFooter
//            case .showDividersShift: \.showDividers
//            case .padContentShift:   \.padContent
//            }
//        }
//    }
//
//    public static let empty:        Self = .init(rawValue: .zero)
//    public static let fixedHeader:  Self = .init(shift: .fixedHeader)
//    public static let fixedFooter:  Self = .init(shift: .fixedFooter)
//    public static let showDividers: Self = .init(shift: .showDividers)
//    public static let padContent:   Self = .init(shift: .padContent)
//
//    public static let `default`: Self = .padContent
//
//    public static let fixed: Self = [.fixedHeader, .fixedFooter]
//}


// MARK: - Previews


//#Preview("Example", traits: .headerFooter, PreviewContent.layout) {
//
//}
