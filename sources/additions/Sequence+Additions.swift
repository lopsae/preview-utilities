//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import Foundation


extension Sequence {

    /// Produces a dictionary mapping each elements of the sequence to a key and their corresponding
    /// value.
    ///
    /// The mapped keys must not produce duplicates.
    ///
    /// Uses `Dictionary(uniqueKeysWithValues:)` internally, which will produce a runtime error if
    /// given duplicate keys.
    @inlinable public func dictionaryMap<Key: Hashable, Value>(
        key keyTransform: (Element) -> Key,
        value valueTransform: (Element) -> Value
    ) -> [Key: Value] {
        let tuples = self.map { (keyTransform($0), valueTransform($0)) }
        return Dictionary(uniqueKeysWithValues: tuples)
    }


    /// Produces a dictionary mapping each elements of the sequence to a key, and using the given
    /// value for all keys.
    ///
    /// The mapped keys must not produce duplicates.
    ///
    /// Uses `Dictionary(uniqueKeysWithValues:)` internally, which will produce a runtime error if
    /// given duplicate keys.
    @inlinable public func dictionaryMap<Key: Hashable, Value>(
        key keyTransform: (Element) -> Key,
        value: Value
    ) -> [Key: Value] {
        let tuples = self.map { (keyTransform($0), value) }
        return Dictionary(uniqueKeysWithValues: tuples)
    }

}


// MARK: - Hashable Elements


extension Sequence where Element: Hashable {

    /// Produces a dictionary using the elements of the sequence as keys, and mapping each key to
    /// a corresponding value.
    ///
    /// The sequence must not have duplicate elements.
    ///
    /// Uses `Dictionary(uniqueKeysWithValues:)` internally, which will produce a runtime error if
    /// given duplicate keys.
    @inlinable public func dictionaryMap<Value>(
        value valueTransform: (Element) -> Value
    ) -> [Element: Value] {
        let tuples = self.map { ($0, valueTransform($0)) }
        return Dictionary(uniqueKeysWithValues: tuples)
    }


    /// Produces a dictionary using the elements of the sequence as keys, and using the given value
    /// for all keys.
    ///
    /// The sequence must not have duplicate elements.
    ///
    /// Uses `Dictionary(uniqueKeysWithValues:)` internally, which will produce a runtime error if
    /// given duplicate keys.
    @inlinable public func dictionaryMap<Value>(
        value: Value
    ) -> [Element: Value] {
        let tuples = self.map { ($0, value) }
        return Dictionary(uniqueKeysWithValues: tuples)
    }
}


// MARK: - FormatStyle Elements


extension Sequence {

    nonisolated
    func map<Format>(formatting format: Format)
    -> [Format.FormatOutput]
    where Format: FormatStyle, Element == Format.FormatInput
    {
        self.map { element in
            format.format(element)
        }
    }

}
