//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


#if canImport(UIKit)


import UIKit


extension UIEdgeInsets {

    @inlinable nonisolated
    init(all value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }


    @inlinable nonisolated
    static func all(_ value: CGFloat) -> Self {
        .init(top: value, left: value, bottom: value, right: value)
    }

}


#endif
