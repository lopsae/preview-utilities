//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension GeometryProxy {

    var backport: Backport<Self> { .init(self) }

}


extension Backport where Content == GeometryProxy {

    var concentricCornerRadii: BackportProperty<RectangleCornerRadii?> {
        if #available(anyAppleOS 27.0, *) {
            return .available(content.concentricCornerRadii)
        } else {
            return .unavailable
        }
    }

}
