//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Conveniences views for Snapshot testing.
enum TestViews {

    /// A quinary gray 100x100 square.
    static let quinaryGraySquare: some View = Rectangle()
        .fill(.gray.quinary)
        .frame(squareOf: 100)

}
