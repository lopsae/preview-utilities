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

}


