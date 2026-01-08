//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Adds a debug overlay that draws in an overlay of the modified view a dashed stroke inset in the
/// view's border, a solid stroke outset, and rectangles to visualize any safe-areas around the
/// view.
public struct DebugOutlineModifier: ViewModifier {

    private static let minLineWidth: CGFloat = 1
    private static let minReticuleLength: CGFloat = 2

    let oldOptions: OldOptions

    let newOptions: NewOptions

    let outerShapeStyle:     some ShapeStyle = .blue.tertiary
    let innerShapeStyle:     some ShapeStyle = .red.tertiary
    let safeAreasShapeStyle: some ShapeStyle = .green.tertiary


    // TODO: transitional initializer, remove!

    /// Creates a modifier with a given line width and options.
    ///
    /// The line width can be 1 at a minimum, smaller values are ignored.
    init(lineWidth: CGFloat = 5, oldOptions: OldOptions = []) {
        self.oldOptions = oldOptions
        self.newOptions = .init(traits: [.lineWidth(lineWidth)])
    }


    init() {
        self.oldOptions = []
        self.newOptions = .init()
    }


    init(newOptions: NewOptions, oldOptions: OldOptions = []) {
        self.oldOptions = oldOptions
        self.newOptions = newOptions
    }


    public func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { geometry in
                safeAreaRects(geometry: geometry)
                outerStrokeRect(geometry: geometry)
                innerStrokeRect(geometry: geometry)
                originReticuleRects(geometry: geometry)
                geometryInfoView(geometry)
            } // GeometryReader
            .allowsHitTesting(false)
        } // overlay
    }


    @ViewBuilder
    private func safeAreaRects(geometry: GeometryProxy) -> some View {
        let size = geometry.size
        let boundedLineWidth = newOptions.lineWidth.clamped(to: Self.minLineWidth...)

        // When debugged view is smaller that `lineWidth*2` the safe areas are still drawn with a
        // thickness of `lineWidth*2` to remain visible, and offset to stay centered with the
        // origin.
        let minimumRect = CGSize(square: boundedLineWidth * 2).centered(in: size)
        let xOffset = min(0.0, minimumRect.origin.x)
        let yOffset = min(0.0, minimumRect.origin.y)

        let minWidth  = max(boundedLineWidth * 2, size.width)
        let minHeight = max(boundedLineWidth * 2, size.height)

        let topInset      = geometry.safeAreaInsets.top
        let leadingInset  = geometry.safeAreaInsets.leading
        let bottomInset   = geometry.safeAreaInsets.bottom
        let trailingInset = geometry.safeAreaInsets.trailing

        // Top.
        if topInset != 0 {
            Rectangle()
                .fill(safeAreasShapeStyle)
                .frame(width: minWidth, height: topInset)
                .offset(x: xOffset, y: -topInset)
        }
        // Leading.
        if leadingInset != 0 {
            Rectangle()
                .fill(safeAreasShapeStyle)
                .frame(width: leadingInset, height: minHeight)
                .offset(x: -leadingInset, y: yOffset)
        }
        // Bottom.
        if bottomInset != 0 {
            Rectangle()
                .fill(safeAreasShapeStyle)
                .frame(width: minWidth, height: bottomInset)
                .offset(x: xOffset, y: size.height)
        }

        // Trailing.
        if trailingInset != 0 {
            Rectangle()
                .fill(safeAreasShapeStyle)
                .frame(width: trailingInset, height: minHeight)
                .offset(x: size.width, y: yOffset)
        }
    }


    @ViewBuilder
    private func outerStrokeRect(geometry: GeometryProxy) -> some View {
        let localFrame = geometry.frame(in: .local)
        let correctedFrame = correctZeroRect(localFrame)
        let boundedLineWidth = newOptions.lineWidth.clamped(to: Self.minLineWidth...)

        Rectangle()
            .stroke(outerShapeStyle, lineWidth: boundedLineWidth * 2)
            .mask {
                Path { path in
                    path.addRect(correctedFrame.inset(by: -boundedLineWidth))
                    path.addRect(correctedFrame)
                }
                .fill(style: .init(eoFill: true))
            }
            // Setting this frame is important to force the view to draw. If `content` size is too
            // close to zero, that same size will be adopted by this view through the overlay, and
            // nothing in the view will draw, including paths larger that the view. This frame prevents
            // the size of this view from reaching the minimum known size for getting drawn.
            .frame(size: correctedFrame.size)
    }


    @ViewBuilder
    private func innerStrokeRect(geometry: GeometryProxy) -> some View {
        let boundedLineWidth = newOptions.lineWidth.clamped(to: Self.minLineWidth...)
        // When debugged view is smaller that `lineWidth*2` the lineWidth used is reduced allow
        // it to draw at smaller sizes, otherwise no inner stroke is drawn.
        let correctedLineWidth = min(geometry.size.min, boundedLineWidth * 2) / 2.0

        let strokeStyle = StrokeStyle(
            lineWidth: correctedLineWidth,
            dash: [boundedLineWidth * 3, boundedLineWidth * 2]
        )

        Rectangle()
            .strokeBorder(innerShapeStyle, style: strokeStyle)
    }


    @ViewBuilder
    private func originReticuleRects(geometry: GeometryProxy) -> some View {
        let thickness: CGFloat = 1
        let boundedLength = newOptions.lineWidth.clamped(to: Self.minReticuleLength...)
        // +thickness to correctly center the reticule, specially at very small sizes.
        let reticuleLength = (boundedLength * 2) + thickness

        Rectangle()
            .fill(.red)
            .frame(width: thickness, height: reticuleLength)
            .offset(y: -boundedLength)
        Rectangle()
            .fill(.red)
            .frame(width: reticuleLength, height: thickness)
            .offset(x: -boundedLength)
    }


    @ViewBuilder
    private func geometryInfoView(_ geometry: GeometryProxy) -> some View {
        if !oldOptions.isEmpty {
            let boundedLineWidth = newOptions.lineWidth.clamped(to: Self.minLineWidth...)

            let infoTextGroup = Group {
                let globalFrame = geometry.frame(in: .global)
                let fractionLength: FloatingPointFormatStyle<Double> = .fractionLength(2)

                if oldOptions.contains(.size) {
                    let formattedWidth = globalFrame.width.formatted(fractionLength)
                    let formattedHeight = globalFrame.height.formatted(fractionLength)
                    Text("size: \(formattedWidth), \(formattedHeight)")
                }

                if oldOptions.contains(.origin) {
                    let formattedX = globalFrame.origin.x.formatted(fractionLength)
                    let formattedY = globalFrame.origin.y.formatted(fractionLength)
                    Text("orig: \(formattedX), \(formattedY)")
                }

                if oldOptions.contains(.safeAreaInsets) {
                    Text("safeInsets:\n\(geometry.safeAreaInsets, format: .previewPrintout)")
                        .multilineTextAlignment(newOptions.infoPosition.textAlignment)
                }
            } // Group

            switch newOptions.infoPosition {
            case .inner(let innerAlignment):
                VStack(alignment: innerAlignment.horizontal.swiftAlignment, spacing: 2) {
                    infoTextGroup
                }
                .font(.caption)
                .monospaced()
                .foregroundStyle(.secondary)
                .padding(boundedLineWidth * 1.5)
                .fixedSize()
                .maxSizeFrame(alignment: innerAlignment.swiftAlignment)
                .border(.blue)
            case .outer:
                VStack(alignment: .leading, spacing: 2) {
                    infoTextGroup
                }
                .font(.caption)
                .monospaced()
                .foregroundStyle(.secondary)
                .padding([.top, .leading], boundedLineWidth * 1.5)
                .fixedSize()
                .offset(y: geometry.size.height)
            }
        }
    }


    /// Returns a rectangle that has a width and height of at least `0.5` each. `Rectangle`s and
    /// other views with sizes close to zero may not get drawn.
    ///
    /// Minimum size at which a `Rectangle` is found to be drawn:
    /// + `0.17` in iPhone 17 Pro simulator; however this was found to jump to `0.35` when running
    ///   in the MacBook Pro Retina display, and if might depend on display resolution.
    /// + `0.25` in macOS 26 in preview canvas.
    /// + `0.39` when preview in an iPad Pro 11-inch M4.
    ///
    /// Given the inconsistency, the minimal value of `0.5` was chosen as a compromise.
    private func correctZeroRect(_ rect: CGRect) -> CGRect {
        let minSideLength: Double = 0.5
        var mutableRect = rect
        mutableRect.size.width  = max(minSideLength, rect.width)
        mutableRect.size.height = max(minSideLength, rect.height)
        return mutableRect
    }

}


