//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct StridableAdditionTests {

    @Test func clamp() async throws {
        #expect(1.clamped(to: 4..<7) == 4)
        #expect(4.clamped(to: 4..<7) == 4)
        #expect(5.clamped(to: 4..<7) == 5)
        #expect(6.clamped(to: 4..<7) == 6)
        #expect(7.clamped(to: 4..<7) == 6)
        #expect(9.clamped(to: 4..<7) == 6)

        // With empty range
        #expect(3.clamped(to: 5..<5) == nil)
        #expect(5.clamped(to: 5..<5) == nil)
        #expect(7.clamped(to: 5..<5) == nil)

        // Fatal error: Range requires lowerBound <= upperBound
        // #expect(5.clamped(to: 7..<3) == 5)
    }

}


