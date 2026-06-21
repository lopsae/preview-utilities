//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import Testing


struct CompositeFormatStyleTests {

    @Test func extensions() {
        #expect("black quartz".formatted(.composite(input: .firstWord, output: .capitalize)) == "Black")
        #expect("black quartz".formatted(.composite(input: .lastWord, output: .capitalize)) == "Quartz")
    }

    @Test func lastWordCapitalized() {
        let style = CompositeFormatStyle(
            input: LastWordFormatStyle(),
            output: CapitalizeFormatStyle()
        )
        #expect(style.format("black quartz") == "Quartz")
    }

    @Test func identityCapitalized() {
        let style = CompositeFormatStyle(
            input: IdentityFormatStyle<String>(),
            output: CapitalizeFormatStyle()
        )
        #expect(style.format("black quartz") == "Black Quartz")
    }

    @Test func lastWordFirstCharacter() {
        let style = CompositeFormatStyle(
            input: LastWordFormatStyle(),
            output: FirstCharacterFormatStyle()
        )
        #expect(style.format("black quartz") == "q")
    }

}
