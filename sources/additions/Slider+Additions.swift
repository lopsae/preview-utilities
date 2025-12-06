//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Slider where Label : View {

    init<Value>(
        _ title: LocalizedStringKey,
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        @ViewBuilder currentValueLabel: () -> some View = { EmptyView() },
        @ViewBuilder boundsValueLabel: (Value) -> ValueLabel = { (_: Value) in EmptyView() },
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where
        Value : BinaryFloatingPoint,
        Value.Stride : BinaryFloatingPoint,
        Label == Text
    {
        self.init(
            value: value,
            in: bounds,
            neutralValue: nil,
            enabledBounds: nil,
            label: { Text(title) },
            currentValueLabel: currentValueLabel,
            minimumValueLabel: { boundsValueLabel(bounds.lowerBound) },
            maximumValueLabel: { boundsValueLabel(bounds.upperBound) },
            onEditingChanged: onEditingChanged
        )
    }


    init<Value>(
        _ title: LocalizedStringKey,
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        currentValueFormat: FormatStyle<Value, String>,
        boundsValueFormat: FormatStyle<Value, String>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where
        Value : BinaryFloatingPoint,
        Value.Stride : BinaryFloatingPoint,
        Label == Text,
        ValueLabel == Text
    {
        self.init(
            value: value,
            in: bounds,
            neutralValue: nil,
            enabledBounds: nil,
            label: { Text(title) },
            currentValueLabel: { Text(value.wrappedValue, format: currentValueFormat) },
            minimumValueLabel: { Text(bounds.lowerBound, format: boundsValueFormat) },
            maximumValueLabel: { Text(bounds.upperBound, format: boundsValueFormat) },
            onEditingChanged: onEditingChanged
        )
    }


    init<Value>(
        _ title: LocalizedStringKey,
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value.Stride = 1,
        currentValueFormat: FormatStyle<Value, String>,
        boundsValueFormat: FormatStyle<Value, String>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where
        Value : BinaryFloatingPoint,
        Value.Stride : BinaryFloatingPoint,
        Label == Text,
        ValueLabel == Text
    {

        self.init(
            value: value,
            in: bounds,
            step: step,
            neutralValue: nil,
            enabledBounds: nil,
            label: { Text(title) },
            currentValueLabel: { Text(value.wrappedValue, format: currentValueFormat) },
            minimumValueLabel: { Text(bounds.lowerBound, format: boundsValueFormat) },
            maximumValueLabel: { Text(bounds.upperBound, format: boundsValueFormat) },
            tick: { _ in nil },
            onEditingChanged: onEditingChanged
        )
    }


    init<Value, Mapped, MapCollection>(
        _ title: LocalizedStringKey,
        valuesMap: MapCollection,
        value: Binding<Value>,
        mapped: Binding<Mapped>,
        currentMapFormat: FormatStyle<Mapped, String>,
        boundsMapFormat: FormatStyle<Mapped, String>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where
        Value : BinaryFloatingPoint,
        Value.Stride : BinaryFloatingPoint,
        Mapped: Equatable,
        MapCollection: BidirectionalCollection<Mapped>,
        MapCollection.Index == Int,
        Label == Text,
        ValueLabel == Text
    {
        guard !valuesMap.isEmpty else {
            fatalError("Fatal error: Empty collection for valuesMap.")
        }

        let mapBinding = Binding<Value> {
            value.wrappedValue
        } set: { newValue in
            let rounded = newValue.rounded(.toNearestOrEven)
            value.wrappedValue = newValue
            mapped.wrappedValue = valuesMap[rounded.asInt]
        }

        self.init(
            value: mapBinding,
            in: Value(valuesMap.startIndex)...Value(valuesMap.beforeEndIndex),
            step: 1.0,
            neutralValue: nil,
            enabledBounds: nil,
            label: { Text(title) },
            currentValueLabel: { Text(mapped.wrappedValue, format: currentMapFormat) },
            minimumValueLabel: { Text(valuesMap.first!, format: boundsMapFormat) },
            maximumValueLabel: { Text(valuesMap.last!, format: boundsMapFormat) },
            tick: { _ in nil },
            onEditingChanged: onEditingChanged
        )
    }

}


// TODO: move to its own
struct StringPassthroughFormatStyle: FormatStyle {
    func format(_ value: String) -> String { value }
}

extension FormatStyle where Self == StringPassthroughFormatStyle {
    static var passthrough: StringPassthroughFormatStyle { .init() }
}

struct FirstCharacterFormatStyle: FormatStyle {
    let capitalized: Bool

    init(capitalized: Bool = false) {
        self.capitalized = capitalized
    }

    func format(_ value: String) -> String {
        let firstCharacted = value.first?.description ?? ""
        return capitalized
            ? firstCharacted.capitalized
            : firstCharacted
    }
}

extension FormatStyle where Self == FirstCharacterFormatStyle {
    static var firstCharacter: FirstCharacterFormatStyle { .init() }
    static func firstCharacter(capitalized: Bool) -> FirstCharacterFormatStyle {
        .init(capitalized: capitalized)
    }
}


// MARK: - Previews


#Preview("ValuesMap", traits: .headerFooter) {
    @Previewable @State var value: Double = 10
    @Previewable @State var mapped: String = "Not-Assigned"

    VStack(alignment: .leading) {
        Text("Value: \(value, format: .fractionLength(2))")
            .monospaced()
        Text("Mapped: \(mapped)")
            .monospaced()

        Slider(
            "Mapped Values",
            valuesMap: String.natoPhoneticAlphabet,
            value: $value,
            mapped: $mapped,
            currentMapFormat: .passthrough,
            boundsMapFormat: .firstCharacter(capitalized: true)
        )
    }
    .padding()

}


