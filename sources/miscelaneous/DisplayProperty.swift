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

