//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Shape with a horizontal line drawn in the middle of its bounds.
struct HorizontalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.moveTo(x: .zero, y: rect.height/2)
        path.addLineTo(x: rect.width, y: rect.height/2)
        return path
    }
}


/// Shape with a vertical line drawn in the middle of its bounds.
struct VerticalLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.moveTo(x: rect.width/2, y: .zero)
        path.addLineTo(x: rect.width/2, y: rect.height)
        return path
    }
}
