//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import Testing


struct IdentityFormatStyleTests {

    @Test func extensions() {
        #expect("black quartz".formatted(.identity) == "black quartz")
    }

    @Test func string() {
        let style = IdentityFormatStyle<String>()
        #expect(style.format("black quartz") == "black quartz")
    }

    @Test func emptyString() {
        let style = IdentityFormatStyle<String>()
        #expect(style.format("") == "")
    }

    @Test func emoji() {
        let style = FirstWordFormatStyle()
        #expect(style.format("✴️⚛️✳️") == "✴️⚛️✳️")
        #expect(style.format("✴️") == "✴️")
    }

}
