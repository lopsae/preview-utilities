//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct CollectionAdditionsTests {

    @Test func indexed() {
        let array: [String] = ["zero", "one", "two", "three", "four"]

        // Tuples do not conform to `Equatable` automatically,
        // each has to be compared directly against another tuple.
        let expectedIndexed = [(0, "zero"), (1, "one"), (2, "two"), (3, "three"), (4, "four")]
        #expect(array.count == expectedIndexed.count)

        // TODO: use zip?
        for enumeratedTuple in array.indexed().enumerated() {
            let (offset, indexedTuple) = enumeratedTuple
            #expect(indexedTuple == expectedIndexed[offset])
        }
    }


    /// Uses an array slice, since that will have offset indices.
    @Test func indexedWithSlice() {
        let slice = Strings.natoPhoneticAlphabet[5..<10]

        // Tuples do not conform to `Equatable` automatically,
        // each has to be compared directly against another tuple.
        let expectedIndexed = [
            (5, "foxtrot"),
            (6, "golf"),
            (7, "hotel"),
            (8, "india"),
            (9, "juliett")
        ]

        #expect(slice.count == expectedIndexed.count)

        // TODO: use zip?
        for enumeratedTuple in slice.indexed().enumerated() {
            let (offset, indexedTuple) = enumeratedTuple
            #expect(indexedTuple == expectedIndexed[offset])
        }
    }

}
