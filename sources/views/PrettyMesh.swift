//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension MeshGradient {

    static var summerDawnSplit: Self {
        MeshGradient(
            width: 3, height: 4,
            points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.0, 0.3], [0.8, 0.4], [1.0, 0.3],
                [0.0, 0.7], [0.2, 0.6], [1.0, 0.7],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0],
            ],
            colors: [
                .red, .red, .indigo,
                .yellow, .red, .indigo,
                .yellow, .red, .indigo,
                .yellow, .red, .red,
            ]
        )
    }


    static var wallOfIceAndFire: Self {
        MeshGradient(
            width: 4, height: 3,
            points: [
                [0.0, 0.0], [0.3, 0.0], [0.7, 0.0], [1.0, 0.0],
                [0.0, 0.5], [0.4, 0.8], [0.6, 0.2], [1.0, 0.5],
                [0.0, 1.0], [0.3, 1.0], [0.7, 1.0], [1.0, 1.0]
            ],
            colors: [
                .orange, .orange, .yellow, .yellow,
                .red, .red, .red, .red,
                .blue, .blue, .blue, .blue
            ]
        )
    }


    static var auroraEgg: Self {
        MeshGradient(
            width: 4, height: 3,
            points: [
                [0.0, 0.0], [0.3, 0.0], [0.6, 0.0], [1.0, 0.0],
                [0.0, 0.5], [0.2, 0.8], [0.8, 0.2], [1.0, 0.5],
                [0.0, 1.0], [0.3, 1.0], [0.7, 1.0], [1.0, 1.0]
            ],
            colors: [
                .indigo, .purple, .indigo, .indigo,
                .blue, .indigo, .teal, .blue,
                .teal, .teal, .green, .teal
            ]
        )
    }


    // TODO: generated, clean up, experiment and consider keeping.
    static var moltenHorizon: Self {
        MeshGradient(
            width: 4, height: 4,
            points: [
                [0.0, 0.0],  [0.35, 0.0], [0.65, 0.0], [1.0, 0.0],
                [0.0, 0.35], [0.4, 0.3],  [0.6, 0.3],  [1.0, 0.35],
                [0.0, 0.65], [0.4, 0.7],  [0.6, 0.7],  [1.0, 0.65],
                [0.0, 1.0],  [0.35, 1.0], [0.65, 1.0], [1.0, 1.0]
            ],
            colors: [
                .orange, .yellow, .yellow, .orange,
                .red,    .orange, .orange, .red,
                .red,    .orange, .orange, .red,
                .orange, .yellow, .yellow, .orange,
            ]
        )
    }


    // TODO: generated, clean up, experiment and consider keeping.
    static var emberRibbon: Self {
        MeshGradient(
            width: 3, height: 4,
            points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.0, 0.3], [0.6, 0.4], [1.0, 0.3],
                [0.0, 0.7], [0.4, 0.6], [1.0, 0.7],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0],
            ],
            colors: [
                .yellow, .orange, .pink,
                .orange, .red,    .orange,
                .pink,   .red,    .orange,
                .red,    .orange, .yellow,
            ]
        )
    }


    // TODO: generated, clean up, experiment and consider keeping.
    static var frozenDepth: Self {
        MeshGradient(
            width: 4, height: 4,
            points: [
                [0.0, 0.0],  [0.35, 0.0], [0.65, 0.0], [1.0, 0.0],
                [0.0, 0.35], [0.4, 0.4],  [0.6, 0.4],  [1.0, 0.35],
                [0.0, 0.65], [0.4, 0.6],  [0.6, 0.6],  [1.0, 0.65],
                [0.0, 1.0],  [0.35, 1.0], [0.65, 1.0], [1.0, 1.0]
            ],
            colors: [
                .indigo, .blue, .blue, .indigo,
                .blue,   .teal, .teal, .blue,
                .blue,   .teal, .teal, .blue,
                .indigo, .blue, .blue, .indigo,
            ]
        )
    }


    // TODO: generated, clean up, experiment and consider keeping.
    static var glacialVeil: Self {
        MeshGradient(
            width: 3, height: 4,
            points: [
                [0.0, 0.0], [0.5, 0.0], [1.0, 0.0],
                [0.0, 0.3], [0.4, 0.4], [1.0, 0.3],
                [0.0, 0.7], [0.6, 0.6], [1.0, 0.7],
                [0.0, 1.0], [0.5, 1.0], [1.0, 1.0],
            ],
            colors: [
                .purple, .indigo, .blue,
                .indigo, .cyan,   .indigo,
                .blue,   .cyan,   .indigo,
                .blue,   .indigo, .purple,
            ]
        )
    }


    // Just to explore color combinations.
    fileprivate static var linear: Self {
        MeshGradient(
            width: 2, height: 5,
            points: [
                [0.0, 0.00], [1.0, 0.00],
                [0.0, 0.25], [1.0, 0.25],
                [0.0, 0.50], [1.0, 0.50],
                [0.0, 0.75], [1.0, 0.75],
                [0.0, 1.00], [1.0, 1.00]
            ],
            colors: [
                .indigo, .indigo,
                .purple, .purple,
                .blue, .blue,
                .green, .green,
                .teal, .teal
            ]
        )
    }

}


