//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


extension Sequence {

    // TODO: note in documentation that per `Dictionary(uniqueKeysWithValues`, passing a duplicate key results in a runtime error.
    @inlinable public func dictionaryMap<Key: Hashable, Value>(
        key keyTransform: (Element) -> Key,
        value valueTransform: (Element) -> Value
    ) -> [Key: Value] {
        let tuples = self.map { (keyTransform($0), valueTransform($0)) }
        return Dictionary(uniqueKeysWithValues: tuples)
    }


    @inlinable public func dictionaryMap<Key: Hashable, Value>(
        key keyTransform: (Element) -> Key,
        value: Value
    ) -> [Key: Value] {
        let tuples = self.map { (keyTransform($0), value) }
        return Dictionary(uniqueKeysWithValues: tuples)
    }

}


extension Sequence where Element: Hashable {

    // TODO: note in documentation that per `Dictionary(uniqueKeysWithValues`, passing a duplicate key results in a runtime error.
    @inlinable public func dictionaryMap<Value>(
        value valueTransform: (Element) -> Value
    ) -> [Element: Value] {
        let tuples = self.map { ($0, valueTransform($0)) }
        return Dictionary(uniqueKeysWithValues: tuples)
    }


    @inlinable public func dictionaryMap<Value>(
        value: Value
    ) -> [Element: Value] {
        let tuples = self.map { ($0, value) }
        return Dictionary(uniqueKeysWithValues: tuples)
    }
}
