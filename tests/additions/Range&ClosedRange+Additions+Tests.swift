//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


@testable import PreviewUtilities

import Testing


struct RangeAdditionsTests {

    @Test func strideBy() {
        #expect((Double.zero ..< .zero).stride(by: 0.5).toArray == [])
        #expect((Double.zero..<2.0).stride(by: 0.5).toArray == [0, 0.5, 1, 1.5])
    }

}


struct ClosedRangeAdditionsTests {

    @Test func strideBy() {
        #expect((Double.zero ... .zero).stride(by: 0.5).toArray == [.zero])
        #expect((Double.zero...2.0).stride(by: 0.5).toArray == [0, 0.5, 1, 1.5, 2])
    }

}
