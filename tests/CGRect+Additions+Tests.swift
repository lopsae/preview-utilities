//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import CoreGraphics
import Testing


struct CGRectAdditionsTests {

    @Test func center() async throws {
        let rect: CGRect = .init(origin: [5, 7], size: [200, 100])
        let centered = rect.center(size: [60, 40])
        #expect(centered == .init(origin: [75, 37], size: [60, 40]))
    }


    @Test func align() async throws {
        let rect: CGRect = .init(origin: [5, 7], size: [90, 80])
        let toAlign: CGRect = .init(origin: [30, 20], size: [60, 40])

        #expect(rect.align(rect: toAlign, to: .top)      == .init(origin: [30,  7], size: [60, 40]))
        #expect(rect.align(rect: toAlign, to: .leading)  == .init(origin: [5,  20], size: [60, 40]))
        #expect(rect.align(rect: toAlign, to: .bottom)   == .init(origin: [30, 47], size: [60, 40]))
        #expect(rect.align(rect: toAlign, to: .trailing) == .init(origin: [35, 20], size: [60, 40]))
    }

}
