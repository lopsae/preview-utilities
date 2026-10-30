//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI

import GeometryAdditions


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

    /// Creates a path containing a rectangle.
    @inlinable nonisolated
    public init(rect: CGRect) {
        self.init(rect)
    }


    /// Creates a path containing a crosshair at the given point.
    ///
    /// The crosshair total size is a square of `length * 2`.
    ///
    /// - Parameters:
    ///   - point: The center of the crosshair.
    ///   - length: The length of each crosshair arm.
    nonisolated
    public init(crosshair point: CGPoint, length: CGFloat = 4) {
        self.init()
        let hSegment = point.adding(x: -length).segmentToOffset(x: length*2)
        let vSegment = point.adding(y: -length).segmentToOffset(y: length*2)
        hSegment.add(to: &self)
        vSegment.add(to: &self)
    }

}
