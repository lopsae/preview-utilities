//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct HashableAdditionsTests {

    @Test func hashWith() {
        #expect(1.hash(with: "One") == 1.hash(with: "One"))
        #expect(1.hash(with: "One") == Hasher.combining(1, "One"))
        #expect(1.hash(with: "One") != 1.hash(with: "Two"))
        #expect(1.hash(with: "One") != 2.hash(with: "One"))
    }

    @Test func isEqualToAny() {
        #expect(1.isEqual(toAny: 1))
        #expect(1.isEqual(toAny: 1, 2, 3))
        #expect(3.isEqual(toAny: 1, 2, 3))
        #expect("Two".isEqual(toAny: "One", "Two"))

        #expect(!1.isEqual(toAny: 2, 3))
        #expect(!1.isEqual())
        #expect(!"Three".isEqual(toAny: "One", "Two"))
    }

}


struct HasherAdditionsTests {

    @Test func combining() {
        #expect(Hasher.combining(1, "One") == Hasher.combining(1, "One"))
        #expect(Hasher.combining() == Hasher.combining())

        #expect(Hasher.combining(1, "One") != Hasher.combining("One", 1))
        #expect(Hasher.combining(1, "One") != Hasher.combining(1, "Two"))
        #expect(Hasher.combining(1) != Hasher.combining(1, 1))
    }

}
