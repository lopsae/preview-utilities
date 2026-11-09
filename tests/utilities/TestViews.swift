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


extension TestViews {

    // FIXME: Add snapshot test to TestViews+Snapshots.

    /// Rectangle with a graticule drawn around.
    ///
    /// Utility view to setup Paths based on a frame size. The content closure receives spacing
    /// value for the graticule, and the rectangle.
    struct GraticuleRect<Content>: View where Content: View {
        @ViewBuilder var content: (_ graticuleSpacing: CGFloat, _ frame: CGRect) -> Content
        var body: some View {
            let heightSpacing: CGFloat = 8
            let frameSize: CGSize = [120, heightSpacing*3]
            ZStack {
                content(heightSpacing, frameSize.rect())
            }
            .frame(size: frameSize)
            .background(.gray.quinary)
            .edgeGraticule(spacing: 8)
        }
    }

}
