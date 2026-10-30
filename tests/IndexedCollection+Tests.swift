//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct IndexedCollectionTests {

    @Test func indexed() {
        let array: [String] = ["zero", "one", "two", "three", "four"]
        let indexedArray = array.indexed()

        // Tuples do not conform to `Equatable` automatically,
        // each has to be compared directly against another tuple.
        let expectedTuples: [(index: Int, element: String)] = [
            (0, "zero"),
            (1, "one"),
            (2, "two"),
            (3, "three"),
            (4, "four")
        ]
        #expect(array.count == expectedTuples.count)

        for (indexedTuple, expectedTuple) in zip(indexedArray, expectedTuples) {
            #expect(indexedTuple.index == expectedTuple.index)
            #expect(indexedTuple.element == expectedTuple.element)
            #expect(indexedTuple == expectedTuple)
        }
    }


    /// Uses an array slice with offset indices.
    @Test func indexedWithSlice() {
        let slice = Strings.natoPhoneticAlphabet[5..<10]
        let indexedSlice = slice.indexed()

        // Tuples do not conform to `Equatable` automatically,
        // each has to be compared directly against another tuple.
        let expectedTuples: [(index: Int, element: String)] = [
            (5, "foxtrot"),
            (6, "golf"),
            (7, "hotel"),
            (8, "india"),
            (9, "juliett")
        ]

        #expect(slice.count == expectedTuples.count)

        for (indexedTuple, expectedTuple) in zip(indexedSlice, expectedTuples) {
            #expect(indexedTuple.index == expectedTuple.index)
            #expect(indexedTuple.element == expectedTuple.element)
            #expect(indexedTuple == expectedTuple)
        }
    }


    /// Uses a string to test non-integer indexes.
    @Test func indexedWithString() {
        let string: String = "string"
        var iterator = string.indexed().makeIterator()

        var index = string.startIndex
        var counter = 0

        while let tuple = iterator.next() {
            let element = string[index]
            #expect(tuple.index == index)
            #expect(tuple.element == element)
            #expect(string[tuple.index] == element)

            index = string.index(after: index)
            counter += 1
        }

        #expect(string.endIndex == index)
        #expect(counter == 6)
    }

}
