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
        through insetCount: Int,
        outsetSpacing: CGFloat,
        through outsetCount: Int
    ) {
        self.insetLineSets = .init(spacing: insetSpacing, through: insetCount)
        self.outsetLineSets = .init(spacing: outsetSpacing, through: outsetCount)
    }

    func path(in rect: CGRect) -> Path {
        var path = Path()

        // Remove inset lines at zero, to prevent double drawing in the shape edge.
        var correctedInsetLineSets = insetLineSets
        for edge in Edge.allCases {
            if outsetLineSets[edge].indices.contains(.zero) {
                correctedInsetLineSets[edge].indices.remove(.zero)
            }
        }

        let insetGraticule = InsetShape(lineSets: correctedInsetLineSets)
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
        var spacing: CGFloat
        var indices: IndexSet

        init() {
            self.spacing = 0
            self.indices = .empty
        }

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

        static var empty: Self { .init() }
        static var zero: Self { .init(spacing: .zero, indices: .zero) }

        var extent: CGFloat {
            spacing * (indices.last ?? .zero).asDouble
        }
    }

}


nonisolated
extension EdgeValues where Value == EdgeGraticule.LineSet {

    init() { self.init(all: .empty) }

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

    static var empty: Self { .init() }

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

    nonisolated
    static var zero: Self { .init(integer: .zero) }

}


// MARK: - EdgeValues


nonisolated
struct EdgeValues<Value> {

    var top: Value
    var leading: Value
    var bottom: Value
    var trailing: Value

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

    init(
        top:      Value? = nil,
        leading:  Value? = nil,
        bottom:   Value? = nil,
        trailing: Value? = nil,
        default value: Value,
    ) {
        self.init(
            top:      top      ?? value,
            leading:  leading  ?? value,
            bottom:   bottom   ?? value,
            trailing: trailing ?? value
        )
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
        get {
            switch edge {
            case .top:      self.top
            case .leading:  self.leading
            case .bottom:   self.bottom
            case .trailing: self.trailing
            }
        }
        set {
            switch edge {
            case .top:      self.top     = newValue
            case .leading:  self.leading  = newValue
            case .bottom:   self.bottom   = newValue
            case .trailing: self.trailing = newValue
            }
        }

    }


    subscript(set edgeSet: Edge.Set) -> EdgeValuesProxy<Value> {
        get {
            var values: [Edge: Value] = [:]
            for edge in Edge.allCases {
                if edgeSet.contains(edge.set) {
                    values[edge] = self[edge]
                }
            }
            return .init(values: values)
        }
        set(newProxy) {
            for (edge, newValue) in newProxy.values {
                self[edge] = newValue
            }
        }
    }

    // TODO: could this be done lazily with a view of EdgeValues? This would require the EdgeValuesContainer protocol.
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


@dynamicMemberLookup
nonisolated
struct EdgeValuesProxy<Value> {

    var values: [Edge: Value]

