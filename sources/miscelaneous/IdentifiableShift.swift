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

    // TODO: can this be made writable, to generate a DisplayPropertyBinding?
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

    @ViewBuilder
    static func captioned(
        _ captionKey: LocalizedStringKey,
        @ViewBuilder content: () -> some View
    ) -> some View {
        VStack(alignment: .leading) {
            Text(captionKey).font(.caption)
            content()
        }
        .maxWidthFrame(alignment: .leading)
        .padding(.bottom, 5)
    }

    struct Firings: OptionSet, IdentifiableShiftWithDynamicMemberLookup {
        let rawValue: Int

        enum Shift: Int, CaseIterable, SelfIdentifiable, DisplayKeyProvider {
            case _greenware = 0, _bisque, _glaze

            // These properties define the available `KeyPath<Shift.Type, Shift>` and thus the
            // actual names of the dynamic members available in the OptionSet.
            // Sadly, keypath cannot read the cases directly.
            static var boneDry: Self { ._greenware } // Different name from enum.
            static var bisque:  Self { ._bisque }
            static var glaze:   Self { ._glaze }

            // TODO: a diferent set of static vars returning LocalizationKey could be defined to produce a separate dynamic member for DisplayProperties

            // Implementation for DisplayKeyProvider, allows the OptionSet to produce DisplayProperties.
            var displayKey: LocalizedStringKey {
                switch self {
                case ._greenware: "Bone Dry"
                case ._bisque:    "Bisque"
                case ._glaze:     "Glaze"
                }
            }

            // Not required, but can be used to use [dynamicMember:] subscript directly.
            // The returned keypaths require IdentifiableShiftWithDynamicMemberLookup.
            var keyPath: KeyPath<Self.Type, Self> {
                switch self {
                case ._greenware: \.boneDry
                case ._bisque:    \.bisque
                case ._glaze:    \.glaze
                }
            }

            // Not required, but can be used to use Binding[dynamicMember:] subscript directly.
            // The returned keypaths require IdentifiableShiftWithDynamicMemberLookup.
            var bindingKeyPath: WritableKeyPath<Firings, Bool> {
                switch self {
                case ._greenware: \.boneDry
                case ._bisque:    \.bisque
                case ._glaze:     \.glaze
                }
            }
        }

        // TODO: are the static properties even needed?
        static let glaze: Self = .init(shift: .glaze)
    }

}


// MARK: - Previews


#Preview("Example", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var options: PreviewContent.Firings = [
        // Option sets can be initialized with a Shift
        .init(shift: .boneDry),
        // Or with the usual static property, when defined.
        .glaze
    ]
    PreviewContent.captioned("Using `[shift:]` subscript.") {
        Text("Bone Dry: \(options[shift: .boneDry].description)")
    }
    PreviewContent.captioned("Using `Bool` Dynamic Member.") {
        // Needs to be casted since dynamic member is overloaded twice: returns Boo or DisplayProperty.
        let bisqueBool: Bool = options.bisque
        Text("Bisque: \(bisqueBool.description)")
    }
    PreviewContent.captioned("Using `.contains(_:)`, the usual way.") {
        Text("Glazed: \(options.contains(.glaze).description)")
    }

    DashedDivider()

    PreviewContent.captioned("Using `displayProperty(for:)`.") {
        Text(property: options.displayProperty(for: .boneDry))
    }
    PreviewContent.captioned("Using `DisplayProperty` Dynamic Member.") {
        Text(property: options.bisque)
    }
    PreviewContent.captioned("Using `[dynamicMember:]` directly.") {
        let keyPath = PreviewContent.Firings.Shift.glaze.keyPath
        Text(property: options[dynamicMember: keyPath])
    }

    DashedDivider()

    PreviewContent.captioned("Toggles iterating through `Shift` cases.") {
        ForEach(PreviewContent.Firings.Shift.allCases) { shift in
            Toggle(shift.displayKey, isOn: $options.binding(for: shift))
        }
    }

    DashedDivider()

    PreviewContent.captioned("Toggle using `Binding` inherited dynamic member.") {
        let shift = PreviewContent.Firings.Shift.boneDry
        Toggle(shift.displayKey, isOn: $options.boneDry)
    }
    PreviewContent.captioned("Toggle using `Binding` inherited subscript.") {
        let shift = PreviewContent.Firings.Shift.bisque
        Toggle(shift.displayKey, isOn: $options[shift: shift])
    }
    PreviewContent.captioned("Toggle using `Binding` inherited `[dynamicMember:]`.") {
        let shift = PreviewContent.Firings.Shift.glaze
        Toggle(shift.displayKey, isOn: $options[dynamicMember: shift.bindingKeyPath])
    }

    DashedDivider()

    PreviewContent.captioned("Toggle using `BindingDisplayProperty`.") {
        let shift = PreviewContent.Firings.Shift.boneDry
        Toggle(property: $options.displayProperty(for: .boneDry))
    }

}
