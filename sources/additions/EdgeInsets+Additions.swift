//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension EdgeInsets {

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
