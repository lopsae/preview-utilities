//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import Foundation
import Testing


struct PropertyFormatStyleTests {

    nonisolated struct Sample: Equatable, FormatStyleFormattable {
        let label = "agate"
    }

    @Test func extensions() {
        #expect(Sample().formatted(.property(\.label)) == "agate")
    }

    @Test func extractsProperty() {
        let style = PropertyFormatStyle<Sample>(\.label)
        #expect(style.format(Sample()) == "agate")
    }

    @Test func encodingSucceeds() throws {
        let style = PropertyFormatStyle<Sample>(\.label)
        let encoder = JSONEncoder()
        let data = try encoder.encode(style)
        let string = String(data: data, encoding: .utf8)
        #expect(string == "\"PropertyFormatStyle\"")
    }

    @Test func decodingThrows() throws {
        let json = Data("\"PropertyFormatStyle\"".utf8)
        let decoder = JSONDecoder()
        #expect(throws: DecodingError.self) {
            try decoder.decode(PropertyFormatStyle<Sample>.self, from: json)
        }
    }

}
