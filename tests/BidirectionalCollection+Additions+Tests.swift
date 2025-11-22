//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct BidirectionalCollectionAdditionsTests {

    @Test func clampIndex() {
        let array: [String] = ["one", "two", "three", "four", "five", "six"]
        #expect(array.count == 6)

        #expect(array.clampIndex(-1) == 0)

        #expect(array.clampIndex(0) == 0)
        #expect(array.clampIndex(1) == 1)
        #expect(array.clampIndex(5) == 5)
        #expect(array.clampIndex(6) == 5)

        let emptyArray: [String] = []
        #expect(emptyArray.clampIndex(0) == nil)
        #expect(emptyArray.clampIndex(5) == nil)

        let slice = array.suffix(from: 3)
        #expect(slice.count == 3)
        #expect(slice.indices == 3..<6)

        #expect(slice.clampIndex(0) == 3)
        #expect(slice.clampIndex(1) == 3)
        #expect(slice.clampIndex(3) == 3)
        #expect(slice.clampIndex(4) == 4)
        #expect(slice.clampIndex(5) == 5)
        #expect(slice.clampIndex(6) == 5)
        #expect(slice.clampIndex(9) == 5)
    }

}
