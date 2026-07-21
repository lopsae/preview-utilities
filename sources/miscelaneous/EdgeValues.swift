//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Playgrounds
import SwiftUI


// TODO: A protocol that defines the functionality of EdgeValues could be used to make this
// structure compatible with UIEdgeInsets.


nonisolated
struct EdgeValues<Value> {

    var top: Value
    var leading: Value
    var bottom: Value
    var trailing: Value

    init(top: Value, leading: Value, bottom: Value, trailing: Value) {
        self.top      = top
        self.leading  = leading
        self.bottom   = bottom
        self.trailing = trailing
    }

    init(top: Value, lea: Value, bot: Value, tra: Value) {
        self.init(top: top, leading: lea, bottom: bot, trailing: tra)
    }

    init(all value: Value) {
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }

    init(
        top:      Value? = nil,
        leading:  Value? = nil,
        bottom:   Value? = nil,
        trailing: Value? = nil,
        default value: Value,
    ) {
        self.init(
            top:      top      ?? value,
            leading:  leading  ?? value,
            bottom:   bottom   ?? value,
            trailing: trailing ?? value
        )
    }

    init(horizontal: Value, vertical: Value) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }


    init<OtherValue>(edgeValues: EdgeValues<OtherValue>, property: KeyPath<OtherValue, Value>) {
        self.init(
            top:      edgeValues.top[keyPath: property],
            leading:  edgeValues.lea[keyPath: property],
            bottom:   edgeValues.bot[keyPath: property],
            trailing: edgeValues.tra[keyPath: property]
        )
    }

    var lea: Value { leading }
    var bot: Value { bottom }
    var tra: Value { trailing }

    subscript(_ edge: Edge) -> Value {
        get {
            switch edge {
            case .top:      self.top
            case .leading:  self.leading
            case .bottom:   self.bottom
            case .trailing: self.trailing
            }
        }
        set {
            switch edge {
            case .top:      self.top     = newValue
            case .leading:  self.leading  = newValue
            case .bottom:   self.bottom   = newValue
            case .trailing: self.trailing = newValue
            }
        }

    }


    subscript(set edgeSet: Edge.Set) -> EdgeValuesProxy<Value> {
        get {
            var values: [Edge: Value] = [:]
            for edge in Edge.allCases {
                if edgeSet.contains(edge.set) {
                    values[edge] = self[edge]
                }
            }
            return .init(values: values)
        }
        set(newProxy) {
            for (edge, newValue) in newProxy.values {
                self[edge] = newValue
            }
        }
    }

    // TODO: could this be done lazily with a view of EdgeValues? This would require the EdgeValuesContainer protocol.
    func map<NewValue>(_ transform: (Value) throws -> NewValue) rethrows -> EdgeValues<NewValue> {
        .init(
            top:      try transform(top),
            leading:  try transform(leading),
            bottom:   try transform(bottom),
            trailing: try transform(trailing)
        )
    }

}


nonisolated
extension EdgeValues: Equatable where Value: Equatable {}

nonisolated
extension EdgeValues: Sendable where Value: Sendable {}


@dynamicMemberLookup
nonisolated
struct EdgeValuesProxy<Value> {

    private(set) var values: [Edge: Value]

    init(values: [Edge : Value]) {
        self.values = values
    }

    subscript<Property>(dynamicMember keyPath: WritableKeyPath<Value, Property>) -> Property? {
        get {
            values.first?.value[keyPath: keyPath]
        }
        set(newProperty) {
            // The return value of this subscript needs to be optional, to support creation of this
            // proxy with a empty Edge.Set. Given that it is optional, it is possible to set the
            // value of a property to nil, in which case the set is ignored.
            // However, if a property is itself optional, it seems not possible to set said property
            // to nil because the set is ignored through this interface.
            guard let newProperty else { return }
            for (edge, value) in values {
                var newValue = value
                newValue[keyPath: keyPath] = newProperty
                values[edge] = newValue
            }
        }
    }

}


// MARK: - Playgrounds


private struct Dummy {
    var string: String
    var optional: String?
}


#Playground("Edge.Set Modification") {
    var lineSet: EdgeValues<EdgeGraticule.LineSet> = .init(
        top: .init(spacing: 5,  through: 4),
        lea: .init(spacing: 10, through: 3),
        bot: .init(spacing: 15, through: 2),
        tra: .init(spacing: 20, through: 1)
    )

    _ = lineSet[.top].spacing
    _ = lineSet[set: .horizontal]

    lineSet[set: .vertical].spacing = 30
    _ = lineSet
}


#Playground("Optionals") {
    var edgeValues = EdgeValues(all: Dummy(string: "one", optional: "maybe"))

    // Set to an edgeSet.
    edgeValues[set: .leading].string = "leading"

    // Nil is ignored.
    edgeValues[set: .trailing].string = nil
    _ = edgeValues

    // Nil is valid, but is also ignored.
    edgeValues[set: .top].optional = nil
    _ = edgeValues
}
