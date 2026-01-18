//
//  DisplayProperty.swift
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct DisplayProperty<Value> {
    let displayKey: LocalizedStringKey
    let value: Value
}


struct BindingDisplayProperty<Value> {
    let displayKey: LocalizedStringKey
    let value: Value
    let binding: Binding<Value>

    init(property: DisplayProperty<Value>, binding: Binding<Value>) {
        self.displayKey = property.displayKey
        self.value = property.value
        self.binding = binding
    }
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

    init(property: BindingDisplayProperty<Bool>) where Label == Text {
        self.init(property.displayKey, isOn: property.binding)
    }

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, .iPhoneProSizeForcedLayout) {
    @Previewable @State var boolean: Bool = true

    let property = DisplayProperty(displayKey: "Display Boolean", value: boolean)
    let bindingProperty = BindingDisplayProperty(property: property, binding: $boolean)

    Text(property: property)
    Toggle(property: bindingProperty)

    CaptionRectangle(
        "Content", color: boolean ? .teal : .indigo,
        size: .square(of: 100))
}

