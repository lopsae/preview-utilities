//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


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
