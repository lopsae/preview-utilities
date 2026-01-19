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


nonisolated
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


/// `IdentifialbleShift` that also implements `@dynamicMemberLookup`.
///
/// The defined `[dynamicMember:]` subscript depends on static computed properties in `Shift` that
/// return a `ValueKey<Shift>`. Usually a wrapper for each of the cases:
///
/// ```
/// enum Shift {
///     case first
///     static var firstValue: ValueKey<Shift> { .key(.first) }
/// }
/// ```
@dynamicMemberLookup
nonisolated
protocol IdentifiableShiftWithDynamicMemberLookup: IdentifiableShift {

    subscript(dynamicMember keyPath: KeyPath<Shift.Type, ValueKey<Shift>>) -> Bool { get mutating set }

}


/// Type for properties in `IdentifiableShift.Shift` that are used to define dynamic members for
/// each `OptionSet` component value.
struct ValueKey<Key> {
    let key: Key
    static func key(_ key: Key) -> Self { .init(key: key) }
}


/// Default implementation for dynamic members to get or set value of each `OptionSet` component.
extension IdentifiableShiftWithDynamicMemberLookup where Element == Self {

    subscript(dynamicMember keyPath: KeyPath<Shift.Type, ValueKey<Shift>>) -> Bool {
        get {
            let valueKey = Shift.self[keyPath: keyPath]
            return self[shift: valueKey.key]
        }
        mutating set {
            let valueKey = Shift.self[keyPath: keyPath]
            self[shift: valueKey.key] = newValue
        }
    }

}


extension IdentifiableShift
where
    Element == Self,
    Element.Shift: DisplayKeyProvider
{

    subscript(displayFor shift: Shift) -> DisplayProperty<Bool> {
        get {
            .init(displayKey: shift.displayKey, value: self[shift: shift])
        }
        mutating set {
            self[shift: shift] = newValue.value
        }
    }

    func displayProperty(for shift: Shift) -> DisplayProperty<Bool> {
        return self[displayFor: shift]
    }

}


extension IdentifiableShiftWithDynamicMemberLookup
where
    Element == Self,
    Element.Shift: DisplayKeyProvider
{

    subscript(dynamicMember keyPath: KeyPath<Shift.Type, DisplayKey<Shift>>) -> DisplayProperty<Bool> {
        get {
            let displayKey = Shift.self[keyPath: keyPath]
            return self[displayFor: displayKey.key]
        }
        mutating set {
            let displayKey = Shift.self[keyPath: keyPath]
            self[shift: displayKey.key] = newValue.value
        }

    }

}


extension Binding
where
    Value: IdentifiableShift,
    Value.Element == Value,
    Value.Shift: DisplayKeyProvider
{

    func displayProperty(for shift: Value.Shift) -> Binding<DisplayProperty<Bool>> {
        self[displayFor: shift]
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    @ViewBuilder
    static func captioned(
        _ captionKey: LocalizedStringKey,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(captionKey).font(.caption)
            content()
        }
        .maxWidthFrame(alignment: .leading)
        .padding(.horizontal)
        .padding(.bottom, 5)
    }


    // MARK: Example OptionSet


    struct Firings: OptionSet, IdentifiableShiftWithDynamicMemberLookup {
        let rawValue: Int

        enum Shift: Int, CaseIterable, SelfIdentifiable, DisplayKeyProvider {
            case greenware = 0, bisque, glaze

            // These properties define the available `KeyPath<Shift.Type, ValueKey<Shift>>` and thus
            // the actual names of the dynamic members to retrieve the value.
            // Sadly, keypath cannot read the cases directly, in which case these would be unnecessary.
            static var greenwareValue: ValueKey<Self> { .key(.greenware) }
            static var bisqueValue:    ValueKey<Self> { .key(.bisque) }
            static var glazeValue:     ValueKey<Self> { .key(.glaze) }

            // Implementation for DisplayKeyProvider, allows the OptionSet to produce DisplayProperties.
            var displayKey: LocalizedStringKey {
                switch self {
                case .greenware: "Greenware"
                case .bisque:    "Bisque"
                case .glaze:     "Glaze"
                }
            }
            // These properties define the available `KeyPath<Shift.Type, DisplayKey<Shift>>` and
            // thus the actual names of the dynamic members to retrieve a DisplayProperty.
            // If none are added, a DisplayProperty can still be produced using
            // `optionSet.displayProperty(for:)`.
            static var greenwareDisplay: DisplayKey<Self> { .key(.greenware) }
            static var bisqueDisplay:    DisplayKey<Self> { .key(.bisque) }
            static var glazeDisplay:     DisplayKey<Self> { .key(.glaze) }

            // Not required, but can be used to use [dynamicMember:] subscript directly to retrieve
            // the value for a component.
            var keyPath: KeyPath<Self.Type, ValueKey<Self>> {
                switch self {
                case .greenware: \.greenwareValue
                case .bisque:    \.bisqueValue
                case .glaze:     \.glazeValue
                }
            }

            // Not required, but can be used to use [dynamicMember:] subscript directly to retrieve
            // a DisplayProperty for a component.
            var displayKeyPath: KeyPath<Self.Type, DisplayKey<Self>> {
                switch self {
                case .greenware: \.greenwareDisplay
                case .bisque:    \.bisqueDisplay
                case .glaze:     \.glazeDisplay
                }
            }

            // Not required, but can be used to use Binding[dynamicMember:] subscript directly to
            // retrieve a binding to the value of a component.
            // The returned keypaths require IdentifiableShiftWithDynamicMemberLookup.
            var bindingValueKeyPath: WritableKeyPath<Firings, Bool> {
                switch self {
                case .greenware: \.greenwareValue
                case .bisque:    \.bisqueValue
                case .glaze:     \.glazeValue
                }
            }

            // Not required, but can be used to use Binding[dynamicMember:] subscript directly to
            // retrieve a binding to the DisplayProperty of a component.
            // The returned keypaths require IdentifiableShiftWithDynamicMemberLookup.
            var bindingDisplayKeyPath: WritableKeyPath<Firings, DisplayProperty<Bool>> {
                switch self {
                case .greenware: \.greenwareDisplay
                case .bisque:    \.bisqueDisplay
                case .glaze:     \.glazeDisplay
                }
            }
        }

        // The usual static properties to define each OptionSet component are not required, although
        // these are still useful.
        static let glaze: Self = .init(shift: .glaze)
    }

}


