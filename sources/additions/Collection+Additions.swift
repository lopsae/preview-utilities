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

}

