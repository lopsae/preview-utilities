//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension MeshGradient {

    /// Returns the mesh rotated 90 degrees clockwise.
    ///
    /// The rotation transposes the control grid and rotates each control point's position. Both the
    /// color grid and each point coordinate are mapped clockwise:
    /// + Color grid: Each cell `(row, col)` maps to `(col, height - 1 - row)`.
    /// + Coordinate: Each point `(x, y)` maps to `(1 - y, x)`.
    ///
    /// Meshes not built from explicit points and colors are returned unchanged, as there are no
    /// stored values to rotate. Any `background`, `smoothsColors`, or `colorSpace` customization
    /// is not preserved, reverting to the defaults.
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

}
