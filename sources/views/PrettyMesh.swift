//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


enum PrettyMesh {

    static var summerDawnSplit: MeshGradient {
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


    static var wallOfIceAndFire: MeshGradient {
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


    static var auroraEgg: MeshGradient {
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


    static var moltenHorizon: MeshGradient {
        MeshGradient(
            width: 6, height: 5,
            points: [
                [0.00, 0.00], [0.10, 0.00], [0.19, 0.00], [0.50, 0.00], [0.69, 0.00], [1.00, 0.00],
                [0.00, 0.44], [0.18, 0.23], [0.30, 0.14], [0.47, 0.08], [0.61, 0.08], [1.00, 0.12],
                [0.00, 0.72], [0.46, 0.82], [0.50, 0.58], [0.50, 0.42], [0.54, 0.18], [1.00, 0.28],
                [0.00, 0.88], [0.39, 0.92], [0.53, 0.92], [0.70, 0.86], [0.82, 0.77], [1.00, 0.56],
                [0.00, 1.00], [0.31, 1.00], [0.50, 1.00], [0.81, 1.00], [0.90, 1.00], [1.00, 1.00],
            ],
            colors: [
                .red,    .red, .orange, .yellow, .red,    .red,
                .orange, .red,    .orange, .yellow, .red,    .orange,
                .orange, .red,    .orange, .orange, .red,    .orange,
                .orange, .red,    .yellow, .orange, .red,    .orange,
                .red,    .red,    .yellow, .orange, .red, .red
            ]
        )
    }


    // TODO: generated, clean up, experiment and consider keeping.
    static var emberRibbon: MeshGradient {
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
    static var frozenDepth: MeshGradient {
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
    static var glacialVeil: MeshGradient {
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


    // To explore color combinations.
    fileprivate static var experiment: MeshGradient {
        MeshGradient(
            width: 6, height: 5,
            points:
                [0.0, 0.25, 0.5, 0.75, 1.0]
                .flatMap { yPos in
                    [0.0, 0.1, 0.33, 0.66, 0.9, 1.0].map { xPos in
                        [xPos, yPos]
                    }
                },
            colors: [
                .red,    .orange, .yellow, .yellow, .orange, .red,
                .orange, .red,    .orange, .orange, .red, .orange,
                .orange, .red,    .orange, .orange, .red, .orange,
                .orange, .red,    .orange, .orange, .red, .orange,
                .red,    .orange, .yellow, .yellow, .orange, .red
            ]
        )
    }


    // To test the editor.
    fileprivate static var simple: MeshGradient {
        MeshGradient(
            width: 4, height: 4,
            points:
                [0.0, 0.33, 0.66, 1.0]
                .flatMap { yPos in
                    [0.0, 0.33, 0.66, 1.0].map { xPos in
                        [xPos, yPos]
                    }
                },
            colors: [
                .yellow,
                .orange,
                .red,
                .indigo,
            ].flatMap {
                Array(repeating: $0, count: 4)
            }
        )
    }

}


// MARK: - MeshGradient Editor

/// An interactive editor that renders a `MeshGradient` and provides draggable handles
/// for each control point. Drag a handle to modify the mesh shape in real time.
///
/// The point coordinates are printed to the console after each drag.
private struct MeshGradientEditor: View {

    @State var areHandlesVisible = true
    @State var areGridLinesVisible = true
    @State private var mirrorMode: MirrorMode = .none

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
        VStack {
            // Controls.
            HStack {
                Button("Handles", systemImage: areHandlesVisible ? "checkmark.circle.fill" : "circle.fill") {
                    areHandlesVisible.toggle()
                }

                Button("GridLines", systemImage: areGridLinesVisible ? "checkmark.circle.fill" : "circle.fill") {
                    areGridLinesVisible.toggle()
                }

                Button(mirrorMode.label, systemImage: mirrorMode.systemImage) {
                    mirrorMode = mirrorMode.next
                }
            }
            .buttonStyle(.bordered)
            .font(.caption)

            // Mesh Grid.
            GeometryReader { geometry in
                ZStack {
                    MeshGradient(
                        width: meshWidth,
                        height: meshHeight,
                        points: points,
                        colors: colors
                    )

                    gridLines(in: geometry.size)
                        .opacity(areGridLinesVisible ? 1 : 0)

                    ForEach(points.indices, id: \.self) { index in
                        pointHandle(index: index, in: geometry.size)
                    }
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

        Color.clear
        .overlay {
            if areHandlesVisible {
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
                .overlay(alignment: .bottom) {
                    let pointString = String(format: "%.2f\n%.2f", point.x, point.y)
                    Text(pointString)
                    .font(.caption.monospaced().pointSize(8))
                    .fixedSize()
                    .alignmentGuide(.bottom, moveTo: .top)
                }
            }
        }
        .frame(squareOf: 28)
        .contentShape(Circle())
        .position(x: x, y: y)
        .gesture(
            DragGesture().onChanged { drag in
                let newX = Float(drag.location.x / size.width)
                let newY = Float(drag.location.y / size.height)
                let newPoint = SIMD2<Float>(
                    min(max(newX, 0), 1),
                    min(max(newY, 0), 1)
                )
                points[index] = newPoint

                // Apply the mirrored update to the partner handle, if any.
                if let mirrorIndex = mirrorMode.mirrorIndex(of: index, width: meshWidth, height: meshHeight) {
                    points[mirrorIndex] = mirrorMode.mirror(newPoint)
                }
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


// MARK: - MirrorMode


/// Mirroring applied to a partner handle.
private enum MirrorMode {

    /// No mirroring, only the dragged handle moves.
    case none

    /// Mirrors across the horizontal center line: the row-opposite handle.
    case horizontal

    /// Mirrors through the center point: the diagonally-opposite handle.
    case both


    /// The next mode in the cycle: `none` → `horizontal` → `both` → `none`.
    var next: MirrorMode {
        switch self {
        case .none:       .horizontal
        case .horizontal: .both
        case .both:       .none
        }
    }

    var label: String {
        switch self {
        case .none:       "Mirror Off"
        case .horizontal: "Mirror"
        case .both:       "Mirror Both"
        }
    }

    var systemImage: String {
        switch self {
        case .none:       "square"
        case .horizontal: "arrow.left.and.right"
        case .both:       "arrow.up.and.down.and.arrow.left.and.right"
        }
    }


    /// The index of the partner handle to mirror the dragged one to, or `nil` when there is no
    /// mirroring or the handle mirrors onto itself (a handle on a central row/column).
    func mirrorIndex(of index: Int, width: Int, height: Int) -> Int? {
        let row = index / width
        let col = index % width

        let partnerRow: Int
        let partnerCol: Int
        switch self {
        case .none:
            return nil
        case .horizontal:
            partnerRow = row
            partnerCol = width - 1 - col
        case .both:
            partnerRow = height - 1 - row
            partnerCol = width - 1 - col
        }

        let partner = partnerRow * width + partnerCol
        return partner == index ? nil : partner
    }

    /// The position for the partner handle, mirroring along the axes affected by this mode.
    func mirror(_ point: SIMD2<Float>) -> SIMD2<Float> {
        switch self {
        case .none:       point
        case .horizontal: SIMD2(1 - point.x, point.y)
        case .both:       SIMD2(1 - point.x, 1 - point.y)
        }
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Editor", traits: .fixedHeaderFooter, PreviewContent.layout) {
    MeshGradientEditor(mesh: PrettyMesh.moltenHorizon)
}


#Preview("SummerDawnSplit") {
    PrettyMesh.summerDawnSplit
        .ignoresSafeArea()
}


#Preview("WallOfIceAndFire") {
    PrettyMesh.wallOfIceAndFire
        .ignoresSafeArea()
}


#Preview("AuroraEgg") {
    PrettyMesh.auroraEgg
        .ignoresSafeArea()
}


#Preview("MoltenHorizon") {
    PrettyMesh.moltenHorizon
        .ignoresSafeArea()
}


#Preview("EmberRibbon") {
    PrettyMesh.emberRibbon
        .ignoresSafeArea()
}


#Preview("FrozenDepth") {
    PrettyMesh.frozenDepth
        .ignoresSafeArea()
}


#Preview("GlacialVeil") {
    PrettyMesh.glacialVeil
        .ignoresSafeArea()
}


#Preview("Experiment") {
    PrettyMesh.experiment
        .ignoresSafeArea()
}
