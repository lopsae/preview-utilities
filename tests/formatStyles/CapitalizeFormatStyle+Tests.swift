//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import Testing


struct CapitalizeFormatStyleTests {

    nonisolated struct Sample: Equatable, FormatStyleFormattable {
        let label = "agate"
    }

    @Test func extensions() {
        #expect("black quartz".formatted(.capitalize) == "Black Quartz")
        #expect("black quartz".formatted(.capitalize(.firstWord)) == "Black")
        #expect(Sample().formatted(.capitalize(property: \.label)) == "Agate")
    }

    @Test func words() {
        let style = CapitalizeFormatStyle()
        #expect(style.format("black quartz") == "Black Quartz")
    }

    @Test func emptyString() {
        let style = CapitalizeFormatStyle()
        #expect(style.format("") == "")
    }

    @Test func singleWord() {
        let style = CapitalizeFormatStyle()
        #expect(style.format("hello") == "Hello")
    }

    @Test func alreadyCapitalized() {
        let style = CapitalizeFormatStyle()
        #expect(style.format("Black Quartz") == "Black Quartz")
    }

    @Test func allUppercase() {
        let style = CapitalizeFormatStyle()
        #expect(style.format("BLACK QUARTZ") == "Black Quartz")
    }

    @Test func singleCharacter() {
        let style = CapitalizeFormatStyle()
        #expect(style.format("a") == "A")
    }

    @Test func nonLetters() {
        let style = CapitalizeFormatStyle()
        #expect(style.format("123") == "123")
        #expect(style.format("🔡") == "🔡")
        #expect(style.format("🔠") == "🔠")
        #expect(style.format("✴️") == "✴️")
    }

}
