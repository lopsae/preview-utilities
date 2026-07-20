//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI
import Playgrounds


struct EdgeGraticule: Shape {

    let insetLineSets: EdgeValues<LineSet>
    let outsetLineSets: EdgeValues<LineSet>

    init(insetLineSets: EdgeValues<LineSet>, outsetLineSets: EdgeValues<LineSet>) {
        self.insetLineSets = insetLineSets
        self.outsetLineSets = outsetLineSets
    }

    init(
        insetSpacing: CGFloat,
        through insetThrough: Int,
        outsetSpacing: CGFloat,
        through outsetThrough: Int
    ) {
        if insetThrough > 0 {
            self.insetLineSets = .init(spacing: insetSpacing, range: 1...insetThrough)
        } else {
            self.insetLineSets = .init(spacing: insetSpacing, indices: .empty)
        }

        self.outsetLineSets = .init(spacing: outsetSpacing, through: outsetThrough)
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let insetGraticule = InsetShape(lineSets: insetLineSets)
        path.addPath(insetGraticule.path(in: rect))

        let outsetGraticule = OutsetShape(lineSets: outsetLineSets)
        path.addPath(outsetGraticule.path(in: rect))

        return path
    }

}


// MARK: - LineSet


extension EdgeGraticule {

    nonisolated
    struct LineSet : Equatable, Sendable {
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

        var extent: CGFloat {
            spacing * (indices.last ?? .zero).asDouble
        }
    }

}


nonisolated
extension EdgeValues where Value == EdgeGraticule.LineSet {

    init(spacing: CGFloat, indices: IndexSet) {
        let lineSet = EdgeGraticule.LineSet(spacing: spacing, indices: indices)
        self.init(all: lineSet)
    }

    init(spacing: CGFloat, through count: Int) {
        let lineSet = EdgeGraticule.LineSet(spacing: spacing, through: count)
        self.init(all: lineSet)
    }

    init(spacing: CGFloat, range: ClosedRange<Int>) {
        let lineSet = EdgeGraticule.LineSet(spacing: spacing, range: range)
        self.init(all: lineSet)
    }

    var extents: EdgeValues<CGFloat> {
        .init(edgeValues: self, property: \.extent)
    }

}


// MARK: - InsetShape


extension EdgeGraticule {

    struct InsetShape: Shape {

        let lineSets: EdgeValues<LineSet>

        init(lineSets: EdgeValues<LineSet>) {
            self.lineSets = lineSets
        }

        init(horizontal: LineSet, vertical: LineSet) {
            self.lineSets = .init(horizontal: horizontal, vertical: vertical)
        }

        init(spacing: CGFloat, through: Int) {
            self.lineSets = .init(all: .init(spacing: spacing, through: through))
        }

        func path(in rect: CGRect) -> Path {
            var path = Path()

            for edge in Edge.allCases {
                let spacing = lineSets[edge].spacing
                for index in lineSets[edge].indices {
                    let offset = spacing * index.asDouble
                    rect.inset(edge: edge, by: offset)
                        .addToPath(&path, edge: edge)
                }
            }

            return path
        }

    }

}


// MARK: - OutsetShape


extension EdgeGraticule {

    struct OutsetShape: Shape {

        let lineSets: EdgeValues<LineSet>

        init(lineSets: EdgeValues<LineSet>) {
            self.lineSets = lineSets
        }

        init(horizontal: LineSet, vertical: LineSet) {
            self.lineSets = .init(horizontal: horizontal, vertical: vertical)
        }

        init(spacing: CGFloat, through: Int) {
            self.lineSets = .init(all: .init(spacing: spacing, through: through))
        }

        func path(in rect: CGRect) -> Path {
            var path = Path()
            let extents = lineSets.extents

            for edge in Edge.allCases {
                let spacing = lineSets[edge].spacing
                for index in lineSets[edge].indices {
                    let offset = spacing * index.asDouble
                    rect.outset(edge: edge, by: offset)
                        .outset(edges: edge.orthogonalSet, values: extents)
                        .addToPath(&path, edge: edge)
                }
            }

            return path
        }

    }

}


// MARK: - Experimental Extensions


private extension CGRect {

    @discardableResult
    /*@inlinable*/ nonisolated
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
    func inset(edge: Edge, by value: CGFloat) -> Self {
        var result = self
        switch edge {
        case .top:
            result.origin.y    += value
            result.size.height -= value
        case .leading:
            result.origin.x    += value
            result.size.width  -= value
        case .bottom:
            result.size.height -= value
        case .trailing:
            result.size.width  -= value
        }
        return result
    }


    nonisolated
    func outset(edge: Edge, by value: CGFloat) -> Self {
        inset(edge: edge, by: -value)
    }


    nonisolated
    func inset(edges: Edge.Set, values: EdgeValues<CGFloat>) -> Self {
        var result = self
        for edge in Edge.allCases {
            if edges.contains(edge.set) {
                result = result.inset(edge: edge, by: values[edge])
            }
        }
        return result
    }


    nonisolated
    func outset(edges: Edge.Set, values: EdgeValues<CGFloat>) -> Self {
        // TODO: This map transform all values, even the ones not used. Having a protocol for
        // EdgeValues, and an implementation that lazy maps to -1 would prevent all values having to
        // be transformed by map.
        inset(edges: edges, values: values.map { -$0 })
    }


