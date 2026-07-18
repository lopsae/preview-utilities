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

        let outsetGraticule = OutsetEdgeGraticule(lineSet: .init(
            spacing: .init(all: outerSpacing),
            count: .init(all: outerCount)
        ))
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

    let lineSet: EdgeGraticuleLineSets

    func path(in rect: CGRect) -> Path {
        var path = Path()

        for index in 0 ..< lineSet.count.top {
            let outset = lineSet.spacing.top * index.asDouble
            let outerLeading = lineSet.spacing.leading * (lineSet.count.leading.asDouble - 1)
            let outerTrailing = lineSet.spacing.trailing * (lineSet.count.trailing.asDouble - 1)

            let topY = rect.minY - outset
            path.moveTo(x: rect.minX - outerLeading, y: topY)
            path.addLineTo(x: rect.maxX + outerTrailing, y: topY)
        }

        for index in 0 ..< lineSet.count.leading {
            let outset = lineSet.spacing.leading * index.asDouble
            let outerTop = lineSet.spacing.top * (lineSet.count.top.asDouble - 1)
            let outerBottom = lineSet.spacing.bottom * (lineSet.count.bottom.asDouble - 1)

            let leadingX = rect.minX - outset
            path.moveTo(x: leadingX, y: rect.minY - outerTop)
            path.addLineTo(x: leadingX, y: rect.maxY + outerBottom)
        }

        for index in 0 ..< lineSet.count.bottom {
            let outset = lineSet.spacing.bottom * index.asDouble
            let outerLeading = lineSet.spacing.leading * (lineSet.count.leading.asDouble - 1)
            let outerTrailing = lineSet.spacing.trailing * (lineSet.count.trailing.asDouble - 1)

            let bottomY = rect.maxY + outset
            path.moveTo(x: rect.minX - outerLeading, y: bottomY)
            path.addLineTo(x: rect.maxX + outerTrailing, y: bottomY)
        }

        for index in 0 ..< lineSet.count.trailing {
            let outset = lineSet.spacing.trailing * index.asDouble
            let outerTop = lineSet.spacing.top * (lineSet.count.top.asDouble - 1)
            let outerBottom = lineSet.spacing.bottom * (lineSet.count.bottom.asDouble - 1)

            let trailingX = rect.maxX + outset
            path.moveTo(x: trailingX, y: rect.minY - outerTop)
            path.addLineTo(x: trailingX, y: rect.maxY + outerBottom)
        }

        return path
    }

}


// FIXME: Make count into IndexSet? so that the indexes to draw can be selected, and zero skipped.
// FIXME: Consider making a LineSet struct, that contains the spacing and count and utilities for a single edge.

nonisolated
struct EdgeGraticuleLineSets : Equatable, Sendable {

    let spacing: EdgeValues<CGFloat>
    let count: EdgeValues<Int>

}


nonisolated
struct EdgeValues<Value> {

    let top: Value
    let leading: Value
    let bottom: Value
    let trailing: Value

    init(top: Value, leading: Value, bottom: Value, trailing: Value) {
        self.top      = top
        self.leading  = leading
        self.bottom   = bottom
        self.trailing = trailing
    }

    init(all value: Value) {
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }

    init(horizontal: Value, vertical: Value) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
}


nonisolated
extension EdgeValues: Equatable where Value: Equatable {}

nonisolated
extension EdgeValues: Sendable where Value: Sendable {}


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


#Preview("Outer", traits: .spacing(100), .headerFooter, PreviewContent.layout) {
    Rectangle()
    .fill(.green.quinary)
    .border(.green.tertiary, width: 10)
    .frame(squareOf: 100)
    .overlay {
        OutsetEdgeGraticule(
            lineSet: .init(
                spacing: .init(all: 20),
                count: .init(all: 3)
            )
        )
        .stroke(.tertiary)
    }

    Rectangle()
    .fill(.green.quinary)
    .border(.green.tertiary, width: 10)
    .frame(squareOf: 100)
    .overlay {
        OutsetEdgeGraticule(
            lineSet: .init(
                spacing: .init(top: 5, leading: 10, bottom: 15, trailing: 20),
                count: .init(top: 5, leading: 4, bottom: 3, trailing: 2)
            )
        )
        .stroke(.tertiary)
    }
}
