//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import Testing


struct FirstCharacterFormatStyleTests {

    @Test func extensions() {
        #expect("black quartz".formatted(.firstCharacter) == "b")
        #expect("black quartz".formatted(.firstCharacter.capitalized) == "B")
        #expect("black quartz".formatted(.firstCharacter(of: .lastWord)) == "q")
        #expect("black quartz".formatted(.firstCharacter(of: .lastWord, capitalize: true)) == "Q")
    }

    @Test func firstCharacter() {
        let style = FirstCharacterFormatStyle()
        #expect(style.format("black quartz") == "b")
    }

    @Test func firstCharacterCapitalized() {
        let style = FirstCharacterFormatStyle(capitalize: true)
        #expect(style.format("black quartz") == "B")
    }

    @Test func emptyString() {
        let style = FirstCharacterFormatStyle()
        #expect(style.format("") == "")
    }

    @Test func capitalizedModifier() {
        let style = FirstCharacterFormatStyle().capitalized
        #expect(style.format("black quartz") == "B")
    }

    @Test func capitalizedBoolModifier() {
        let enabled = FirstCharacterFormatStyle().capitalized(true)
        #expect(enabled.format("black quartz") == "B")

        let disabled = FirstCharacterFormatStyle().capitalized(false)
        #expect(disabled.format("black quartz") == "b")
    }

    @Test func singleCharacter() {
        let style = FirstCharacterFormatStyle()
        #expect(style.format("a") == "a")
        #expect(style.format("A") == "A")
        #expect(style.format("7") == "7")
        #expect(style.format("✴️") == "✴️")
    }

    @Test func alreadyUppercase() {
        let style = FirstCharacterFormatStyle(capitalize: true)
        #expect(style.format("B") == "B")
    }

    @Test func composite() {
        #expect("black quartz".formatted(.firstCharacter(of: .firstWord)) == "b")
        #expect("black quartz".formatted(.firstCharacter(of: .lastWord)) == "q")
    }

    @Test func compositeCapitalized() {
        #expect("black quartz".formatted(.firstCharacter(of: .firstWord, capitalize: true)) == "B")
        #expect("black quartz".formatted(.firstCharacter(of: .lastWord, capitalize: true)) == "Q")
    }

    @Test func nonLetters() {
        let style = FirstCharacterFormatStyle()
        #expect(style.format("123 456") == "1")
        #expect(style.format("✴️⚛️✳️") == "✴️")
        #expect(style.format("✴️⚛️") == "✴️")
    }

    @Test func nonLettersCapitalized() {
        let style = FirstCharacterFormatStyle(capitalize: true)
        #expect(style.format("123") == "1")
        #expect(style.format("🔡✴️") == "🔡")
        #expect(style.format("🔠✴️") == "🔠")
        #expect(style.format("⚛️✴️") == "⚛️")
    }

}