// MARK: - Previews


#Preview("Example", traits: .scrollViewWrap, PreviewContent.layout) {
    @Previewable @State var options: PreviewContent.Firings = [
        .init(shift: .greenware), // Option sets can be initialized with a Shift
        .glaze // Or with the usual static property, when defined.
    ]
    PreviewContent.captioned("Using `[shift:]` subscript.") {
        Text("Greenware: \(options[shift: .greenware].description)")
    }
    PreviewContent.captioned("Using value dynamic member.") {
        Text("Bisque: \(options.bisqueValue.description)")
    }
    PreviewContent.captioned("Using `.contains(_:)`, the usual way.") {
        Text("Glazed: \(options.contains(.glaze).description)")
    }

    DashedDivider()

    PreviewContent.captioned("Using `displayProperty(for:)`.") {
        Text(property: options.displayProperty(for: .greenware))
    }
    PreviewContent.captioned("Using `DisplayProperty` dynamic member.") {
        Text(property: options.greenwareDisplay)
    }
    PreviewContent.captioned("Using `[dynamicMember:]` directly.") {
        let displayKeyPath = PreviewContent.Firings.Shift.glaze.displayKeyPath
        Text(property: options[dynamicMember: displayKeyPath])
    }

    DashedDivider()

    PreviewContent.captioned("Toggles iterating through `Shift` cases.") {
        ForEach(PreviewContent.Firings.Shift.allCases) { shift in
            Toggle(shift.displayKey, isOn: $options.binding(for: shift))
        }
    }

    DashedDivider()

    PreviewContent.captioned("Using `Binding` inherited value dynamic member.") {
        let shift = PreviewContent.Firings.Shift.greenware
        Toggle(shift.displayKey, isOn: $options.greenwareValue)
    }
    PreviewContent.captioned("Using `Binding[shift:]` inherited subscript.") {
        let shift = PreviewContent.Firings.Shift.bisque
        Toggle(shift.displayKey, isOn: $options[shift: shift])
    }
    PreviewContent.captioned("Using `Binding[dynamicMember:]` inherited subscript.") {
        let shift = PreviewContent.Firings.Shift.glaze
        Toggle(shift.displayKey, isOn: $options[dynamicMember: shift.bindingValueKeyPath])
    }

    DashedDivider()

    PreviewContent.captioned("Using `Binding.displayProperty(for:)`.") {
        Toggle(property: $options.displayProperty(for: .greenware))
    }
    PreviewContent.captioned("Using `Binding` dynamic property.") {
        Toggle(property: $options.bisqueDisplay)
    }
    PreviewContent.captioned("Using `Binding[dynamicMember:]` inherited subscript.") {
        let bindingDisplayKeyPath = PreviewContent.Firings.Shift.glaze.bindingDisplayKeyPath
        Toggle(property: $options[dynamicMember: bindingDisplayKeyPath])
    }

}