    nonisolated
    func outset(
        top:      CGFloat = .zero,
        leading:  CGFloat = .zero,
        bottom:   CGFloat = .zero,
        trailing: CGFloat = .zero,
    ) -> Self {
        var result = self
        result.origin.x    -= leading
        result.origin.y    -= top
        result.size.width  += leading + trailing
        result.size.height += top + bottom
        return result
    }

}


private extension Edge {

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


private extension IndexSet {

    nonisolated
    static var empty: Self { .init() }

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

    func map<NewValue>(_ transform: (Value) throws -> NewValue) rethrows -> EdgeValues<NewValue> {
        .init(
            top:      try transform(top),
            leading:  try transform(leading),
            bottom:   try transform(bottom),
            trailing: try transform(trailing)
        )
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
    .floatingCaption("2", .alignment(.top))
    .floatingCaption("3", .alignment(.outerTrailing))
    .overlay {
        EdgeGraticule(insetSpacing: 10, through: 2, outsetSpacing: 20, through: 3)
        .stroke(.quaternary)
    }
}


#Preview("Inset", traits: .spacing(30), .headerFooter, PreviewContent.layout) {
    Rectangle()
    .fill(.green.quinary)
    .border(.green.tertiary, width: 10)
    .frame(squareOf: 150)
    .floatingCaption("3", .alignment(.outerTrailing))
    .floatingCaption("3", .alignment(.outerBottom))
    .overlay {
        EdgeGraticule.InsetShape(spacing: 10, through: 3)
        .stroke(.tertiary)
    }

    DashedDivider()

    Rectangle()
    .fill(.green.quinary)
    .border(.green.tertiary, width: 10)
    .frame(squareOf: 150)
    .floatingCaption("5", .alignment(.outerTop))
    .floatingCaption("4", .alignment(.outerLeading))
    .floatingCaption("3", .alignment(.outerBottom))
    .floatingCaption("2", .alignment(.outerTrailing))
    .overlay {
        EdgeGraticule.InsetShape(
            lineSets: .init(
                top:      .init(spacing: 5,  through: 5),
                leading:  .init(spacing: 10, through: 4),
                bottom:   .init(spacing: 15, through: 3),
                trailing: .init(spacing: 20, through: 2)
            )
        )
        .stroke(.tertiary)
    }
}


#Preview("InsetRange", traits: .spacing(40), .headerFooter, PreviewContent.layout) {
    Rectangle()
    .fill(.green.quinary)
    .border(.green.tertiary, width: 10)
    .frame(squareOf: 150)
    .floatingCaption("2...5", .alignment(.outerTrailing))
    .floatingCaption("1...2", .alignment(.outerBottom))
    .overlay {
        EdgeGraticule.InsetShape(
            horizontal: .init(spacing: 10, range: 2...5),
            vertical: .init(spacing: 10, range: 1...2)
        )
        .stroke(.tertiary)
    }

    DashedDivider()

    Rectangle()
    .fill(.green.quinary)
    .border(.green.tertiary, width: 10)
    .frame(squareOf: 150)
    .floatingCaption("None", .alignment(.outerTrailing))
    .floatingCaption("1...3", .alignment(.outerBottom))
    .overlay {
        EdgeGraticule.InsetShape(
            horizontal: .init(spacing: 10, indices: .init()),
            vertical: .init(spacing: 10, range: 1...3)
        )
        .stroke(.tertiary)
    }
}


#Preview("Outset", traits: .spacing(100), .headerFooter, PreviewContent.layout) {
    Rectangle()
    .fill(.green.quinary)
    .border(.green.tertiary, width: 10)
    .frame(squareOf: 100)
    .floatingCaption("3", .alignment(.trailing))
    .floatingCaption("3", .alignment(.bottom))
    .overlay {
        EdgeGraticule.OutsetShape(spacing: 20, through: 3)
        .stroke(.tertiary)
    }

    Rectangle()
    .fill(.green.quinary)
    .border(.green.tertiary, width: 10)
    .frame(squareOf: 100)
    .floatingCaption("5", .alignment(.top))
    .floatingCaption("4", .alignment(.leading))
    .floatingCaption("3", .alignment(.bottom))
    .floatingCaption("2", .alignment(.trailing))
    .overlay {
        EdgeGraticule.OutsetShape(
            lineSets: .init(
                top: .init(spacing: 5, through: 5),
                leading: .init(spacing: 10, through: 4),
                bottom: .init(spacing: 15, through: 3),
                trailing: .init(spacing: 20, through: 2)
            )
        )
        .stroke(.tertiary)
    }
}


#Preview("OutsetRange", traits: .spacing(80), .headerFooter, PreviewContent.layout) {
    Rectangle()
    .fill(.green.quinary)
    .border(.green.tertiary, width: 10)
    .frame(squareOf: 100)
    .floatingCaption("2...5", .alignment(.outerTrailing))
    .floatingCaption("1...2", .alignment(.outerBottom))
    .overlay {
        EdgeGraticule.OutsetShape(
            horizontal: .init(spacing: 20, range: 2...5),
            vertical: .init(spacing: 30, range: 1...2)
        )
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
        EdgeGraticule.OutsetShape(
            horizontal: .init(spacing: 20, indices: .init()),
            vertical: .init(spacing: 20, range: 1...3)
        )
        .stroke(.tertiary)
    }
}


#Playground("IndexSet&Misc") {
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
