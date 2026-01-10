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
                .times(by: outerRadius)
                .offset(by: center)

            // TODO: could be angle.cosSin
            let innerPoint = CGPoint(x: cos(innerAngle), y: sin(innerAngle))
                .times(by: innerRadius)
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


#Preview {
    @Previewable @State var points: Double = 10
    @Previewable @State var vertexRatio: Double = 0.8

    VStack {
        Slider("Points", value: $points, in: 1...20, valueFormat: .arithmeticRoundedInteger)
        Text("Points: \(points, format: .arithmeticRoundedInteger)")
            .font(.caption.monospaced())
        Slider(
            "Vertex Ratio", value: $vertexRatio, in: 0...1,
            currentValueFormat: .fractionLength(2), boundsValueFormat: .arithmeticRoundedInteger)
        Text("Vertex Ratio: \(vertexRatio, format: .fractionLength(2))")
            .font(.caption.monospaced())
    }.padding()

    StarShape(
        points: points.arithmeticRoundedInt,
        concaveVertexRatio: vertexRatio
    )
    .fill(.cyan.gradient)
}
