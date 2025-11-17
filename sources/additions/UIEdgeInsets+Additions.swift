//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import UIKit


extension UIEdgeInsets {

    init(all value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }


    @inlinable static func all(_ value: CGFloat) -> Self {
        .init(top: value, left: value, bottom: value, right: value)
    }

}


extension CGRect {

    @inlinable func inset(by value: CGFloat) -> Self {
        inset(by: .all(value))
    }

}
