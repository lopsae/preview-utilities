//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Convenience view that contains a invisible rectangle with the given size.
public struct ClearRectangle<S: ShapeStyle> : View {

    let width: CGFloat?
    let height: CGFloat?
    let fill: S


    public init(width: CGFloat? = nil, height: CGFloat? = nil)
    where S == Color
    {
        self.width = width
        self.height = height
        self.fill = .clear
    }


    public init(width: CGFloat? = nil, height: CGFloat? = nil, fill: S) {
        self.width = width
        self.height = height
        self.fill = fill
    }


    public init(size: CGSize)
    where S == Color
    {
        self.init(width: size.width, height: size.height)
    }


    public init(size: CGSize, fill: S) {
        self.init(width: size.width, height: size.height, fill: fill)
    }


    public var body: some View {
        Rectangle()
            .fill(fill)
            .frame(width: width, height: height)
    }

}


// MARK: - Previews.

#Preview(traits: .fixedHeader) {
    ClearRectangle(size: .square(of: 50.0), fill: Color.red.opacity(0.3))

    ClearRectangle(size: .square(of: 100.0))
        .debugOutline()

    ClearRectangle(width: 200, fill: .blue.opacity(0.3))
}
