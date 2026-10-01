//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Conveniences views for Snapshot testing.
enum TestViews {

    /// A quinary gray 100x100 square.
    static func quinaryGraySquare(length: CGFloat = 100) -> some View {
        Rectangle()
        .fill(.gray.quinary)
        .frame(squareOf: length)
    }

    static func quinaryGrayRect(size: CGSize = [120, 20]) -> some View {
        Rectangle()
        .fill(.gray.quinary)
        .frame(size: size)
    }

}
