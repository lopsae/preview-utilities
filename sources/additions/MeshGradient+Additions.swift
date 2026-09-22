//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


extension MeshGradient {

    /// Returns the mesh rotated 90 degrees clockwise.
    ///
    /// The rotation transposes the control grid and rotates each control point's position. Both the
    /// color grid and each point coordinate are mapped clockwise:
    /// + Color grid: Each cell `(row, col)` maps to `(col, height - 1 - row)`.
    /// + Coordinate: Each point `(x, y)` maps to `(1 - y, x)`.
    ///
    /// Meshes not built from explicit points and colors are returned unchanged.
    public func rotated() -> MeshGradient {
        guard
            case .points(let points) = locations,
            case .colors(let colorValues) = colors
        else {
            return self
        }

        let oldWidth = width
        let oldHeight = height
        let newWidth = oldHeight
        let newHeight = oldWidth

        var rotatedPoints = points
        var rotatedColors = colorValues

        for newRow in 0 ..< newHeight {
            for newCol in 0 ..< newWidth {
                let oldRow = oldHeight - 1 - newCol
                let oldCol = newRow
                let oldIndex = oldRow * oldWidth + oldCol
                let newIndex = newRow * newWidth + newCol

                let point = points[oldIndex]
                rotatedPoints[newIndex] = SIMD2(1 - point.y, point.x)
                rotatedColors[newIndex] = colorValues[oldIndex]
            }
        }

        let newMesh = MeshGradient(
            width: newWidth,
            height: newHeight,
            points: rotatedPoints,
            colors: rotatedColors,
            background: background,
            smoothsColors: smoothsColors,
            colorSpace: colorSpace
        )
        return newMesh
    }


    /// Returns the mesh with opacity applied to the colors present in the given dictionary.
    ///
    /// Each color that appears as a key in `opacities` is replaced with the same color at the
    /// corresponding opacity. Matching uses `Color` equality. Colors not present in the dictionary
    /// are left unchanged.
    ///
    /// Points and other properties of the mesh are copied to the resulting instance.
    ///
    /// Meshes not built from explicit points and colors are returned unchanged.
    ///
    /// - Parameter opacities: The opacity to apply to each matching color.
    public func applying(opacities: [Color: CGFloat]) -> MeshGradient {
        guard
            case .points(let points) = locations,
            case .colors(let colorValues) = colors
        else {
            return self
        }

        let modifiedColors = colorValues.map { color -> Color in
            guard let opacity = opacities[color] else {
                return color
            }
            return color.opacity(Double(opacity))
        }

        return MeshGradient(
            width: width,
            height: height,
            points: points,
            colors: modifiedColors,
            background: background,
            smoothsColors: smoothsColors,
            colorSpace: colorSpace
        )
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Rotated") {
    PrettyMesh.moltenHorizon.rotated()
    .ignoresSafeArea()
}


#Preview("Opacities") {
    PrettyMesh.moltenHorizon
    .applying(opacities: [
        .red:    0.9,
        .yellow: 0.3,
        .orange: 0.5

    ])
    .ignoresSafeArea()
    .background(.background)
}
