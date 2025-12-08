//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Adds a debug overlay that draws a dashed stroke inset in the views border, and a solid stroke
/// outset of the view border.
public struct DebugOutlineModifier: ViewModifier {

    let lineWidth: CGFloat
    let options: Options

    let outerShapeStyle:     some ShapeStyle = .blue.tertiary
    let innerShapeStyle:     some ShapeStyle = .red.tertiary
    let safeAreasShapeStyle: some ShapeStyle = .green.tertiary


    init(lineWidth: CGFloat = 5, options: Options = []) {
        self.lineWidth = lineWidth
        self.options = options
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
        let localFrame = geometry.frame(in: .local)

        // When the view is smaller that `lineWidth*2` the safe areas are still drawn with a
        // thickness of `lineWidth*2` to remain visible, and offset to stay centered with the
        // origin.
        let minimumRect = CGSize(square: lineWidth * 2).centered(in: localFrame)
        let xOffset = min(0.0, minimumRect.origin.x)
        let yOffset = min(0.0, minimumRect.origin.y)

        let minWidth  = max(lineWidth * 2, localFrame.width)
        let minHeight = max(lineWidth * 2, localFrame.height)

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
                .offset(x: xOffset, y: localFrame.height)
        }

        // Trailing.
        if trailingInset != 0 {
            Rectangle()
                .fill(safeAreasShapeStyle)
                .frame(width: trailingInset, height: minHeight)
                .offset(x: localFrame.width, y: yOffset)
        }
    }


    @ViewBuilder
    private func outerStrokeRect(geometry: GeometryProxy) -> some View {
        let localFrame = geometry.frame(in: .local)
        var correctedFrame = correctZeroRect(localFrame)

        Rectangle()
            .stroke(outerShapeStyle, lineWidth: lineWidth * 2)
            .mask {
                Path { path in
                    path.addRect(correctedFrame.inset(by: -lineWidth))
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
        let strokeStyle = StrokeStyle(
            lineWidth: lineWidth,
            dash: [lineWidth * 3, lineWidth * 2]
        )
        return Rectangle()
            .strokeBorder(innerShapeStyle, style: strokeStyle)
    }


    @ViewBuilder
    private func originReticuleRects(geometry: GeometryProxy) -> some View {
        Rectangle()
            .fill(.red)
            .frame(width: 1, height: lineWidth * 2)
            .offset(y: -lineWidth)
        Rectangle()
            .fill(.red)
            .frame(width: lineWidth * 2, height: 1)
            .offset(x: -lineWidth)
    }


    @ViewBuilder
    private func geometryInfoView(_ geometry: GeometryProxy) -> some View {
        if !options.isEmpty {
            let stackOffset = options.contains(.infoOutside)
                ? geometry.size.height
                : 0

            VStack(alignment: .leading, spacing: 2) {
                let globalFrame = geometry.frame(in: .global)
                let doubleFormat: FloatingPointFormatStyle<Double> = .number.precision(.fractionLength(2))

                if options.contains(.size) {
                    let formattedWidth = globalFrame.width.formatted(doubleFormat)
                    let formattedHeight = globalFrame.height.formatted(doubleFormat)
                    Text("size: \(formattedWidth), \(formattedHeight)")
                }
                
                if options.contains(.origin) {
                    let formattedX = globalFrame.origin.x.formatted(doubleFormat)
                    let formattedY = globalFrame.origin.y.formatted(doubleFormat)
                    Text("orig: \(formattedX), \(formattedY)")
                }
                
                if options.contains(.safeAreaInsets) {
                    Text("safeInsets:\n\(geometry.safeAreaInsets, format: .previewPrintout)")
                }
            } // VStack
            .font(.caption)
            .monospaced()
            .foregroundStyle(.secondary)
            .padding([.top, .leading], lineWidth * 1.5)
            .fixedSize()
            .offset(y: stackOffset)
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


extension DebugOutlineModifier {

    // Extends `Sendable` based in other `OptionSet`s present in SwiftUI, like `ContentShapeKinds`
    // and `PinnedScrollableViews`.
    public struct Options: OptionSet, Sendable {
        public let rawValue: Int

        nonisolated public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let empty: Self =          .init(rawValue: 0)
        public static let size: Self =           .init(shiftedBy: 0)
        public static let origin: Self =         .init(shiftedBy: 1)
        public static let safeAreaInsets: Self = .init(shiftedBy: 2)
        public static let infoOutside: Self =    .init(shiftedBy: 3)

        public static let allGeometry: Self = [.size, .origin, .safeAreaInsets]
    }

}


extension View {

    /// Adds a debug outline overlay to the view.
    ///
    /// - Parameters:
    ///   - lineWidth: The width of the debug outline strokes. Default is 5.
    ///   - options: Options to enable display of additional information, and other display configurations.
    ///
    /// - Returns: The calling view with an overlay highlighing its frame, and additional information when enabled.
    ///
    /// Example usage:
    /// ```swift
    /// // Only outlines.
    /// Text("Hello")
    ///     .debugOutline()
    ///
    /// // Outlines along size and origin info
    /// Text("Hello")
    ///     .debugOutline(options: .size, .origin)
    /// ```
    public func debugOutline(
        lineWidth: CGFloat = 5,
        options: DebugOutlineModifier.Options...
    ) -> some View {
        modifier(DebugOutlineModifier(lineWidth: lineWidth, options: options.union()))
    }

}


// MARK: - EdgeInsetPreviewFormatStyle


struct EdgeInsetPreviewFormatStyle: FormatStyle {

    func format(_ value: EdgeInsets) -> String {
        let doubleFormat: FloatingPointFormatStyle<Double> = .number.precision(.fractionLength(2))
        let formattedTop      = value.top.formatted(doubleFormat)
        let formattedLeading  = value.leading.formatted(doubleFormat)
        let formattedBottom   = value.bottom.formatted(doubleFormat)
        let formattedTrailing = value.trailing.formatted(doubleFormat)
        return "t:\(formattedTop), l:\(formattedLeading),\nb:\(formattedBottom), r:\(formattedTrailing)"
    }

}


extension FormatStyle where Self == EdgeInsetPreviewFormatStyle {
    internal static var previewPrintout: EdgeInsetPreviewFormatStyle {
        EdgeInsetPreviewFormatStyle()
    }
}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    // TODO: Rename to layout, search for other private struct PreviewContent
    static let previewLayout: PreviewTrait<Preview.ViewTraits> = .fixedLayout(width: 400, height: 800)

    static var star: some View {
        StarShape(points: 6, concaveVertexRatio: 0.8)
            .fill(.pink)
    }

    static var smallText: some View {
        Text("Preview text")
            .monospaced()
    }

}


#Preview("Default", traits: .headerFooter, PreviewContent.previewLayout) {
    PreviewContent.star
        .debugOutline()
}


#Preview("All geometry", traits: .headerFooter, PreviewContent.previewLayout) {
    PreviewContent.star
        .debugOutline(options: .allGeometry)
}


#Preview("Size only", traits: .headerFooter, PreviewContent.previewLayout) {
    PreviewContent.star
        .debugOutline(options: .size)
}


