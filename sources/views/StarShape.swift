//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct StarShape: Shape {

    let points: Int

    /// Determines the distance of the concave vertices, from the star's edge to the star's center.
    let concaveVertexRatio: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = rect.center
        let outerRadius = rect.size.min / 2
        let innerRadius = outerRadius * concaveVertexRatio

        // TODO: figure out angle operations using Angle?
        let angleStep = .pi * 2 / points.asDouble
        let halfAngleStep = angleStep / 2

        for index in 0 ..< points {
            // First point points upwards.
            let outerAngle = CGFloat(index) * angleStep - .pi / 2
            let innerAngle = outerAngle + halfAngleStep

            // TODO: could be angle.cosSin
            let outerPoint = CGPoint(x: cos(outerAngle), y: sin(outerAngle))
                .multiplying(by: outerRadius)
                .offset(by: center)

            // TODO: could be angle.cosSin
            let innerPoint = CGPoint(x: cos(innerAngle), y: sin(innerAngle))
                .multiplying(by: innerRadius)
                .offset(by: center)

            if index == .zero {
                path.move(to: outerPoint)
            } else {
                path.addLine(to: outerPoint)
            }
            path.addLine(to: innerPoint)
        }
        path.closeSubpath()

        return path
    }
}


// MARK: Previews


#Preview(traits: .iPhoneProSizeLayout) {
    @Previewable @State var points: Double = 10
    @Previewable @State var vertexRatio: Double = 0.8

    VStack {
        Slider.captioned(
            "Points", value: $points, in: 1...20,
            valueFormat: .arithmeticRoundedInteger)
        Slider.captioned(
            "Vertex Ratio", value: $vertexRatio, in: 0...1,
            currentValueFormat: .fractionLength(2),
            boundsValueFormat: .arithmeticRoundedInteger)
    }.padding()

    StarShape(
        points: points.arithmeticRoundedInt,
        concaveVertexRatio: vertexRatio
    )
    .fill(.cyan.gradient)
}
