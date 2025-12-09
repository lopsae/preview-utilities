//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension EdgeInsets {


    public init(all value: CGFloat) {
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }


    @inlinable public static func all(_ value: CGFloat) -> Self {
        .init(top: value, leading: value, bottom: value, trailing: value)
    }


    @inlinable public static func horizontal(_ value: CGFloat) -> Self {
        .init(top: 0.0, leading: value, bottom: 0.0, trailing: value)
    }


    @inlinable public static func vertical(_ value: CGFloat) -> Self {
        .init(top: value, leading: 0.0, bottom: value, trailing: 0.0)
    }


    subscript(edge edge: Edge) -> CGFloat {
        switch edge {
        case .top:      top
        case .leading:  leading
        case .bottom:   bottom
        case .trailing: trailing
        @unknown default: fatalError()
        }
    }

}
