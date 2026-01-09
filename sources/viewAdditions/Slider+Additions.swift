//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Slider where Label : View {

    // Documentation is based in both Slider and Picker original documentation.


    /// Creates a slider to select a value from a given range, which generates its label, and
    /// displays the provided labels for current and bounds values.
    ///
    /// This initializer creates a ``SwiftUI/Text`` view on your behalf, and treats the
    /// localized key similar to ``SwiftUI/Text/init(_:tableName:bundle:comment:)``. See
    /// ``SwiftUI/Text`` for more information about localizing strings.
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


    /// Creates a slider to select a value from a given range, which generates labels for itself,
    /// current, and bounds values.
    ///
    /// This initializer creates ``SwiftUI/Text`` views on your behalf using the localized key for
    /// the slider label, and transforming the current and bounds values through the format style
    /// for their respective label.
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


    /// Creates a slider to select a value from a given range subject to a step increment, which generates labels for itself, current, and bounds values.
    ///
    /// This initializer creates ``SwiftUI/Text`` views on your behalf using the localized key for
    /// the slider label, and transforming the current and bounds values through the format style
    /// for their respective label.
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


    /// Creates a slider to select a value from a given range, which generates labels for itself,
    /// current, and bounds values.
    ///
    /// This initializer creates ``SwiftUI/Text`` views on your behalf using the localized key for
    /// the slider label, and transforming the current and bounds values through a single format
    /// style for their respective label.
    init<Value>(
        _ title: LocalizedStringKey,
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        valueFormat: any FormatStyle<Value, String>,
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
            currentValueLabel: { Text(value.wrappedValue, format: valueFormat) },
            minimumValueLabel: { Text(bounds.lowerBound, format: valueFormat) },
            maximumValueLabel: { Text(bounds.upperBound, format: valueFormat) },
            onEditingChanged: onEditingChanged
        )
    }


    /// Creates a slider to select a value from a given collection, which generates labels for itself,
    /// current, and bounds values.
    ///
    /// This initializer creates ``SwiftUI/Text`` views on your behalf using the localized key for
    /// the slider label, and transforming the collection-mapped current and bounds values through
    /// the format style for their respective label.
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


    /// Creates a slider to select a value from a `StringProtocol` collection, which generates
    /// labels for itself, current, and bounds values.
    ///
    /// This initializer creates ``SwiftUI/Text`` views on your behalf using the localized key for
    /// the slider label, and collection-mapped current and bounds values verbatim.
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

        // TODO: dry, repeated in other constructors
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
        // TODO: Use Preview Caption
        Text("Slider with the natoPhoneticAlphabet collection, current formatted with identity, and bounds formatted with capitalized first character.")
            .font(.caption)
            .padding(.bottom)

        Text("Value:  \(value, format: .fractionLength(2))")
            .monospaced()
        Text("Mapped: \(mapped)")
            .monospaced()

        Slider(
            "Collection Slider",
            collection: String.natoPhoneticAlphabet,
            value: $value,
            mapped: $mapped,
            currentMappedFormat: .identity,
            boundsMappedFormat: .firstCharacter(capitalized: true)
        )
    }
    .padding(.horizontal)
}


#Preview("String Collection", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var value: Double = 10
    @Previewable @State var mapped: String = "Not-Assigned"

    VStack(alignment: .leading) {
        Text("Slider with the natoPhoneticAlphabet collection, no formats used.")
            .font(.caption)
            .padding(.bottom)

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
