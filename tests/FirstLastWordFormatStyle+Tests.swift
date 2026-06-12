//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct FirstWordFormatStyleTests {

    @Test func multipleWords() {
        let style = FirstWordFormatStyle()
        #expect(style.format("black quartz") == "black")
        #expect(style.format("one two three") == "one")
    }

    @Test func singleWord() {
        let style = FirstWordFormatStyle()
        #expect(style.format("hello") == "hello")
    }

    @Test func emptyString() {
        let style = FirstWordFormatStyle()
        #expect(style.format("") == "")
        #expect(style.format(" ") == "")
        #expect(style.format("   ") == "")
        #expect(style.format(" \t\n ") == "")
    }

    @Test func leadingWhitespace() {
        let style = FirstWordFormatStyle()
        #expect(style.format(" leading") == "leading")
        #expect(style.format("   leading") == "leading")
        #expect(style.format(" \t leading") == "leading")
        #expect(style.format("  two words") == "two")
    }

    @Test func multipleWhitespaceTypes() {
        let style = FirstWordFormatStyle()
        #expect(style.format("tab\there") == "tab")
        #expect(style.format("newline\nhere") == "newline")
    }

}


struct LastWordFormatStyleTests {

    @Test func multipleWords() {
        let style = LastWordFormatStyle()
        #expect(style.format("black quartz") == "quartz")
        #expect(style.format("one two three") == "three")
    }

    @Test func singleWord() {
        let style = LastWordFormatStyle()
        #expect(style.format("hello") == "hello")
    }

    @Test func emptyString() {
        let style = FirstWordFormatStyle()
        #expect(style.format("") == "")
        #expect(style.format(" ") == "")
        #expect(style.format("   ") == "")
        #expect(style.format(" \t\n ") == "")
    }

    @Test func trailingWhitespace() {
        let style = LastWordFormatStyle()
        #expect(style.format("trailing ") == "trailing")
        #expect(style.format("trailing   ") == "trailing")
        #expect(style.format("trailing \t ") == "trailing")
        #expect(style.format("two words  ") == "words")
    }

    @Test func multipleWhitespaceTypes() {
        let style = LastWordFormatStyle()
        #expect(style.format("tab\there") == "here")
        #expect(style.format("newline\nhere") == "here")
    }

}
