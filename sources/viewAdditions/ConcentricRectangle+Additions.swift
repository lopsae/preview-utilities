//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


extension ConcentricRectangle {

    public init(minimumConcentricRadius: Double) {
        self.init(corners: .concentric(minimum: .fixed(minimumConcentricRadius)), isUniform: false)
    }

}
