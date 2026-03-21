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


    /// Uses an array slice, since that will have offset indices.
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

}
