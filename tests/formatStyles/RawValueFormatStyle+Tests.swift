//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import Testing


struct RawValueFormatStyleTests {

    enum Gem: String, FormatStyleFormattable { case ruby, pearl, amethyst }

    @Test func extensions() {
        #expect(Gem.ruby.formatted(.rawValue()) == "ruby")
        #expect(Gem.ruby.formatted(.rawValueCapitalized()) == "Ruby")
    }

    @Test func rawValue() {
        let style = RawValueFormatStyle<Gem>()
        #expect(style.format(.ruby) == "ruby")
        #expect(style.format(.pearl) == "pearl")
        #expect(style.format(.amethyst) == "amethyst")
    }

}
