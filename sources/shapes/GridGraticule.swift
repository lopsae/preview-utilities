//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Shape that draws a grid of vertical and horizontal lines in its available space.
///
/// The grid is anchored to the origin point of its coordinate system, not to the origin of the
/// provided rect: receiving a rect with a non-zero origin will path the graticule offset of the
/// rect's origin, to anchor it to the coordinate system origin.
///
/// The spacing between the lines is determined by `spacing`, using `width` to separate vertical
/// lines, and `height` for horizontal.
struct GridGraticule: Shape {

    let spacing: CGSize

    func path(in rect: CGRect) -> Path {
        var path = Path()

        if spacing.width > .zero {
            let firstX = (rect.minX / spacing.width).rounded(.up) * spacing.width
            for x in stride(from: firstX, through: rect.maxX, by: spacing.width) {
                path.moveTo(x: x, y: rect.minY)
                path.addLineTo(x: x, y: rect.maxY)
            }
        }

        if spacing.height > .zero {
            let firstY = (rect.minY / spacing.height).rounded(.up) * spacing.height
            for y in stride(from: firstY, through: rect.maxY, by: spacing.height) {
                path.moveTo(x: rect.minX, y: y)
                path.addLineTo(x: rect.maxX, y: y)
            }
        }

        return path
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    GridGraticule(spacing: .square(of: 50))
    .stroke(.secondary)
}


#Preview("Offset", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    Canvas { context, size in
        let fullRect = CGRect(origin: .zero, size: size)
        let insetRect = fullRect.insetBy(dx: 40, dy: 40)
        let grid = GridGraticule(spacing: .square(of: 50))

        // Full-space grid, as reference.
        context.stroke(grid.path(in: fullRect), with: .style(.quaternary))
        // Same grid drawn in the offset rect.
        context.stroke(grid.path(in: insetRect), with: .style(.red.secondary))
        // Boundary of the offset rect.
        let dashedStyle = StrokeStyle(lineWidth: 1, dash: [4, 4])
        context.stroke(Path(insetRect), with: .style(.green.secondary), style: dashedStyle)
    }
}
