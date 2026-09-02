//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import CoreFoundation


extension CGPoint {

    nonisolated
    func segmentToOffset(x: CGFloat = .zero, y: CGFloat = .zero) -> Segment {
        .init(start: self, end: self.offset(x: x, y: y))
    }

}
