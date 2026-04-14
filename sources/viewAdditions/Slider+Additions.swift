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
    init<Value, CurrentFormat, BoundsFormat>(
        _ title: LocalizedStringKey,
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        currentValueFormat: CurrentFormat,
        boundsValueFormat: BoundsFormat,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) where
        // This initializer uses generics for the parameters FormatStyle, instead of `any FormatStyle`
        // as used in the rest of initializers. This should work exactly the same.
        // This was changed to mimic how Text works, which uses generics for the FormatStyle as well.
        // If this causes no issues in the long term, this should be the preferred approach.
        Value : BinaryFloatingPoint,
        Value.Stride : BinaryFloatingPoint,
        CurrentFormat: FormatStyle,
        CurrentFormat.FormatInput == Value,
        CurrentFormat.FormatOutput == String,
        BoundsFormat: FormatStyle,
        BoundsFormat.FormatInput == Value,
        BoundsFormat.FormatOutput == String,
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
        Value: BinaryFloatingPoint & Sendable,
        Value.Stride : BinaryFloatingPoint,
        MapCollection: BidirectionalCollection & Sendable,
        MapCollection.Element: Equatable & Sendable,
        MapCollection.Index == Int,
        Label == Text,
        ValueLabel == Text
    {
        guard !collection.isEmpty else {
            fatalError("Fatal error: Empty collection.")
        }

        let mapBinding = value.afterSet { newValue in
            let rounded = newValue.rounded(.toNearestOrEven)
            mapped.wrappedValue = collection[rounded.asInt]
        }

        self.init(
            value: mapBinding,
            in: Value(collection.startIndex)...Value(collection.finalIndex),
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
        Value: BinaryFloatingPoint & Sendable,
        Value.Stride : BinaryFloatingPoint,
        MapCollection: BidirectionalCollection & Sendable,
        MapCollection.Element: StringProtocol & Sendable,
        MapCollection.Index == Int,
        Label == Text,
        ValueLabel == Text
    {
        guard !collection.isEmpty else {
            fatalError("Fatal error: Empty collection.")
        }

        let mapBinding = value.afterSet { newValue in
            let rounded = newValue.rounded(.toNearestOrEven)
            mapped.wrappedValue = collection[rounded.asInt]
        }

        self.init(
            value: mapBinding,
            in: Value(collection.startIndex)...Value(collection.finalIndex),
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


// MARK: - Convenience functions


extension Slider {

    public static func captioned<Value, CurrentFormat, BoundsFormat>(
        _ title: LocalizedStringKey,
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        step: Value.Stride = 1,
        currentValueFormat: CurrentFormat,
        boundsValueFormat: BoundsFormat,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) -> some View
    where
        Value: BinaryFloatingPoint,
        Value.Stride: BinaryFloatingPoint,
        CurrentFormat: FormatStyle,
        CurrentFormat.FormatInput == Value,
        CurrentFormat.FormatOutput == String,
        BoundsFormat: FormatStyle,
        BoundsFormat.FormatInput == Value,
        BoundsFormat.FormatOutput == String,
        Label == Text,
        ValueLabel == Text
    {
        let slider = Slider(
            title, value: value, in: bounds,
            currentValueFormat: currentValueFormat,
            boundsValueFormat: boundsValueFormat,
            onEditingChanged: onEditingChanged)

        #if os(iOS)
            return VStack {
                slider
                Text("\(Text(title)): \(value.wrappedValue, format: currentValueFormat)")
                    .font(.caption.monospaced())
            }
        #elseif os(macOS)
            return HStack {
                slider
                ZStack {
                    // TODO: use both upperBound and lowerBound as minimum size.
                    // TODO: make a utility text that handles this. Could be used here and in HistoricValue.
                    // TODO: also bring PlaceholderText from external project.
                    // Hidden view to keep the size of the largest value.
                    Text(bounds.upperBound, format: currentValueFormat)
                        .font(.caption.monospaced())
                        .hidden()
                    Text(value.wrappedValue, format: currentValueFormat)
                        .font(.caption.monospaced())
                }
            }
        #else
            return slider
        #endif
    }


    public static func captioned<Value, Format>(
        _ title: LocalizedStringKey,
        value: Binding<Value>,
        in bounds: ClosedRange<Value> = 0...1,
        valueFormat: Format,
        onEditingChanged: @escaping (Bool) -> Void = { _ in }
    ) -> some View
    where
        Value : BinaryFloatingPoint,
        Value.Stride : BinaryFloatingPoint,
        Format: FormatStyle,
        Format.FormatInput == Value,
        Format.FormatOutput == String,
        Label == Text,
        ValueLabel == Text
    {
        Self.captioned(
            title, value: value, in: bounds,
            currentValueFormat: valueFormat,
            boundsValueFormat: valueFormat,
            onEditingChanged: onEditingChanged)
    }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

     static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeForcedLayout

}


#Preview("Collection", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var value: Double = 10
    @Previewable @State var mapped: String = "Not-Assigned"

    PreviewCaption("""
        Slider using the `natoPhoneticAlphabet` collection, `currentValue` formatted with identity,
        and `boundsValues` formatted with capitalized first character.
        """)

    VStack(alignment: .leading) {
        Text("Value:  \(value, format: .fractionLength(2))")
            .monospaced()
        Text("Mapped: \(mapped)")
            .monospaced()

        Slider(
            "Collection Slider",
            collection: Strings.natoPhoneticAlphabet,
            value: $value,
            mapped: $mapped,
            currentMappedFormat: .identity,
            boundsMappedFormat: .firstCharacter(capitalized: true)
        )
    }
}


#Preview("String Collection", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var value: Double = 10
    @Previewable @State var mapped: String = "Not-Assigned"

    PreviewCaption("""
        Slider using the `natoPhoneticAlphabet` collection, no formats used, both `currentValue`
        and `boundsValues` use directly the values in the collection.
        """)

    VStack(alignment: .leading) {
        Text("Value:  \(value, format: .fractionLength(2))")
            .monospaced()
        Text("Mapped: \(mapped)")
            .monospaced()

        Slider(
            "Collection Slider",
            collection: Strings.natoPhoneticAlphabet,
            value: $value,
            mapped: $mapped
        )
    }
}


#Preview("Captioned", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var value: Double = 5
    @Previewable @State var roundedValue: Double = 5

    PreviewCaption("""
        Slider using the `captioned` utility function with **separate formats**.
        """)
    Slider.captioned(
        "Captioned",
        value: $value,
        in: 0...10,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)

    PreviewCaption("""
        Slider using the `captioned` utility function with a **single format**.
        """)
    Slider.captioned(
        "Rounded",
        value: $roundedValue,
        in: 0...10,
        valueFormat: .arithmeticRoundedInteger)
    Text.caption("Actual: \(roundedValue)")
}