// MARK: - Options


extension DebugOutlineModifier {

    // TODO: make sure these notes are preserved in other implementation of OptionSet: HeaderFooterPreviewOptions
    // Extends `Sendable` based in other `OptionSet`s present in SwiftUI, like `ContentShapeKinds`
    // and `PinnedScrollableViews`.
    public struct OldOptions: OptionSet, Sendable {
        public let rawValue: Int

        nonisolated public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        // TODO: make sure empty is also defined in HeaderFooterPreviewOptions as example.
        public static let empty: Self =          .init(rawValue: 0)
        public static let size: Self =           .init(shiftedBy: 0)
        public static let origin: Self =         .init(shiftedBy: 1)
        public static let safeAreaInsets: Self = .init(shiftedBy: 2)

        public static let allGeometry: Self = [.size, .origin, .safeAreaInsets]
    }

}


// MARK: - View Extension


extension View {

    /// Adds a debug outline overlay to the view using the default options.
    ///
    /// - Returns: The calling view with an overlay highlighing its frame.
    public func debugOutline() -> some View {
        modifier(DebugOutlineModifier())
    }


    public func debugOutline(_ traits: DebugOutlineModifier.NewOptions.Trait...) -> some View {
        let options = DebugOutlineModifier.NewOptions(traits: traits)
        return modifier(DebugOutlineModifier(newOptions: options))
    }


