//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import Testing


struct RemoveSpacesFormatStyleTests {

    nonisolated struct Sample: Equatable, FormatStyleFormattable {
        let label = "judge my vow"
    }

    @Test func extensionRemoveSpaces() {
        #expect("black quartz".formatted(.removeSpaces) == "blackquartz")
    }

    @Test func extensionRemovingSpaces() {
        #expect("black quartz".formatted(.capitalize.removingSpaces) == "BlackQuartz")
        #expect(Sample().formatted(.property(\.label).removingSpaces) == "judgemyvow")
    }

    @Test func middleSpaces() {
        let style = RemoveSpacesFormatStyle()
        #expect(style.format("judge my vow")     == "judgemyvow")
        #expect(style.format("judge   my   vow") == "judgemyvow")

    }

    @Test func edgeSpaces() {
        let style = RemoveSpacesFormatStyle()
        #expect(style.format("   judge my vow")    == "judgemyvow")
        #expect(style.format("judge my vow   ")    == "judgemyvow")
        #expect(style.format("   judge my vow   ") == "judgemyvow")
    }

    @Test func emptyString() {
        let style = RemoveSpacesFormatStyle()
        #expect(style.format(.empty) == "")
    }

    @Test func singleWord() {
        let style = RemoveSpacesFormatStyle()
        #expect(style.format("quartz") == "quartz")
    }

    @Test func newLines() {
        let style = RemoveSpacesFormatStyle()
        #expect(style.format("judge\nmy\nvow")   == "judge\nmy\nvow")
        #expect(style.format("judge my\nvow")    == "judgemy\nvow")
        #expect(style.format("\njudge my vow\n") == "\njudgemyvow\n")
    }

    @Test func otherWhitespace() {
        let style = RemoveSpacesFormatStyle()
        let string: String = "A\(String.nbsp)B\(String.narrowNbsp)C\(String.tab)D"
        #expect(style.format(string) == "ABCD")
    }

    @Test func mixedWhitespace() {
        let style = RemoveSpacesFormatStyle()
        let string: String = "A B   C\(String.nbsp)D\(String.narrowNbsp)E\(String.tab)F"
        #expect(style.format(string) == "ABCDEF")
    }

    @Test func nonLetters() {
        let style = RemoveSpacesFormatStyle()
        #expect(style.format("123 456 789") == "123456789")
        #expect(style.format("🔡 🔠 ✴️") == "🔡🔠✴️")
    }

}
