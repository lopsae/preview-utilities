//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension EdgeInsets {


    @inlinable
    public init(all value: CGFloat) {
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }


    @inlinable
    public init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(
            top:      vertical,
            leading:  horizontal,
            bottom:   vertical,
            trailing: horizontal)
    }


    @inlinable
    public static func all(_ value: CGFloat) -> Self {
        .init(top: value, leading: value, bottom: value, trailing: value)
    }


    @inlinable
    public static func horizontal(_ value: CGFloat) -> Self {
        .init(
            top:      .zero,
            leading:  value,
            bottom:   .zero,
            trailing: value)
    }


    @inlinable
    public static func vertical(_ value: CGFloat) -> Self {
        .init(
            top:      value,
            leading:  .zero,
            bottom:   value,
            trailing: .zero)
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
