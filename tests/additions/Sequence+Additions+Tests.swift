//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct SequenceAdditions {

    @Test func toArray() {
        let slice = Strings.natoPhoneticAlphabet[2...4]
        #expect(slice.toArray == ["charlie", "delta", "echo"])

        let emptySlice = Strings.natoPhoneticAlphabet[5..<5]
        #expect(emptySlice.toArray == [])
    }

}
