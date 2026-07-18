//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct EdgeGraticule: Shape {

    let outerSpacing: CGFloat
    let outerCount: Int

    let innerSpacing: CGSize
    let innerCount: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let outsetGraticule = OutsetEdgeGraticule(spacing: outerSpacing, count: outerCount)
        path.addPath(outsetGraticule.path(in: rect))

        // Inner graticules.
        for index in 0 ..< innerCount {
            let inset = innerSpacing.height * (index.asDouble + 1)

            // Horizontal.
            let topY = rect.minY + inset
            path.moveTo(x: rect.minX, y: topY)
            path.addLineTo(x: rect.maxX, y: topY)

            let bottomY = rect.maxY - inset
            path.moveTo(x: rect.minX, y: bottomY)
            path.addLineTo(x: rect.maxX, y: bottomY)

            // Vertical.
            let leadingX = rect.minX + inset
            path.moveTo(x: leadingX, y: rect.minY)
            path.addLineTo(x: leadingX, y: rect.maxY)

            let trailingX = rect.maxX - inset
            path.moveTo(x: trailingX, y: rect.minY)
            path.addLineTo(x: trailingX, y: rect.maxY)
        }

        return path
    }

}


// MARK: - OutsetEdgeGraticule


struct OutsetEdgeGraticule: Shape {

    let spacing: CGFloat
    let count: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()
        for index in 0 ..< count {
            let outset = spacing * index.asDouble
            let outerDistance = spacing * (count.asDouble - 1)

            // Horizontal.
            let topY = rect.minY - outset
            path.moveTo(x: rect.minX - outerDistance, y: topY)
            path.addLineTo(x: rect.maxX + outerDistance, y: topY)

            let bottomY = rect.maxY + outset
            path.moveTo(x: rect.minX - outerDistance, y: bottomY)
            path.addLineTo(x: rect.maxX + outerDistance, y: bottomY)

            // Vertical.
            let leadingX = rect.minX - outset
            path.moveTo(x: leadingX, y: rect.minY - outerDistance)
            path.addLineTo(x: leadingX, y: rect.maxY + outerDistance)

            let trailingX = rect.maxX + outset
            path.moveTo(x: trailingX, y: rect.minY - outerDistance)
            path.addLineTo(x: trailingX, y: rect.maxY + outerDistance)
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
    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .overlay {
        EdgeGraticule(
            outerSpacing: 20,
            outerCount: 3,
            innerSpacing: .square(of: 10),
            innerCount: 3,
        )
        .stroke(.quaternary)
    }
}


#Preview("Outer", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    Rectangle()
    .fill(.green.quinary)
    .border(.green.tertiary, width: 10)
    .frame(squareOf: 100)
    .overlay {
        OutsetEdgeGraticule(spacing: 20, count: 3)
        .stroke(.tertiary)
    }
}
