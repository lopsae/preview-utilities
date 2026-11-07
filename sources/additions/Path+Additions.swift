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

    nonisolated
    mutating func addPath(_ pathable: some Pathable) {
        addPath(pathable.path)
    }

}


extension Path {

    /// Creates a path containing a rectangle.
    @inlinable nonisolated
    public init(rect: CGRect) {
        self.init(rect)
    }

}
