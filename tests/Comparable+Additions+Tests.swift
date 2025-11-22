//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct ComparableAdditionTests {


    func castedClamp<T: Comparable>(_ value: T, to closedRange: ClosedRange<T>) -> T {
        value.clamped(to: closedRange)
    }


    @Test func clamp() async throws {
        #expect(castedClamp(1, to: 4...6) == 4)
        #expect(castedClamp(4, to: 4...6) == 4)
        #expect(castedClamp(5, to: 4...6) == 5)
        #expect(castedClamp(6, to: 4...6) == 6)
        #expect(castedClamp(9, to: 4...6) == 6)

        #expect(castedClamp(3, to: 5...5) == 5)
        #expect(castedClamp(5, to: 5...5) == 5)
        #expect(castedClamp(7, to: 5...5) == 5)

        // Fatal error: Range requires lowerBound <= upperBound
        // #expect(castedClamp(5, to: 7...3) == 5)
    }

}


