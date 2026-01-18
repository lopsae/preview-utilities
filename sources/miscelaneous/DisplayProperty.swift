//
//  DisplayProperty.swift
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct DisplayProperty<Value> {
    let displayKey: LocalizedStringKey
    var value: Value
}


protocol DisplayKeyProvider {
    var displayKey: LocalizedStringKey { get }
}


// Used to define functions with a specific return type for dynamic member lookup.
struct DisplayKey<Key> {
    let key: Key
    static func key(_ key: Key) -> Self { .init(key: key) }
}


// MARK: - Views Extensions


extension Text {

    init<Value>(
        property: DisplayProperty<Value>
    ) {
        let text = Text(property.displayKey)
        let valueString = String(describing: property.value)
        self.init("\(text): \(valueString)")
    }

}


extension Toggle {

    init(property: Binding<DisplayProperty<Bool>>) where Label == Text {
        self.init(property.wrappedValue.displayKey, isOn: property.value)
    }

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, .iPhoneProSizeForcedLayout) {
    @Previewable @State var property = DisplayProperty(displayKey: "Display Boolean", value: true)

    Text(property: property)
    Toggle(property: $property)

    CaptionRectangle(
        "Content", color: property.value ? .teal : .indigo,
        size: .square(of: 100))
}

