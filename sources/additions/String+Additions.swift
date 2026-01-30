//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


extension String {

    // TODO: remove deprecations after other projects update, before release.
    @available(*, deprecated, renamed: "Strings.alphabet")
    public static let alphabet: [String] = Strings.alphabet


    @available(*, deprecated, renamed: "Strings.natoPhoneticAlphabet")
    public static let natoPhoneticAlphabet: [String] = Strings.natoPhoneticAlphabet


    @available(*, deprecated, renamed: "Strings.sphinxOfBlackQuartz")
    public static let sphinxOfBlackQuartz: String = Strings.sphinxOfBlackQuartz


    @available(*, deprecated, renamed: "Strings.loremIpsum")
    public static let loremIpsum: String = Strings.loremIpsum

}


/// Container of convenience strings and utilities.
nonisolated
public enum Strings {

    nonisolated
    public static let alphabet: [String] = [
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
        "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
    ]


    nonisolated
    public static let natoPhoneticAlphabet: [String] = [
        "alfa", "bravo", "charlie", "delta", "echo", "foxtrot", "golf", "hotel", "india",
        "juliett", "kilo", "lima", "mike", "november", "oscar", "papa", "quebec", "romeo",
        "sierra", "tango", "uniform", "victor", "whiskey", "x-ray", "yankee", "zulu"
    ]


    nonisolated
    public static let sphinxOfBlackQuartz: String = "sphinx of black quartz, judge my vow"

    /// Returns a _Lorem ipsum_ string as found in its [wikipedia article][lorem-ipsum].
    ///
    /// Contains 69 words.
    ///
    /// [lorem-ipsum]: https://en.wikipedia.org/wiki/Lorem_ipsum
    nonisolated
    public static let loremIpsum: String =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt "
        + "ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation "
        + "ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in "
        + "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur "
        + "sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id "
        + "est laborum."


    nonisolated
    public static let loremIpsumWords = Strings.loremIpsum.split(separator: .whitespace)


    nonisolated
    public static func loremIpsum(words: Int) -> String {
        // TODO: could this be done by joining together whole loremIpsum words, and then appending a range?
        guard words > 0 else { return "" }
        guard !loremIpsumWords.isEmpty else { fatalError() }
        
        var result: [Substring] = []
        result.reserveCapacity(words)
        
        for index in 0..<words {
            let wordIndex = index % loremIpsumWords.count
            result.append(loremIpsumWords[wordIndex])
        }
        
        return result.joined(separator: " ")
    }

}

