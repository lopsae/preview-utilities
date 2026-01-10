//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Draws in an overlay of the content view a dashed stroke inset in the view border, a outset solid
/// stroke, and rectangles to visualize any safe areas affecting the view. Can also be configured to
/// display additional information like size, origin, and the safe area insets.
public struct DebugOverlayModifier: ViewModifier {

    /// The line width is limited to minimum of 1 so that there is always a visual overlay even on
    /// zero sizes. Smaller values are ignored.
    private static let minLineWidth: CGFloat = 1
    private static let minReticuleLength: CGFloat = 2

    private static let outerShapeStyle:     some ShapeStyle = .blue.tertiary
    private static let innerShapeStyle:     some ShapeStyle = .red.tertiary
    private static let safeAreasShapeStyle: some ShapeStyle = .green.tertiary

    let configuration: Configuration


    /// Creates a modifier with the given configuration.
    init(configuration: Configuration) {
        self.configuration = configuration
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
        let boundedLineWidth = configuration.lineWidth.clamped(to: Self.minLineWidth...)

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
                .fill(Self.safeAreasShapeStyle)
                .frame(width: minWidth, height: topInset)
                .offset(x: xOffset, y: -topInset)
        }
        // Leading.
        if leadingInset != 0 {
            Rectangle()
                .fill(Self.safeAreasShapeStyle)
                .frame(width: leadingInset, height: minHeight)
                .offset(x: -leadingInset, y: yOffset)
        }
        // Bottom.
        if bottomInset != 0 {
            Rectangle()
                .fill(Self.safeAreasShapeStyle)
                .frame(width: minWidth, height: bottomInset)
                .offset(x: xOffset, y: size.height)
        }

