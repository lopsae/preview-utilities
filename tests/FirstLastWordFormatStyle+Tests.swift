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
    }

    @Test func leadingWhitespace() {
        let style = FirstWordFormatStyle()
        #expect(style.format(" leading") == "")
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
        let style = LastWordFormatStyle()
        #expect(style.format("") == "")
    }

    @Test func trailingWhitespace() {
        let style = LastWordFormatStyle()
        #expect(style.format("trailing ") == "")
    }

    @Test func multipleWhitespaceTypes() {
        let style = LastWordFormatStyle()
        #expect(style.format("tab\there") == "here")
        #expect(style.format("newline\nhere") == "here")
    }

}