// MARK: - MeshGradient Editor

/// An interactive editor that renders a `MeshGradient` and provides draggable handles
/// for each control point. Drag a handle to modify the mesh shape in real time.
///
/// The point coordinates are printed to the console after each drag.
private struct MeshGradientEditor: View {

    let meshWidth: Int
    let meshHeight: Int
    let colors: [Color]

    @State private var points: [SIMD2<Float>]

    init(mesh: MeshGradient) {
        meshWidth = mesh.width
        meshHeight = mesh.height

        if case .points(let pts) = mesh.locations {
            _points = State(initialValue: pts)
        } else {
            _points = State(initialValue: [])
        }

        if case .colors(let cols) = mesh.colors {
            colors = cols
        } else {
            colors = []
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                MeshGradient(
                    width: meshWidth,
                    height: meshHeight,
                    points: points,
                    colors: colors
                )

                gridLines(in: geometry.size)

                ForEach(points.indices, id: \.self) { index in
                    pointHandle(index: index, in: geometry.size)
                }
            }
        }
    }

    private func gridLines(in size: CGSize) -> some View {
        Canvas { context, _ in
            let lineStyle = StrokeStyle(lineWidth: 1, dash: [4, 3])

            for row in 0..<meshHeight {
                for col in 0..<meshWidth {
                    let index = row * meshWidth + col
                    let from = cgPoint(for: points[index], in: size)

                    // Horizontal line to the right neighbor.
                    if col < meshWidth - 1 {
                        let right = cgPoint(for: points[index + 1], in: size)
                        var path = Path()
                        path.move(to: from)
                        path.addLine(to: right)
                        context.stroke(path, with: .color(.white.opacity(0.5)), style: lineStyle)
                    }

                    // Vertical line to the bottom neighbor.
                    if row < meshHeight - 1 {
                        let below = cgPoint(for: points[index + meshWidth], in: size)
                        var path = Path()
                        path.move(to: from)
                        path.addLine(to: below)
                        context.stroke(path, with: .color(.white.opacity(0.5)), style: lineStyle)
                    }
                }
            }
        }
        .allowsHitTesting(false)
    }

    private func cgPoint(for point: SIMD2<Float>, in size: CGSize) -> CGPoint {
        CGPoint(x: CGFloat(point.x) * size.width, y: CGFloat(point.y) * size.height)
    }

    @ViewBuilder
    private func pointHandle(index: Int, in size: CGSize) -> some View {
        let point = points[index]
        let x = CGFloat(point.x) * size.width
        let y = CGFloat(point.y) * size.height
        let row = index / meshWidth
        let col = index % meshWidth

        Circle()
        .fill(.white.opacity(0.7))
        .overlay {
            Circle().stroke(.black.opacity(0.4), lineWidth: 1)
        }
        .overlay {
            Text("\(row),\(col)")
            .font(.caption)
            .foregroundStyle(.black)
        }
        .frame(squareOf: 28)
        .position(x: x, y: y)
        .gesture(
            DragGesture().onChanged { drag in
                let newX = Float(drag.location.x / size.width)
                let newY = Float(drag.location.y / size.height)
                points[index] = SIMD2(
                    min(max(newX, 0), 1),
                    min(max(newY, 0), 1)
                )
            }
            .onEnded { _ in
                printPoints()
            }
        )
    }

    private func printPoints() {
        var output = "points: [\n"
        for row in 0..<meshHeight {
            let rowStart = row * meshWidth
            let rowEnd = rowStart + meshWidth
            let rowPoints = points[rowStart..<rowEnd].map { point in
                String(format: "[%.2f, %.2f]", point.x, point.y)
            }
            output += "    " + rowPoints.joined(separator: ", ") + ",\n"
        }
        output += "]"
        print(output)
    }
}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Editor", traits: .fixedHeaderFooter, PreviewContent.layout) {
    MeshGradientEditor(mesh: .summerDawnSplit)
}


#Preview("SummerDawnSplit") {
    MeshGradient.summerDawnSplit
        .ignoresSafeArea()
}


#Preview("WallOfIceAndFire") {
    MeshGradient.wallOfIceAndFire
        .ignoresSafeArea()
}


#Preview("AuroraEgg") {
    MeshGradient.auroraEgg
        .ignoresSafeArea()
}


#Preview("MoltenHorizon") {
    MeshGradient.moltenHorizon
        .ignoresSafeArea()
}


#Preview("EmberRibbon") {
    MeshGradient.emberRibbon
        .ignoresSafeArea()
}


#Preview("FrozenDepth") {
    MeshGradient.frozenDepth
        .ignoresSafeArea()
}


#Preview("GlacialVeil") {
    MeshGradient.glacialVeil
        .ignoresSafeArea()
}


#Preview("Linear") {
    MeshGradient.linear
        .ignoresSafeArea()
}
