//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Foundation
import Testing


struct URLAdditionTests {

    @Test func appendingPathComponents() async throws {
        let base = URL(filePath: "/tmp")

        #expect(base.appending(pathComponents: [String]()) == base)
        #expect(base.appending(pathComponents: ["one"]).path() == "/tmp/one")
        #expect(base.appending(pathComponents: ["one", "two", "three"]).path() == "/tmp/one/two/three")
    }


    @Test func appendingPathComponentsWithStringProtocol() async throws {
        let base = URL(filePath: "/tmp")

        let substrings = "one/two".split(separator: "/")
        #expect(base.appending(pathComponents: substrings).path() == "/tmp/one/two")
    }


    @Test func deletingPathComponents() async throws {
        let fileUrl = URL(filePath: "/one/two/three")
        #expect(fileUrl.deletingPathComponents(count: 0) == fileUrl)
        #expect(fileUrl.deletingPathComponents(count: 1).path() == "/one/two/")
        #expect(fileUrl.deletingPathComponents(count: 2).path() == "/one/")
        #expect(fileUrl.deletingPathComponents(count: 3).path() == "/")
        #expect(fileUrl.deletingPathComponents(count: 4).path() == "/")
        #expect(fileUrl.deletingPathComponents(count: 5).path() == "/")

        let webUrl = URL(string: "http://www.example.com/one/two")!
        #expect(webUrl.deletingPathComponents(count: 0) == webUrl)
        #expect(webUrl.deletingPathComponents(count: 1).absoluteString == "http://www.example.com/one/")
        #expect(webUrl.deletingPathComponents(count: 2).absoluteString == "http://www.example.com/")
        #expect(webUrl.deletingPathComponents(count: 3).absoluteString == "http://www.example.com/")
        #expect(webUrl.deletingPathComponents(count: 4).absoluteString == "http://www.example.com/")

        let noPathWebUrl = URL(string: "http://www.example.com")!
        #expect(noPathWebUrl.deletingPathComponents(count: 0) == noPathWebUrl)
        #expect(noPathWebUrl.deletingPathComponents(count: 1).absoluteString == "http://www.example.com")
        #expect(noPathWebUrl.deletingPathComponents(count: 2).absoluteString == "http://www.example.com")
    }

}
