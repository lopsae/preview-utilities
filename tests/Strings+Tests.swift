//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct StringsTests {

    /// Since Strings values are used in other tests, this tests would make it obvious if a simple
    /// change (for example: capitalization) may impact other tests.
    @Test func values() {
        #expect(Strings.natoPhoneticAlphabet.prefix(3) == ["alfa", "bravo", "charlie"])
        #expect(Strings.natoPhoneticAlphabet.suffix(3) == ["x-ray", "yankee", "zulu"])
    }

}
