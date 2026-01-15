//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


nonisolated
enum Defaults {

    static let padding: CGFloat = 16

}


#Preview("Paddings") {
    Rectangle()
    .fill(.cyan.gradient.secondary)
    .frame(square: 200)
    .overlay {
        GeometryReader { outerGeometry in
            Rectangle()
            .fill(.brown.gradient.tertiary)
            .overlay {
                GeometryReader { innerGeometry in
                    let horizontalPadding = (outerGeometry.size.width - innerGeometry.size.width) / 2
                    let verticalPadding = (outerGeometry.size.height - innerGeometry.size.height) / 2
                    ClearRectangle()
                    .floatingCaption(
                        "Vertical: `\(verticalPadding, format: .fractionLength(2))`",
                        .alignment(.innerTop))
                    .floatingCaption(
                        "Horizontal:\n`\(horizontalPadding, format: .fractionLength(2))`",
                        .alignment(.innerTrailing))
                }
            }
            .padding()
        }
    }
}