        // Trailing.
        if trailingInset != 0 {
            Rectangle()
                .fill(Self.safeAreasShapeStyle)
                .frame(width: trailingInset, height: minHeight)
                .offset(x: size.width, y: yOffset)
        }
    }


    @ViewBuilder
    private func outerStrokeRect(geometry: GeometryProxy) -> some View {
        let localFrame = geometry.frame(in: .local)
        let correctedFrame = correctZeroRect(localFrame)
        let boundedLineWidth = configuration.lineWidth.clamped(to: Self.minLineWidth...)

        Rectangle()
            .stroke(Self.outerShapeStyle, lineWidth: boundedLineWidth * 2)
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
        let boundedLineWidth = configuration.lineWidth.clamped(to: Self.minLineWidth...)
        // When debugged view is smaller that `lineWidth*2` the lineWidth used is reduced allow
        // it to draw at smaller sizes, otherwise no inner stroke is drawn.
        let correctedLineWidth = min(geometry.size.min, boundedLineWidth * 2) / 2.0

        let strokeStyle = StrokeStyle(
            lineWidth: correctedLineWidth,
            dash: [boundedLineWidth * 3, boundedLineWidth * 2]
        )

        Rectangle()
            .strokeBorder(Self.innerShapeStyle, style: strokeStyle)
    }


    @ViewBuilder
    private func originReticuleRects(geometry: GeometryProxy) -> some View {
        let thickness: CGFloat = 1
        let boundedLength = configuration.lineWidth.clamped(to: Self.minReticuleLength...)
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
        if !configuration.infoElements.isEmpty {
            let boundedLineWidth = configuration.lineWidth.clamped(to: Self.minLineWidth...)

            let infoTextGroup = Group {
                let globalFrame = geometry.frame(in: .global)
                let fractionLength: FloatingPointFormatStyle<Double> = .fractionLength(2)

                // Width, Height, or Size.
                if configuration.infoElements.contains(.size) {
                    let formattedWidth = globalFrame.width.formatted(fractionLength)
                    let formattedHeight = globalFrame.height.formatted(fractionLength)
                    Text("size: \(formattedWidth), \(formattedHeight)")
                } else if configuration.infoElements.contains(.width) {
                    let formattedWidth = globalFrame.width.formatted(fractionLength)
                    Text("width: \(formattedWidth)")
                } else if configuration.infoElements.contains(.height) {
                    let formattedHeight = globalFrame.height.formatted(fractionLength)
                    Text("height: \(formattedHeight)")
                }

                // Origin.
                if configuration.infoElements.contains(.origin) {
                    let formattedX = globalFrame.origin.x.formatted(fractionLength)
                    let formattedY = globalFrame.origin.y.formatted(fractionLength)
                    Text("origin: \(formattedX), \(formattedY)")
                }

                // SafeAreaInsets.
                if configuration.infoElements.contains(.safeAreaInsets) {
                    Text("safeAreaInsets:\n\(geometry.safeAreaInsets, format: .previewPrintout)")
                        .multilineTextAlignment(configuration.infoPosition.textAlignment)
                }
            } // Group

            switch configuration.infoPosition {
            case .inner(let innerAlignment):
                VStack(alignment: innerAlignment.horizontal.swiftAlignment, spacing: 2) {
                    infoTextGroup
                }
                .font(.caption)
                .monospaced()
                .foregroundStyle(.secondary)
                .padding(boundedLineWidth * 1.5)
                // Prevents info view from collapsing in small sizes.
                .fixedSize()
                // Centers the view based in the alignment even when the frame is smaller that the view.
                .frame(size: geometry.size, alignment: innerAlignment.swiftAlignment)

            case .outer(let outerAlignment):
                // TODO: Dry!
                let yOffset: CGFloat = switch outerAlignment {
                case .top:    -geometry.size.height
                case .bottom: geometry.size.height
                case .leading(let outerVerticalAlignment), .trailing(let outerVerticalAlignment):
                    switch outerVerticalAlignment {
                    case .above:
                        -geometry.size.height
                    case .top, .center, .bottom:
                            .zero
                    case .below:
                        geometry.size.height
                    }

                }

                let xOffset: CGFloat = switch outerAlignment {
                case .leading:  -geometry.size.width
                case .trailing: geometry.size.width
                case .top, .bottom: .zero
                }

                // TODO: better name? textContainer? VStackAlignment?
                VStack(alignment: outerAlignment.containerHorizontal.swiftAlignment, spacing: 2) {
                    infoTextGroup
                }
                .font(.caption)
                .monospaced()
                .foregroundStyle(.secondary)
                // TODO: padding should be selective of alignment
                .padding(boundedLineWidth * 1.5)
                // Prevents info view from collapsing in small sizes.
                .fixedSize()
                .border(.red)
                // Centers the view based in the alignment even when the frame is smaller that the view.
                .frame(size: geometry.size, alignment: outerAlignment.frameAlignment)
                .border(.green)
                .offset(x: xOffset, y: yOffset)
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


// MARK: - View Extension


extension View {

    /// Layers in front of this view a debug overlay using the default configuration.
    ///
    /// - Returns: A view with a debug overlay as foreground.
    public func debugOverlay() -> some View {
        let configuration = DebugOverlayModifier.Configuration()
        return modifier(DebugOverlayModifier(configuration: configuration))
    }


    /// Layers in front of this view a debug overlay configured using the given traits.
    ///
    /// - Parameters:
    ///   - traits: The traits to modify the default configuration.
    ///
    /// - Returns: A view with a configured debug overlay as foreground.
    /// 
    /// Example usage:
    /// ```swift
    /// // Hairline outline.
    /// Text("Hello")
    ///     .debugOutline(.hairline)
    ///
    /// // Outlines along size and origin info.
    /// Text("Hello")
    ///     .debugOutline(.size, .origin)
    /// ```
    public func debugOverlay(_ traits: DebugOverlayModifier.Configuration.Trait...) -> some View {
        let configuration = DebugOverlayModifier.Configuration(traits: traits)
        return modifier(DebugOverlayModifier(configuration: configuration))
    }


    /// Layers in front of this view a debug overlay configured using the given traits.
    ///
    /// - Parameters:
    ///   - traits: The traits to modify the default configuration.
    ///
    /// - Returns: A view with a configured debug overlay as foreground.
    public func debugOverlay(
        traits: [DebugOverlayModifier.Configuration.Trait],
    ) -> some View {
        let configuration = DebugOverlayModifier.Configuration(traits: traits)
        return modifier(DebugOverlayModifier(configuration: configuration))
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

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    PreviewContent.star
        .debugOverlay()
        .padding(.horizontal)
}


#Preview("Configuration", traits: .headerFooter(.fixed), PreviewContent.layout) {
    @Previewable @State var useSmallContent: Bool = false
    @Previewable @State var lineWidth: Double = 5
    @Previewable @State var traitOptions: [(
        label: String,
        trait: DebugOverlayModifier.Configuration.Trait,
        enabled: Bool
    )] = [
        ("Width",           .width,          true),
        ("Height",          .height,         false),
        ("Origin",          .origin,         false),
        ("SafeArea Insets", .safeAreaInsets, false),
        ("All Geometry",    .allGeometry,    false)
    ]

    @Previewable @State var positionKey: DebugOverlayModifier.Configuration.InfoPosition.Key = .outer
    @Previewable @State var innerHorizontalAlignment: DebugOverlayModifier.Configuration.HorizontalAlignment = .trailing
    @Previewable @State var innerVerticalAlignment: DebugOverlayModifier.Configuration.VerticalAlignment = .center

    @Previewable @State var outerMayorAlignment: DebugOverlayModifier.Configuration.OuterAlignment.Key = .leading
    @Previewable @State var outerMinorHorizontalAlignment: DebugOverlayModifier.Configuration.HorizontalAlignment = .leading
    @Previewable @State var outerMinorVerticalAlignment: DebugOverlayModifier.Configuration.OuterVerticalAlignment = .above

    let makeTraits: () -> [DebugOverlayModifier.Configuration.Trait] = {
        var traits: [DebugOverlayModifier.Configuration.Trait] = [.lineWidth(lineWidth)]

        traits += traitOptions.compactMap { traitTuple in
            return traitTuple.enabled
                ? traitTuple.trait
                : nil
        }

        let positionTrait: DebugOverlayModifier.Configuration.Trait
        switch positionKey {
        case .inner:
            positionTrait = .innerInfo(.init(horizontal: innerHorizontalAlignment, vertical: innerVerticalAlignment))
        case .outer:
            let outerAlignment: DebugOverlayModifier.Configuration.OuterAlignment = switch outerMayorAlignment {
            case .top:      .top(     outerMinorHorizontalAlignment)
            case .bottom:   .bottom(  outerMinorHorizontalAlignment)
            case .leading:  .leading( outerMinorVerticalAlignment)
            case .trailing: .trailing(outerMinorVerticalAlignment)
            }
            positionTrait = .outerInfo(outerAlignment)
        }
        traits.append(positionTrait)
        return traits
    }

    let traits = makeTraits()

    VStack {
        Picker("Position", selection: $positionKey, caseFormat: .rawValueCapitalized())
            .pickerStyle(.segmented)

        switch positionKey {
        case .inner:
            Picker("Horizontal Alignment", selection: $innerHorizontalAlignment, caseFormat: .rawValueCapitalized())
                .pickerStyle(.segmented)
            Picker("Vertical Alignment", selection: $innerVerticalAlignment, caseFormat: .rawValueCapitalized())
                .pickerStyle(.segmented)

        case .outer:
            Picker("Outer Mayor Alignment", selection: $outerMayorAlignment, caseFormat: .rawValueCapitalized())
                .pickerStyle(.segmented)

            switch outerMayorAlignment {
            case .top, .bottom:
                Picker("Horizontal Minor Alignment", selection: $outerMinorHorizontalAlignment, caseFormat: .rawValueCapitalized())
                    .pickerStyle(.segmented)
            case .leading, .trailing:
                Picker("Vertical Minor Alignment", selection: $outerMinorVerticalAlignment, caseFormat: .rawValueCapitalized())
                    .pickerStyle(.segmented)
            }
        }

        ForEach(traitOptions.enumerated(), id: \.offset) { index, optionTuple in
            Toggle(optionTuple.label, isOn: $traitOptions[index].enabled)
        }

        Slider(
            "Line Width",
            value: $lineWidth,
            in: 0...15,
            valueFormat: .arithmeticRoundedInteger)
        Text("Line Width: \(lineWidth, format: .fractionLength(2))")
            .font(.caption.monospaced())

        Toggle("Use Small Content", isOn: $useSmallContent)
    }
    .padding(.not(.top))

    if useSmallContent {
        Rectangle().fill(.gray.tertiary)
            .frame(width: 100)
            .previewCaption("Spacer")
        Text("Preview text")
            .foregroundStyle(.quaternary)
            .monospaced()
            .debugOverlay(traits: traits)
            .safeAreaPadding(20)
        Rectangle().fill(.gray.tertiary)
            .frame(width: 100)
            .previewCaption("Spacer")
    } else {
        PreviewContent.star
            .debugOverlay(traits: traits)
            .safeAreaPadding(.horizontal, 100)
            .safeAreaPadding(.vertical, 40)
            .padding(.horizontal)
    }

}


#Preview("SafeAreas", traits: .headerFooter(.showDividers), PreviewContent.layout) {
    PreviewContent.star
        .debugOverlay(.allGeometry, .outerInfo)
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
    .debugOverlay(.allGeometry)
    .padding(.horizontal)
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
        .debugOverlay(.lineWidth(lineWidth), .allGeometry, .outerInfo)
        .safeAreaPadding(.init(horizontal: 50, vertical: 30))
        .border(.gray.tertiary)
}
