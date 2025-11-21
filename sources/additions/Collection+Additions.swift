//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import Foundation


extension Collection {


    // TODO: function to clamp an index or indexDistance to a valid index


    public func index(offsetBy offset: IndexDistance) -> Index {
        index(startIndex, offsetBy: offset)
    }


    public func distanceFromStart(to index: Index) -> IndexDistance {
        distance(from: startIndex, to: index)
    }


}
