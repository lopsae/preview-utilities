//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


#if canImport(AppKit)


import AppKit


// TODO: added as counterpart of UIEdgeInset, but has not been used. Double check the same idioms apply.
extension NSEdgeInsets {

    init(all value: CGFloat) {
        self.init(top: value, left: value, bottom: value, right: value)
    }


    @inlinable static func all(_ value: CGFloat) -> Self {
        .init(top: value, left: value, bottom: value, right: value)
    }

}


#endif
