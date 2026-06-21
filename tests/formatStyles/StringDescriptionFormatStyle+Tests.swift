//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import Testing


struct StringDescriptionFormatStyleTests {

    @Test func extensions() {
        #expect("black quartz".formatted(.description()) == "black quartz")
        #expect(987.formatted(.description()) == "987")
        #expect(1.2345.formatted(.description()) == "1.2345")
    }

    @Test func describesString() {
        let style = StringDescriptionFormatStyle<String>()
        #expect(style.format("hello") == "hello")
    }

    @Test func describesInt() {
        let style = StringDescriptionFormatStyle<Int>()
        #expect(style.format(987) == "987")
    }

    @Test func describesDouble() {
        let style = StringDescriptionFormatStyle<Double>()
        #expect(style.format(5.7) == "5.7")
        #expect(style.format(1.2345) == "1.2345")
    }

    @Test func describesOptional() {
        let style = StringDescriptionFormatStyle<Int?>()
        #expect(style.format(nil) == "nil")
        #expect(style.format(42) == "Optional(42)")
    }

}
