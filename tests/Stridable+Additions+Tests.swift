//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct SttridableAdditionTests {


    func castedClamp<T: Strideable>(_ value: T, to range: Range<T>) -> T?
    where T.Stride == Int {
        value.clamped(to: range)
    }


    @Test func clamp() async throws {
        #expect(castedClamp(1, to: 4..<7) == 4)
        #expect(castedClamp(4, to: 4..<7) == 4)
        #expect(castedClamp(5, to: 4..<7) == 5)
        #expect(castedClamp(6, to: 4..<7) == 6)
        #expect(castedClamp(7, to: 4..<7) == 6)
        #expect(castedClamp(9, to: 4..<7) == 6)

        // With empty range
        #expect(castedClamp(3, to: 5..<5) == nil)
        #expect(castedClamp(5, to: 5..<5) == nil)
        #expect(castedClamp(7, to: 5..<5) == nil)

        // Fatal error: Range requires lowerBound <= upperBound
        // #expect(castedClamp(5, to: 7..<3) == 5)
    }

}


