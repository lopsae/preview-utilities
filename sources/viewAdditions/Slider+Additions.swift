//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Slider where Label : View {

    /// Creates a slider to select a value from a given range, which displays a slider label, and
    /// displays the provided labels for current and bounds values.
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


    /// Creates a slider to select a value from a given range, which displays a slider label and
    /// produces labels for current and bounds values.
    init<Value>(
        _ title: LocalizedStringKey,
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        currentValueFormat: any FormatStyle<Value, String>,
        boundsValueFormat: any FormatStyle<Value, String>,
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


    /// Creates a slider to select a value from a given range, subject to a step increment, which
    /// displays a slider label and produces labels for current and bounds values.
    init<Value>(
        _ title: LocalizedStringKey,
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value.Stride = 1,
        currentValueFormat: any FormatStyle<Value, String>,
        boundsValueFormat: any FormatStyle<Value, String>,
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


    /// Creates a slider to select a value from a given collection, which displays a slider label
    /// and produces labels for current and bounds values.
    @MainActor
    init<Value, MapCollection>(
        _ title: LocalizedStringKey,
        collection: MapCollection,
        value: Binding<Value>,
        mapped: Binding<MapCollection.Element>,
        currentMappedFormat: any FormatStyle<MapCollection.Element, String>,
        boundsMappedFormat: any FormatStyle<MapCollection.Element, String>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where
        Value: BinaryFloatingPoint,
        Value.Stride : BinaryFloatingPoint,
        MapCollection: BidirectionalCollection,
        MapCollection.Element: Equatable,
        MapCollection.Index == Int,
        Label == Text,
        ValueLabel == Text
    {
        guard !collection.isEmpty else {
            fatalError("Fatal error: Empty collection.")
        }

        let mapBinding = Binding<Value> {
            value.wrappedValue
        } set: { newValue in
            let rounded = newValue.rounded(.toNearestOrEven)
            value.wrappedValue = newValue
            mapped.wrappedValue = collection[rounded.asInt]
        }

        self.init(
            value: mapBinding,
            in: Value(collection.startIndex)...Value(collection.beforeEndIndex),
            step: 1.0,
            neutralValue: nil,
            enabledBounds: nil,
            label: { Text(title) },
            currentValueLabel: { Text(mapped.wrappedValue, format: currentMappedFormat) },
            minimumValueLabel: { Text(collection.first!, format: boundsMappedFormat) },
            maximumValueLabel: { Text(collection.last!, format: boundsMappedFormat) },
            tick: { _ in nil },
            onEditingChanged: onEditingChanged
        )
    }


    /// Creates a slider to select a value from a given `StringProtocol` collection, which displays
    /// a slider label uses collection values for current and bounds labels.
    @MainActor
    init<Value, MapCollection>(
        _ title: LocalizedStringKey,
        collection: MapCollection,
        value: Binding<Value>,
        mapped: Binding<MapCollection.Element>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where
        Value: BinaryFloatingPoint,
        Value.Stride : BinaryFloatingPoint,
        MapCollection: BidirectionalCollection,
        MapCollection.Element: StringProtocol,
        MapCollection.Index == Int,
        Label == Text,
        ValueLabel == Text
    {
        guard !collection.isEmpty else {
            fatalError("Fatal error: Empty collection.")
        }

        // TODO: dry
        let mapBinding = Binding<Value> {
            value.wrappedValue
        } set: { newValue in
            let roundedValue = newValue.rounded(.toNearestOrEven)
            value.wrappedValue = newValue
            mapped.wrappedValue = collection[roundedValue.asInt]
        }

        self.init(
            value: mapBinding,
            in: Value(collection.startIndex)...Value(collection.beforeEndIndex),
            step: 1.0,
            neutralValue: nil,
            enabledBounds: nil,
            label: { Text(title) },
            currentValueLabel: {
                let roundedValue = value.wrappedValue.rounded(.toNearestOrEven)
                Text(collection[roundedValue.asInt])
            },
            minimumValueLabel: { Text(collection.first!) },
            maximumValueLabel: { Text(collection.last!) },
            tick: { _ in nil },
            onEditingChanged: onEditingChanged
        )
    }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

     static let layout: PreviewTrait<Preview.ViewTraits> = .fixedLayout(width: 400, height: 400)

}


#Preview("Collection", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var value: Double = 10
    @Previewable @State var mapped: String = "Not-Assigned"

    VStack(alignment: .leading) {
        Text("Value:  \(value, format: .fractionLength(2))")
            .monospaced()
        Text("Mapped: \(mapped)")
            .monospaced()

        Slider(
            "Collection Slider",
            collection: String.natoPhoneticAlphabet,
            value: $value,
            mapped: $mapped,
            currentMappedFormat: .passthrough,
            boundsMappedFormat: .firstCharacter(capitalized: true)
        )
    }
    .padding()
}


#Preview("String Collection", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var value: Double = 10
    @Previewable @State var mapped: String = "Not-Assigned"

    VStack(alignment: .leading) {
        Text("Value:  \(value, format: .fractionLength(2))")
            .monospaced()
        Text("Mapped: \(mapped)")
            .monospaced()

        Slider(
            "Collection Slider",
            collection: String.natoPhoneticAlphabet,
            value: $value,
            mapped: $mapped
        )
    }
    .padding()
}
