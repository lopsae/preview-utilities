//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct ComparableAdditionTests {

    @Test func clampClosedRange() async throws {
        #expect(Int(1).clamped(to: 4...6) == 4)
        #expect(Int(4).clamped(to: 4...6) == 4)
        #expect(Int(5).clamped(to: 4...6) == 5)
        #expect(Int(6).clamped(to: 4...6) == 6)
        #expect(Int(9).clamped(to: 4...6) == 6)

        // Single value range.
        #expect(Int(3).clamped(to: 5...5) == 5)
        #expect(Int(5).clamped(to: 5...5) == 5)
        #expect(Int(7).clamped(to: 5...5) == 5)

        // Causes: Fatal error: Range requires lowerBound <= upperBound
        // #expect(Int(5).clamped(to: 7...3) == 5)
    }


    @Test func clampPartialRangeFrom() async throws {
        #expect(Int(2).clamped(to: 5...) == 5)
        #expect(Int(5).clamped(to: 5...) == 5)
        #expect(Int(7).clamped(to: 5...) == 7)
    }


    @Test func clampPartialRangeThrough() async throws {
        #expect(Int(2).clamped(to: ...5) == 2)
        #expect(Int(5).clamped(to: ...5) == 5)
        #expect(Int(7).clamped(to: ...5) == 5)
    }

}


