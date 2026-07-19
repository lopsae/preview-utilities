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
        let lastOffsets = lineArguments.lastOffsets

        for edge in Edge.allCases {
            let spacing = lineArguments[edge].spacing
            for index in lineArguments[edge].indices {
                let edgeOffset = spacing * index.asDouble
                rect.outset(edge: edge, by: edgeOffset)
                    .outset(edges: edge.orthogonalSet, values: lastOffsets)
                    .addToPath(&path, edge: edge)
            }
        }

        return path
    }

}


// MARK: - Experimental Extensions


extension CGRect {

    @discardableResult
    @inlinable nonisolated
    func addToPath(_ path: inout Path, edge: Edge) -> Self {
        // Rect by default is draw from origin towards the horizontal
        // origin → maxX,minY → maxX,maxY → minX,maxY
        switch edge {
        case .top:
            path.moveTo(x: minX, y: minY)
            path.addLineTo(x: maxX, y: minY)
        case .trailing:
            path.moveTo(x: maxX, y: minY)
            path.addLineTo(x: maxX, y: maxY)
        case .bottom:
            path.moveTo(x: maxX, y: maxY)
            path.addLineTo(x: minX, y: maxY)
        case .leading:
            path.moveTo(x: minX, y: maxY)
            path.addLineTo(x: minX, y: minY)
        }
        return self
    }


    nonisolated
    func outset(edge: Edge, by value: CGFloat) -> Self {
        var result = self
        switch edge {
        case .top:
            result.origin.y    -= value
            result.size.height += value
        case .leading:
            result.origin.x    -= value
            result.size.width  += value
        case .bottom:
            result.size.height += value
        case .trailing:
            result.size.width  += value
        }
        return result
    }


    nonisolated
    func outset(edges: Edge.Set, values: EdgeValues<CGFloat>) -> Self {
        var result = self
        for edge in Edge.allCases {
            if edges.contains(edge.set) {
                result = result.outset(edge: edge, by: values[edge])
            }
        }
        return result
    }


    nonisolated
    func outset(
        top: CGFloat = .zero,
        leading: CGFloat = .zero,
        bottom: CGFloat = .zero,
        trailing: CGFloat = .zero,
    ) -> Self {
        var result = self
        result.origin.x -= leading
        result.origin.y -= top
        result.size.width += leading + trailing
        result.size.height += top + bottom
        return result
    }

}


extension Edge {

    nonisolated
    var set: Edge.Set { .init(self) }

    nonisolated
    var orthogonalSet: Edge.Set {
        switch self {
        case .top:      .horizontal
        case .leading:  .vertical
        case .bottom:   .horizontal
        case .trailing: .vertical
        }
    }

}


// MARK: - EdgeGraticuleLineArguments


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

    init(spacing: CGFloat, range: ClosedRange<Int>) {
        self.spacing = spacing
        self.indices = IndexSet(range)
    }

    // FIXME: Better name.
    var lastOffset: CGFloat {
        spacing * (indices.last ?? .zero).asDouble
    }
}


nonisolated
extension EdgeValues where Value == EdgeGraticuleLineArguments {

    var lastOffsets: EdgeValues<CGFloat> {
        .init(edgeValues: self, property: \.lastOffset)
    }

}


// MARK: - EdgeValues


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

    init(top: Value, lea: Value, bot: Value, tra: Value) {
        self.init(top: top, leading: lea, bottom: bot, trailing: tra)
    }

    init(all value: Value) {
        self.init(top: value, leading: value, bottom: value, trailing: value)
    }

    init(horizontal: Value, vertical: Value) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }


    init<OtherValue>(edgeValues: EdgeValues<OtherValue>, property: KeyPath<OtherValue, Value>) {
        self.init(
            top:      edgeValues.top[keyPath: property],
            leading:  edgeValues.lea[keyPath: property],
            bottom:   edgeValues.bot[keyPath: property],
            trailing: edgeValues.tra[keyPath: property]
        )
    }

    var lea: Value { leading }
    var bot: Value { bottom }
    var tra: Value { trailing }

    subscript(_ edge: Edge) -> Value {
        switch edge {
        case .top:      self.top
        case .leading:  self.leading
        case .bottom:   self.bottom
        case .trailing: self.trailing
        }
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


#Preview("IndexRange", traits: .spacing(80), .headerFooter, PreviewContent.layout) {
    Rectangle()
    .fill(.green.quinary)
    .border(.green.tertiary, width: 10)
    .frame(squareOf: 100)
    .floatingCaption("2...5", .alignment(.outerTrailing))
    .floatingCaption("1...2", .alignment(.outerBottom))
    .overlay {
        OutsetEdgeGraticule(lineArguments: .init(
            horizontal: .init(spacing: 20, range: 2...5),
            vertical: .init(spacing: 30, range: 1...2)
        ))
        .stroke(.tertiary)
    }

    DashedDivider()

    Rectangle()
    .fill(.green.quinary)
    .border(.green.tertiary, width: 10)
    .frame(squareOf: 100)
    .floatingCaption("None", .alignment(.outerTrailing))
    .floatingCaption("1...3", .alignment(.outerBottom))
    .overlay {
        OutsetEdgeGraticule(lineArguments: .init(
            horizontal: .init(spacing: 20, indices: .init()),
            vertical: .init(spacing: 20, range: 1...3)
        ))
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

    _ = Edge.Set.horizontal.contains(.top)
    _ = Edge.Set.horizontal.contains(.leading)
}
