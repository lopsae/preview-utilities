//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI
import Playgrounds


struct EdgeGraticule: Shape {

    let outerSpacing: CGFloat
    let outerCount: Int

    let innerSpacing: CGSize
    let innerCount: Int

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let outsetGraticule = OutsetEdgeGraticule(lineArguments: .init(all: .init(
            spacing: outerSpacing,
            through: outerCount
        )))
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

    let lineArguments: EdgeValues<EdgeGraticuleLineArguments>

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let topLastIndex      = lineArguments.top.indices.last ?? .zero
        let leadingLastIndex  = lineArguments.leading.indices.last ?? .zero
        let bottomLastIndex   = lineArguments.bottom.indices.last ?? .zero
        let trailingLastIndex = lineArguments.trailing.indices.last ?? .zero

        for index in lineArguments.top.indices {
            let outset = lineArguments.top.spacing * index.asDouble
            // FIXME: is last always the max/last index?
            let outerLeading = lineArguments.leading.spacing * leadingLastIndex.asDouble
            let outerTrailing = lineArguments.trailing.spacing * trailingLastIndex.asDouble

            let topY = rect.minY - outset
            path.moveTo(x: rect.minX - outerLeading, y: topY)
            path.addLineTo(x: rect.maxX + outerTrailing, y: topY)
        }

        for index in lineArguments.leading.indices {
            let outset = lineArguments.leading.spacing * index.asDouble
            let outerTop = lineArguments.top.spacing * topLastIndex.asDouble
            let outerBottom = lineArguments.bottom.spacing * bottomLastIndex.asDouble

            let leadingX = rect.minX - outset
            path.moveTo(x: leadingX, y: rect.minY - outerTop)
            path.addLineTo(x: leadingX, y: rect.maxY + outerBottom)
        }

        for index in lineArguments.bottom.indices {
            let outset = lineArguments.bottom.spacing * index.asDouble
            let outerLeading = lineArguments.leading.spacing * leadingLastIndex.asDouble
            let outerTrailing = lineArguments.trailing.spacing * trailingLastIndex.asDouble

            let bottomY = rect.maxY + outset
            path.moveTo(x: rect.minX - outerLeading, y: bottomY)
            path.addLineTo(x: rect.maxX + outerTrailing, y: bottomY)
        }

        for index in lineArguments.trailing.indices {
            let outset = lineArguments.trailing.spacing * index.asDouble
            let outerTop = lineArguments.top.spacing * topLastIndex.asDouble
            let outerBottom = lineArguments.bottom.spacing * bottomLastIndex.asDouble

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
struct EdgeGraticuleLineArguments: Equatable, Sendable {
    let spacing: CGFloat
    let indices: IndexSet

    init(spacing: CGFloat, indices: IndexSet) {
        self.spacing = spacing
        self.indices = indices
    }

    init(spacing: CGFloat, through count: Int) {
        self.spacing = spacing
        self.indices = IndexSet(0...count)
    }
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
        OutsetEdgeGraticule(lineArguments: .init(all: .init(
            spacing: 20,
            through: 3
        )))
        .stroke(.tertiary)
    }

    Rectangle()
    .fill(.green.quinary)
    .border(.green.tertiary, width: 10)
    .frame(squareOf: 100)
    .overlay {
        OutsetEdgeGraticule(
            lineArguments: .init(
                top: .init(spacing: 5, through: 5),
                leading: .init(spacing: 10, through: 4),
                bottom: .init(spacing: 15, through: 3),
                trailing: .init(spacing: 20, through: 2)
            )
        )
        .stroke(.tertiary)
    }
}


#Playground("IndexSet") {
    _ = IndexSet(0..<5).last
    _ = IndexSet(0...5).last

    var compositeWithHead = IndexSet(5..<10)
    compositeWithHead.insert(1)
    compositeWithHead.insert(2)
    _ = compositeWithHead.last

    var compositeWithTail = IndexSet(1..<5)
    compositeWithTail.insert(8)
    compositeWithTail.insert(9)
    _ = compositeWithTail.last
}
