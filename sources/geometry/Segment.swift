//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


nonisolated
protocol Pathable {
    var path: Path { get }
}


nonisolated
extension Pathable {

    @discardableResult
    func add(to container: inout Path) -> Self {
        container.addPath(path)
        return self
    }
}


// TODO: Add Pathable, and make drawing in a context a chained command.
nonisolated
struct Segment {
    var start: CGPoint
    var end: CGPoint
}


nonisolated
extension Segment: Pathable {
    var path: Path {
        .init { path in
            path.move(to: start)
            path.addLine(to: end)
        }
    }
}
