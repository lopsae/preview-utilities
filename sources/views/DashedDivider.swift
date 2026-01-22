//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


public struct DashedDivider: View {

    let lineWidth: CGFloat


    public init(lineWidth: CGFloat = 1) {
        self.lineWidth = lineWidth
    }


    struct HorizontalLine: Shape {
        let lineWidth: CGFloat
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.moveTo(x: .zero, y: lineWidth / 2)
            path.addLineTo(x: rect.width, y: lineWidth / 2)
            return path
        }
    }


    public var body: some View {
        let strokeStyle = StrokeStyle(
            lineWidth: lineWidth, lineCap: .round,
            dash: [lineWidth * 5, lineWidth * 6])
        HorizontalLine(lineWidth: lineWidth)
            .stroke(.tertiary, style: strokeStyle)
            .frame(height: lineWidth)
    }
}
