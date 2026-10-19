//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


extension Path {

    @inlinable nonisolated
    mutating func moveTo(x: CGFloat, y: CGFloat) {
        self.move(to: .init(x: x, y: y))
    }

    @inlinable nonisolated
    mutating func addLineTo(x: CGFloat, y: CGFloat) {
        self.addLine(to: .init(x: x, y: y))
    }

}


extension Path {

    init(rect: CGRect) {
        self.init()
        addRect(rect)
    }


    init(crosshair point: CGPoint, length: CGFloat = 4) {
        self.init()
        // FIXME: Use segment pathable when exposed.
        let hSegment = point.offset(x: -length).segmentToOffset(x: length*2)
        move(to: hSegment.start)
        addLine(to: hSegment.end)
        let vSegment = point.offset(y: -length).segmentToOffset(y: length*2)
        move(to: vSegment.start)
        addLine(to: vSegment.end)
    }

}