#Preview("Size and origin", traits: .headerFooter, PreviewContent.previewLayout) {
    PreviewContent.star
        .debugOutline(options: .size, .origin)
}


#Preview("Info outside", traits: .headerFooter, PreviewContent.previewLayout) {
    PreviewContent.star
        .debugOutline(options: .allGeometry, .infoOutside)
}


#Preview("SafeAreas", traits: .headerFooter(.showDividers), PreviewContent.previewLayout) {
    PreviewContent.star
        .debugOutline(options: .allGeometry, .infoOutside)
        .safeAreaPadding(.top,      20)
        .safeAreaPadding(.leading,  30)
        .safeAreaPadding(.bottom,   40)
        .safeAreaPadding(.trailing, 50)
        .border(.gray.tertiary, width: 1)
        .padding()
}


#Preview("Interactive", traits: .headerFooter, PreviewContent.previewLayout) {
    @Previewable @State var counter: Int = 0
    ZStack(alignment: .topLeading) {
        PreviewContent.star

        Button("Increment", systemImage: "ladybug") {
            counter += 1
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
    .debugOutline(options: .allGeometry)
    Text("Counter: \(counter)")
        .monospaced()
        .padding()
}


#Preview("Small content", traits: .fixedHeader, PreviewContent.previewLayout) {
    @Previewable @State var isInfoOutside: Bool = false

    VStack {
        Toggle("Info Outside", isOn: $isInfoOutside)
    }
    .padding()

    let options = DebugOutlineModifier.Options.allGeometry.union(
        isInfoOutside ? .infoOutside : .empty
    )
    PreviewContent.smallText
        .debugOutline(options: options)
}


// TODO: inner stroke seems to also dissapear when size gets smaller that 5
#Preview("Zero size", traits: .fixedHeader, PreviewContent.previewLayout) {
    @Previewable @State var widthIndex: Double = 0.0
    @Previewable @State var heightIndex: Double = 0.0

    let values: [Double] = Array(
        [
            stride(from: 0.0, to: 1.0, by: 0.1),
            stride(from: 1.0, to: 16.0, by: 1.0),
            stride(from: 20.0, to: 101.0, by: 10.0)
        ].joined()
    )

    var sliderRange: ClosedRange<Double> { values.startIndex.asDouble...values.beforeEndIndex.asDouble }
    var width: Double { values[widthIndex.rounded(.toNearestOrEven).asInt] }
    var height: Double { values[heightIndex.rounded(.toNearestOrEven).asInt] }

    VStack {
        Slider(
            value: $widthIndex,
            in: sliderRange,
            step: 1.0) {
                Text("Width")
            }
        Slider(
            value: $heightIndex,
            in: sliderRange,
            step: 1.0) {
                Text("Width")
            }

        Text("Size: \(width, format: .fractionLength(1)),\(height, format: .fractionLength(1))")
            .monospaced()
    }
    .padding()

    Rectangle()
        .fill(.teal)
        .frame(
            width: width,
            height: height
        )
        .debugOutline(options: .allGeometry)
        .safeAreaPadding(30)
        .border(.gray.opacity(0.5), width: 1.0)
}