    /// Adds a debug outline overlay to the view.
    ///
    /// - Parameters:
    ///   - lineWidth: The width of the debug outline strokes. Default is 5, minimum is 1, smaller
    ///       values are ignored.
    ///   - options: Options to enable display of additional information, and other display configurations.
    ///
    /// - Returns: The calling view with an overlay highlighing its frame, and additional information when enabled.
    ///
    /// Example usage:
    /// ```swift
    /// // Hairline outline.
    /// Text("Hello")
    ///     .debugOutline(lineWidth: 1)
    ///
    /// // Outlines along size and origin info.
    /// Text("Hello")
    ///     .debugOutline(options: .size, .origin)
    /// ```
    public func debugOutline(
        lineWidth: CGFloat = 5,
        oldOptions: DebugOutlineModifier.OldOptions...
    ) -> some View {
        modifier(DebugOutlineModifier(lineWidth: lineWidth, oldOptions: oldOptions.union()))
    }



    // TODO: remove oldOptions after transition is done
    public func debugOutline(
        _ traits: DebugOutlineModifier.NewOptions.Trait...,
        oldOptions: DebugOutlineModifier.OldOptions...
    ) -> some View {
        let options = DebugOutlineModifier.NewOptions(traits: traits)
        return modifier(DebugOutlineModifier(newOptions: options, oldOptions: oldOptions.union()))
    }


    // TODO: remove oldOptions after transition is done
    public func debugOutline(
        traits: [DebugOutlineModifier.NewOptions.Trait],
        oldOptions: DebugOutlineModifier.OldOptions...
    ) -> some View {
        let options = DebugOutlineModifier.NewOptions(traits: traits)
        return modifier(DebugOutlineModifier(newOptions: options, oldOptions: oldOptions.union()))
    }

}


// MARK: - EdgeInsetPreviewFormatStyle


struct EdgeInsetPreviewFormatStyle: FormatStyle {

    func format(_ value: EdgeInsets) -> String {
        let fractionLength: FloatingPointFormatStyle<Double> = .fractionLength(2)
        let formattedTop      = value.top.formatted(fractionLength)
        let formattedLeading  = value.leading.formatted(fractionLength)
        let formattedBottom   = value.bottom.formatted(fractionLength)
        let formattedTrailing = value.trailing.formatted(fractionLength)
        return """
            t:\(formattedTop), l:\(formattedLeading)
            b:\(formattedBottom), r:\(formattedTrailing)
            """
    }

}


extension FormatStyle where Self == EdgeInsetPreviewFormatStyle {
    internal static var previewPrintout: EdgeInsetPreviewFormatStyle {
        EdgeInsetPreviewFormatStyle()
    }
}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    static var star: some View {
        StarShape(points: 6, concaveVertexRatio: 0.8)
            .fill(.pink.gradient)
    }

    static var smallText: some View {
        Text("Preview text")
            .monospaced()
    }

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    PreviewContent.star
        .debugOutline()
        .padding(.horizontal)
}


