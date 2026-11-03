//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import PreviewUtilities

import CoreFoundation
import GeometryAdditions
import Testing


struct CGPointGeometryTests {

    @Test func segmentToPoint() {
        let point: CGPoint = [5, 7]
        var segment: Segment

        segment = point.segmentTo(point: .zero)
        #expect(segment.start == [5, 7])
        #expect(segment.end   == .zero)

        segment = point.segmentTo(point: [6, 9])
        #expect(segment.start == [5, 7])
        #expect(segment.end   == [6, 9])
    }


    @Test func segmentToOffset() {
        let point: CGPoint = [5, 7]
        var segment: Segment

        segment = point.segmentToOffset()
        #expect(segment.start == [5, 7])
        #expect(segment.end   == [5, 7])

        segment = point.segmentToOffset(x: 6)
        #expect(segment.start == [5, 7])
        #expect(segment.end   == [11, 7])

        segment = point.segmentToOffset(y: 9)
        #expect(segment.start == [5, 7])
        #expect(segment.end   == [5, 16])

        segment = point.segmentToOffset(x: 6, y: 9)
        #expect(segment.start == [5, 7])
        #expect(segment.end   == [11, 16])
    }

}
