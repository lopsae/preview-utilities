//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


extension String {

    public static let alphabet: [String] = [
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
        "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"
    ]


    public static let natoPhoneticAlphabet: [String] = [
        "alfa", "bravo", "charlie", "delta", "echo", "foxtrot", "golf", "hotel", "india",
        "juliett", "kilo", "lima", "mike", "november", "oscar", "papa", "quebec", "romeo",
        "sierra", "tango", "uniform", "victor", "whiskey", "x-ray", "yankee", "zulu"
    ]


    public static let sphinxOfBlackQuartz: String = "sphinx of black quartz, judge my vow"


    /// Returns a _Lorem ipsum_ string as found in its [wikipedia article][lorem-ipsum].
    ///
    /// Contains 69 words.
    ///
    /// [lorem-ipsum]: https://en.wikipedia.org/wiki/Lorem_ipsum
    public static let loremIpsum: String =
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt "
        + "ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation "
        + "ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in "
        + "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur "
        + "sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id "
        + "est laborum."

}

