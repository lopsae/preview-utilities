//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension Image {

    #if canImport(AppKit)
    public typealias PlatformImage = NSImage
    #elseif canImport(UIKit)
    public typealias PlatformImage = UIImage
    #endif

    nonisolated
    init(platformImage: PlatformImage) {
        #if canImport(AppKit)
        self.init(nsImage: platformImage)
        #elseif canImport(UIKit)
        self.init(uiImage: platformImage)
        #endif
    }

}