    subscript<Property>(dynamicMember keyPath: WritableKeyPath<Value, Property>) -> Property? {
        get {
            values.first?.value[keyPath: keyPath]
        }
        set {
            // FIXME: what happens if the property itself of the object is optional? can it be nulled here?
            guard let newValue else { return }
            for key in values.keys {
                guard var value = values[key] else { continue }
                value[keyPath: keyPath] = newValue
                values[key] = value
            }
        }
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
    .floatingCaption("2", .alignment(.top))
    .floatingCaption("3", .alignment(.outerTrailing))
    .overlay {
        EdgeGraticule(insetSpacing: 10, through: 2, outsetSpacing: 20, through: 3)
        .stroke(.tertiary)
    }
}


#Preview("ViewEdge", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    PreviewCaption("""
        When inset and outset line sets contain the line at _zero_ index, those lines are removed
        from the inset line set. Otherwise, like in this case, _zero_ index lines in the inset are
        preserved.
        """)

    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .overlay {
        EdgeGraticule(
            insetLineSets: .init(
                horizontal: .init(spacing: 10, range: 0...2),
                vertical:   .init(spacing: 10, range: 2...3)
            ),
            outsetLineSets: .init(
                horizontal: .init(spacing: 20, range: 2...3),
                vertical:   .init(spacing: 20, range: 2...3)
            )
        )
        .stroke(.tertiary, lineWidth: 2)
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


// MARK: - Modifier

// FIXME: Move to its own file.


public struct EdgeGraticuleModifier: ViewModifier {

    typealias Trait = ConfigurationTrait<Configuration>

    let configuration: Configuration

    public func body(content: Content) -> some View {
        content
        .overlay {
            EdgeGraticule(
                insetLineSets: configuration.insetLineSets,
                outsetLineSets: configuration.outsetLineSets
            )
            .stroke(.quaternary)
        }
    }

    struct Configuration: TraitConfigurable {

        var insetLineSets: EdgeValues<EdgeGraticule.LineSet>
        var outsetLineSets: EdgeValues<EdgeGraticule.LineSet>

        init() {
            insetLineSets = .init(all: .empty)
            outsetLineSets = .init(all: .zero)
        }

        init(spacing: CGFloat) {
            insetLineSets = .init(spacing: spacing, indices: .empty)
            outsetLineSets = .init(spacing: spacing, indices: .zero)
        }

    }

}


// MARK: - Traits


/// Contains the configuration traits that can be applied to the configuration of ``DebugAlignmentGuideModifier``.
extension ConfigurationTrait where Configuration == EdgeGraticuleModifier.Configuration {

    // FIXME: document.
//    public static func inset(_ edgeSet: Edge.Set, _ count: Int): Self {
//        .mutate {
//            $0.insetLineSets[.top].spacing
//        }
//        .modifier(Modifiers.Opacity(opacity: .zero))
//    }

}


// MARK: - View Extensions


extension View {

    public func edgeGraticule(
        insetSpacing: CGFloat,
        through insetCount: Int,
        outsetSpacing: CGFloat,
        through outsetCount: Int
    ) -> some View {
        let insetLineSets: EdgeValues<EdgeGraticule.LineSet> = .init(spacing: insetSpacing, through: insetCount)
        let outsetLineSets: EdgeValues<EdgeGraticule.LineSet> = .init(spacing: outsetSpacing, through: outsetCount)
        var configuration = EdgeGraticuleModifier.Configuration()
        configuration.insetLineSets = insetLineSets
        configuration.outsetLineSets = outsetLineSets
        let graticuleModifier = EdgeGraticuleModifier(configuration: configuration)
        return modifier(graticuleModifier)
    }


    public func edgeGraticule(insetSpacing: CGFloat, through count: Int) -> some View {
        var configuration = EdgeGraticuleModifier.Configuration()
        configuration.insetLineSets = .init(spacing: insetSpacing, through: count)
        configuration.outsetLineSets = .empty
        let graticuleModifier = EdgeGraticuleModifier(configuration: configuration)
        return modifier(graticuleModifier)
    }


    public func edgeGraticule(outsetSpacing: CGFloat, through count: Int) -> some View {
        var configuration = EdgeGraticuleModifier.Configuration()
        configuration.insetLineSets = .empty
        configuration.outsetLineSets = .init(spacing: outsetSpacing, through: count)
        let graticuleModifier = EdgeGraticuleModifier(configuration: configuration)
        return modifier(graticuleModifier)
    }

}


#Preview("Modifier", traits: .spacing(30), .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .edgeGraticule(insetSpacing: 10, through: 2, outsetSpacing: 20, through: 1)
    .floatingCaption("Inset/Outset", .alignment(.outerTop))

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .edgeGraticule(insetSpacing: 10, through: 2)
    .floatingCaption("Only Inset", .alignment(.outerTop))

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .edgeGraticule(outsetSpacing: 20, through: 1)
    .floatingCaption("Only Outset", .alignment(.outerTop))
}


#Playground("EdgeSet Modification") {
    var lineSet: EdgeValues<EdgeGraticule.LineSet> = .init(
        top: .init(spacing: 5,  through: 4),
        lea: .init(spacing: 10, through: 3),
        bot: .init(spacing: 15, through: 2),
        tra: .init(spacing: 20, through: 1)
    )

    _ = lineSet[.top].spacing
    _ = lineSet[set: .horizontal]

    lineSet[set: .vertical].spacing = 30
    let modified = lineSet
}
