//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


extension Collection {

    public func index(offsetBy offset: Int) -> Index {
        index(startIndex, offsetBy: offset)
    }


    public func distance(fromStartTo index: Index) -> Int {
        distance(from: startIndex, to: index)
    }


    public func clampDistance(_ distance: Int) -> Int? {
        let totalDistance = self.distance(fromStartTo: endIndex)
        let clampedDistance = distance.clamped(to: 0..<totalDistance)
        return clampedDistance
    }

}

