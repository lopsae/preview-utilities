//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


extension GraphicsContext {

    public func draw(
        runs: [Text.Layout.Run],
        options: Text.Layout.DrawingOptions = .init()
    ) {
        for run in runs {
            draw(run, options: options)
        }
    }

}
