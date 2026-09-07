//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension GraphicsContext {

    func draw(
        runs: [Text.Layout.Run],
        options: Text.Layout.DrawingOptions = .init()
    ) {
        for run in runs {
            draw(run, options: options)
        }
    }

}