#Preview("Options", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var lineWidth: Double = 10
    @Previewable @State var oldOptions: [(
        label: String,
        option: DebugOutlineModifier.OldOptions,
        enabled: Bool
    )] = [
        ("Size",            .size,           false),
        ("Origin",          .origin,         false),
        ("SafeArea Insets", .safeAreaInsets, false),
        ("All Geometry",    .allGeometry,    true)
    ]
    @Previewable @State var newOptions: [(
        label: String,
        trait: DebugOutlineModifier.NewOptions.Trait,
        enabled: Bool
    )] = [
        ("Info Outside", .outerInfo, false)
    ]

    @Previewable @State var isInnerPosition: Bool = true
    @Previewable @State var innerHorizontalAlignment: DebugOutlineModifier.NewOptions.HorizontalAlignment = .leading
    @Previewable @State var innerVerticalAlignment: DebugOutlineModifier.NewOptions.VerticalAlignment = .top

    let makeTraits: () -> [DebugOutlineModifier.NewOptions.Trait] = {
        var traits: [DebugOutlineModifier.NewOptions.Trait] = newOptions.compactMap { optionTuple in
            let (_, trait, enabled) = optionTuple
            return enabled
                ? trait
                : nil
        }

        let positionTrait: DebugOutlineModifier.NewOptions.Trait = if isInnerPosition {
            .innerInfo(.init(horizontal: innerHorizontalAlignment, vertical: innerVerticalAlignment))
        } else {
            .outerInfo
        }
        traits.append(positionTrait)
        return traits
    }

    let oldOptionsUnion: DebugOutlineModifier.OldOptions = oldOptions.reduce(into: .empty) { result, optionTuple in
        if optionTuple.enabled {
            result.formUnion(optionTuple.option)
        }
    }
    let traits = makeTraits()

    VStack {
        Picker("Position", selection: $isInnerPosition) {
            Text("Inner").tag(true)
            Text("Outer").tag(false)
        }
        .pickerStyle(.segmented)

        if isInnerPosition {
            Picker("Horizontal Alignment", selection: $innerHorizontalAlignment) {
                ForEach(DebugOutlineModifier.NewOptions.HorizontalAlignment.allCases) { alignment in
                    Text(alignment.rawValue.capitalized).tag(alignment)
                }
            }
            .pickerStyle(.segmented)

            Picker("Veertical Alignment", selection: $innerVerticalAlignment) {
                ForEach(DebugOutlineModifier.NewOptions.VerticalAlignment.allCases) { alignment in
                    Text(alignment.rawValue.capitalized).tag(alignment)
                }
            }
            .pickerStyle(.segmented)
        }

        ForEach(oldOptions.enumerated(), id: \.offset) { index, optionTuple in
            Toggle(optionTuple.label, isOn: $oldOptions[index].enabled)
        }
        Divider()
        ForEach(newOptions.enumerated(), id: \.offset) { index, optionTuple in
            Toggle(optionTuple.label, isOn: $newOptions[index].enabled)
        }
        Slider(
            "Line Width",
            value: $lineWidth,
            in: 0...15,
            valueFormat: .arithmeticRoundedInteger)
        Text("Line Width: \(lineWidth, format: .fractionLength(2))")
            .monospaced()
    }
    .padding(.not(.top))

    PreviewContent.star
        .debugOutline(traits: [.lineWidth(lineWidth)] + traits, oldOptions: oldOptionsUnion)
        .padding(.horizontal)
}


#Preview("SafeAreas", traits: .headerFooter(.showDividers), PreviewContent.layout) {
    PreviewContent.star
        .debugOutline(.outerInfo, oldOptions: .allGeometry)
        .safeAreaPadding(.init(
            top:      20,
            leading:  30,
            bottom:   40,
            trailing: 50
        ))
        .border(.gray.tertiary)
        .padding()
}


#Preview("Interactive", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var counter: Int = 0

    Text("Counter: \(counter)")
        .monospaced()
        .padding(.not(.top))

    ZStack(alignment: .topLeading) {
        PreviewContent.star

        Button("Increment", systemImage: "ladybug") {
            counter += 1
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
    .debugOutline(oldOptions: .allGeometry)
    .padding(.horizontal)
}


#Preview("Small content", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var isOuterInfo: Bool = false

    VStack {
        Toggle("Outer Info", isOn: $isOuterInfo)
    }
    .padding()

    PreviewContent.smallText
        .debugOutline(traits: isOuterInfo ? [.outerInfo] : [], oldOptions: .allGeometry)
}


#Preview("Zero size", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var lineWidth: Double = 5
    @Previewable @State var widthIndex: Double = 0.0
    @Previewable @State var heightIndex: Double = 0.0
    @Previewable @State var width: Double = 0.0
    @Previewable @State var height: Double = 0.0

    let values: [Double] = Array(
        [
            stride(from: 0.0, to: 2.0, by: 0.1),
            stride(from: 2.0, to: 16.0, by: 1.0),
            stride(from: 20.0, to: 101.0, by: 10.0)
        ]
        .joined()
    )

    VStack {
        Slider(
            "Line Width",
            value: $lineWidth,
            in: 0...15,
            valueFormat: .arithmeticRoundedInteger)
        Text("Line Width: \(lineWidth, format: .fractionLength(2))")
            .monospaced()

        Slider(
            "Width",
            collection: values,
            value: $widthIndex,
            mapped: $width,
            currentMappedFormat: .fractionLength(1),
            boundsMappedFormat: .fractionLength(1)
        )
        Slider(
            "Height",
            collection: values,
            value: $heightIndex,
            mapped: $height,
            currentMappedFormat: .fractionLength(1),
            boundsMappedFormat: .fractionLength(1)
        )

        Text("Size: \(width, format: .fractionLength(1)),\(height, format: .fractionLength(1))")
            .monospaced()
    }
    .padding()

    PreviewContent.star
        .frame(
            width: width,
            height: height
        )
        .debugOutline(.lineWidth(lineWidth), .outerInfo, oldOptions: .allGeometry)
        .safeAreaPadding(.init(horizontal: 50, vertical: 30))
        .border(.gray.tertiary)
}
