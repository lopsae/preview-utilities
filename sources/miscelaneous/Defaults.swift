//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Container of default values.
nonisolated
public enum Defaults {

    /// Default padding applied with the `.padding()` modifier.
    public static let padding: CGFloat = 16

}


#Preview("Paddings") {
    Rectangle()
    .fill(.cyan.gradient.secondary)
    .frame(squareOf: 200)
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
                        .alignment(.top))
                    .floatingCaption(
                        "Horizontal:\n`\(horizontalPadding, format: .fractionLength(2))`",
                        .alignment(.trailing))
                }
            }
            .padding()
        }
    }
}
