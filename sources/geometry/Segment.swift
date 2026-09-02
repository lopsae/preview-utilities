//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// TODO: Add Pathable, and make drawing in a context a chained command.
nonisolated
struct Segment {
    var start: CGPoint
    var end: CGPoint
    var path: Path {
        .init { path in
            path.move(to: start)
            path.addLine(to: end)
        }
    }
}
