//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Overlays a visual representations of a view's boundaries, origin, and safe areas.
///
/// Displays in an overlay a visual representation of a view's boundaries, its origin point, and any
/// applied safe area insets. The overlay can be configured to also display geometry information
/// like size, global origin coordinates, safe area insets, or a given text caption.
///
/// All content added by this modifier is layered in an overlay of the parent view, the original
/// layout is never modified.
///
/// Apply this modifier using ``SwiftUICore/View/debugOverlay()``:
///
/// ```swift
/// Text("Sphinx of Black Quartz")
///    .font(.title)
/// Text("Judge my Vow")
///     .font(.title)
///     .debugOverlay()
/// ```
/// ![Debug overlay with default configuration.](debug-overlay-default)
///
///
/// ### Traits and Configuration
///
/// The overlay can be configured by passing [`Trait`](doc:Configuration/Trait) instances to
/// ``SwiftUICore/View/debugOverlay(_:)``:
///
/// ```swift
/// Rectangle()
/// .fill(.yellow.gradient.secondary)
/// .frame(width: 200, height: 80)
/// .debugOverlay(
///     .size,                     // prints the size of the parent view
///     .bordersWidth(2),          // sets debug borders width to 2
///     .alignment(.innerTrailing) // aligns caption to trailing-center
/// )
/// ```
/// ![Debug overlay using traits.](debug-overlay-simple-traits)
///
///
/// ### Visual Components
///
/// The boundaries of the parent view are visualized using two strokes: a dashed inner stroke (by
/// default red) drawn inset of the view's boundaries, and a solid outer stroke (by default blue)
/// drawn outside. A cross `+` marks the origin point, and green rectangles represent safe area
/// insets applied to the view.
///
/// ![Visual components of the debug overlay.](debug-overlay-components)
///
///
/// ### Caption Alignment
///
/// The overlay uses ``FloatingAlignment`` to determine the position of the debug caption,
/// supporting positions both inside and outside of the parent view. When an ``FloatingAlignment/OuterAlignment``
/// is used, the space occupied by the parent view does not change, even if the caption is
/// displayed outside of its boundaries:
/// ```swift
/// HStack(spacing: 16) {
///     Rectangle()
///         .fill(.green.gradient)
///         .frame(width: 100, height: 60)
///         .debugOverlay(.caption("Inner Top"), .alignment(.innerTop))
///     Rectangle()
///         .fill(.mint.gradient)
///         .frame(width: 100, height: 60)
///         .debugOverlay(.caption("Outer Bottom\nLeading"), .alignment(.outerBottomLeading))
///     Rectangle()
///         .fill(.teal.gradient)
///         .frame(width: 100, height: 60)
///         .debugOverlay(.caption("Outer Top\nTrailing"), .alignment(.outerTopTrailing))
/// }
/// ```
/// ![Debug overlay example alignments.](debug-overlay-alignments)
///
public struct DebugOverlayModifier: ViewModifier {

    /// Minimum limit for the border width. Ensures there is always a visual overlay even on sizes
    /// approaching zero. Smaller values are overridden with the minimum.
    private static let minBordersWidth: CGFloat = 1

    /// Minimum limit for the reticule length. Ensures there is always a visual reticule even on
    /// sizes approaching zero. Smaller values are overridden with the minimum.
    private static let minReticuleLength: CGFloat = 2


    @Environment(\.colorScheme) private var colorScheme

    let configuration: Configuration


    /// Creates a modifier with the given configuration.
    init(configuration: Configuration) {
        self.configuration = configuration
    }


    @_documentation(visibility: internal)
    public func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { geometry in
                safeAreaRects(geometry: geometry)
                if configuration.areBordersEnabled {
                    outerStrokeRect(geometry: geometry)
                    innerStrokeRect(geometry: geometry)
                }
                originReticuleRects(geometry: geometry)
                debugCaptionView(geometry)
            }
            .opacity(configuration.isVisible ? .one : .zero)
            .allowsHitTesting(false)
        }
    }


    // MARK: Safe Area Rects

    @ViewBuilder
    private func safeAreaRects(geometry: GeometryProxy) -> some View {
        let size = geometry.size
        let boundedBordersWidth = configuration.bordersWidth.clamped(to: Self.minBordersWidth...)

        // When content view is smaller that `bordersWidth*2` the safe areas are still drawn with a
        // thickness of `bordersWidth*2` to remain visible, and offset to stay centered with the
        // origin.
        let minimumRect = CGSize(squareOf: boundedBordersWidth * 2).centered(in: size)
        let xOffset = min(.zero, minimumRect.origin.x)
        let yOffset = min(.zero, minimumRect.origin.y)

        let minWidth  = max(boundedBordersWidth * 2, size.width)
        let minHeight = max(boundedBordersWidth * 2, size.height)

        let topInset      = geometry.safeAreaInsets.top
        let leadingInset  = geometry.safeAreaInsets.leading
        let bottomInset   = geometry.safeAreaInsets.bottom
        let trailingInset = geometry.safeAreaInsets.trailing

        let fillShapeStyle = safeAreasShapeStyle

        // Top.
        if topInset != .zero {
            Rectangle()
                .fill(fillShapeStyle)
                .frame(width: minWidth, height: topInset)
                .offset(x: xOffset, y: -topInset)
        }
        // Leading.
        if leadingInset != .zero {
            Rectangle()
                .fill(fillShapeStyle)
                .frame(width: leadingInset, height: minHeight)
                .offset(x: -leadingInset, y: yOffset)
        }
        // Bottom.
        if bottomInset != .zero {
            Rectangle()
                .fill(fillShapeStyle)
                .frame(width: minWidth, height: bottomInset)
                .offset(x: xOffset, y: size.height)
        }

        // Trailing.
        if trailingInset != .zero {
            Rectangle()
                .fill(fillShapeStyle)
                .frame(width: trailingInset, height: minHeight)
                .offset(x: size.width, y: yOffset)
        }
    }


    // MARK: Outer Stroke

    @ViewBuilder
    private func outerStrokeRect(geometry: GeometryProxy) -> some View {
        let localFrame = geometry.frame(in: .local)
        let correctedFrame = correctZeroRect(localFrame)
        let boundedBordersWidth = configuration.bordersWidth.clamped(to: Self.minBordersWidth...)

        Rectangle()
            // Stroke draws over the view's boundary, half inside half outside.
            // Drawn with double width and masked to remove the inner half.
            .inset(by: -boundedBordersWidth/2)
            .stroke(outerStrokeShapeStyle, lineWidth: boundedBordersWidth)
            // Setting this frame is important to force the view to draw. If `content` size is too
            // close to zero, that same size will be adopted by this view through the overlay, and
            // nothing in the view will draw, including paths larger that the view. This frame prevents
            // the size of this view from reaching the minimum known size for getting drawn.
            .frame(size: correctedFrame.size)
    }


    // MARK: Inner Stroke

    @ViewBuilder
    private func innerStrokeRect(geometry: GeometryProxy) -> some View {
        let boundedBordersWidth = configuration.bordersWidth.clamped(to: Self.minBordersWidth...)
        // When content view is smaller that `bordersWidth*2` the lineWidth used is reduced to
        // allow drawing at smaller sizes, otherwise strokes smaller that half the half the side
        // of the rectangle are NOT drawn.
        let correctedLineWidth = min(geometry.size.min, boundedBordersWidth * 2) / 2.0

        let strokeStyle = StrokeStyle(
            lineWidth: correctedLineWidth,
            dash: [boundedBordersWidth * 3, boundedBordersWidth * 2]
        )

        Rectangle()
            // Stroke border draws an inset stroke.
            .strokeBorder(innerStrokeShapeStyle, style: strokeStyle)
    }


    // MARK: Origin Reticule

    @ViewBuilder
    private func originReticuleRects(geometry: GeometryProxy) -> some View {
        let thickness: CGFloat = 1
        let boundedLength = configuration.bordersWidth.clamped(to: Self.minReticuleLength...)
        // `+ thickness` to correctly center the reticule, specially at very small sizes.
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


    // MARK: Debug Caption

    @ViewBuilder
    private func debugCaptionView(_ geometry: GeometryProxy) -> some View {
        if configuration.containsInfoCaptionElements {

            let spacing = captionSpacing
            FloatingAlignedContainer(
                alignment: configuration.infoAlignment,
                horizontalSpacing: spacing.width,
                verticalSpacing: spacing.height,
            ) { alignments in
                // Spacing derived from the contained Text elements, which so far works well.
                VStack(alignment: alignments.content.horizontal) {
                    let globalFrame = geometry.frame(in: .global)
                    let fractionLength: FloatingPointFormatStyle<Double> = .fractionLength(2)

                    // Caption.
                    switch configuration.captionSource {
                    case .localizedKey(let localizedStringKey):
                        Text(localizedStringKey)
                        .font(.caption)
                        .multilineTextAlignment(alignments.text)
                    case .verbatim(let string):
                        Text(verbatim: string)
                        .font(.caption)
                        .multilineTextAlignment(alignments.text)
                    case .none:
                        EmptyView()
                    }

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
                        .multilineTextAlignment(alignments.text)
                    }
                } // Group
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
                .fixedSize()
                // FIXME: Add captionBorder as trait.
                .border(configuration.drawsCaptionBorder ? AnyShapeStyle(.secondary) : AnyShapeStyle(.clear))
            }// FloatingAlignedContainer
        } // if
    }


    /// Returns a rectangle that has a width and height of at least `0.5` each. `Rectangle`s and
    /// other views with sizes close to zero may not get drawn.
    ///
    /// Minimum size at which a `Rectangle` is found to be drawn:
    /// + `0.17` in iPhone 17 Pro simulator; however this was found to jump to `0.35` when running
    ///   in the MacBook Pro Retina display, and it might depend on display resolution.
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


    private var captionSpacing: CGSize {
        let boundedBordersWidth = configuration.bordersWidth.clamped(to: Self.minBordersWidth...)

        // At most, the caption sits 4 points away from the borders.
        let maxSpacingFromBoundary = boundedBordersWidth + 4
        // At smaller sizes, the spacing is reduced along the borders width,
        // with a different ratio for each axis.
        let horizontalSpacingFromBoundary = (boundedBordersWidth * 2.0).clamped(to: ...maxSpacingFromBoundary)
        let verticalSpacingFromBoundary = (boundedBordersWidth * 1.2).clamped(to: ...maxSpacingFromBoundary)

        var horizontalSpacing = horizontalSpacingFromBoundary
        var verticalSpacing = verticalSpacingFromBoundary

        if let outerAlignment = configuration.infoAlignment.outerAlignment {
            // For outer alignment with top/bottom major, the caption is always aligned 2 points
            // from the edge of the content. Otherwise it looks misaligned.
            if outerAlignment.key.isEqual(toAny: .top, .bottom) {
                horizontalSpacing = 2
            }
            // For outer alignment with leading/trailing major, and top-or-bottom minor, the caption
            // is aligned to the edge of the content. Otherwise it looks misaligned.
            if outerAlignment.outerVerticalComponent?.isEqual(toAny: .top, .bottom) ?? false {
                verticalSpacing = 0
            }
        }
        return CGSize(width: horizontalSpacing, height: verticalSpacing)
    }


    // MARK: Fill Styles

    private var safeAreasShapeStyle: AnyShapeStyle {
        let shapeStyle: any ShapeStyle = switch colorScheme {
        case .light:      .green.tertiary
        case .dark:       .green.secondary
        @unknown default: .green.tertiary
        }
        return AnyShapeStyle(shapeStyle)
    }


    private var outerStrokeShapeStyle: AnyShapeStyle {
        let shapeStyle: any ShapeStyle = switch colorScheme {
        case .light:      .blue.tertiary
        case .dark:       .blue.secondary
        @unknown default: .blue.tertiary
        }
        return AnyShapeStyle(shapeStyle)
    }


    private var innerStrokeShapeStyle: AnyShapeStyle {
        let shapeStyle: any ShapeStyle = switch colorScheme {
        case .light:      .red.tertiary
        case .dark:       .red.secondary
        @unknown default: .red.tertiary
        }
        return AnyShapeStyle(shapeStyle)
    }

}


// MARK: - View Extension


extension View {

    /// Layers in front of this view a debug overlay using the default configuration.
    ///
    /// Applies the ``DebugOverlayModifier``, overlaying a visual representation of the views
    /// boundaries, origin point, and safe area insets.
    ///
    /// ```swift
    /// Text("a sort of splendid torch")
    ///     .debugOverlay()
    /// Text("which I have got hold of for the moment")
    /// ```
    /// ![Debug overlay with default configuration applied to a single Text.](debug-overlay-torch-default)
    ///
    /// - Returns: A view with a debug overlay as foreground.
    public func debugOverlay() -> some View {
        let configuration = DebugOverlayModifier.Configuration()
        return modifier(DebugOverlayModifier(configuration: configuration))
    }


    /// Layers in front of this view a debug overlay configured using the given traits.
    ///
    /// Applies the ``DebugOverlayModifier`` configured with the given [`Trait`](doc:DebugOverlayModifier/Configuration/Trait)
    /// instances, overlaying a visual representation of the views boundaries, origin point, and
    /// safe area insets.
    ///
    /// The traits are applied in the order they are passed to a default configuration. Later
    /// traits may override earlier ones depending on the configuration each trait modifies.
    ///
    /// ```swift
    /// Text("a sort of splendid torch")
    ///     .debugOverlay(.width, .alignment(.outerTop))
    /// Text("which I have got hold of for the moment")
    /// ```
    /// ![Debug overlay with traits applied to a single Text.](debug-overlay-torch-traits)
    ///
    /// - Parameters:
    ///   - traits: The traits to modify the default configuration.
    ///
    /// - Returns: A view with a configured debug overlay as foreground.
    public func debugOverlay(_ traits: DebugOverlayModifier.Configuration.Trait...) -> some View {
        let configuration = DebugOverlayModifier.Configuration(traits: traits)
        return modifier(DebugOverlayModifier(configuration: configuration))
    }


    /// Layers in front of this view a debug overlay configured using the given traits.
    ///
    /// Applies the ``DebugOverlayModifier`` configured with the given [`Trait`](doc:DebugOverlayModifier/Configuration/Trait)
    /// instances, overlaying a visual representation of the views boundaries, origin point, and
    /// safe area insets.
    ///
    /// The traits are applied in the order they are passed to a default configuration. Later
    /// traits may override earlier ones depending on the configuration each trait modifies.
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
        star(.pink.gradient)
    }

    static func star(_ fill: some ShapeStyle) -> some View {
        StarShape(points: 6, concaveVertexRatio: 0.8)
            .fill(fill)
    }

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    PreviewContent.star
    .debugOverlay()
    .safeAreaPadding(.init(horizontal: 20, vertical: 30))
}


#Preview("Configuration", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var useSmallContent: Bool = false
    @Previewable @State var traitOptions: [(
        label: String,
        trait: DebugOverlayModifier.Configuration.Trait,
        enabled: Bool
    )] = [
        ("Hidden",          .hidden,                                false),
        ("Caption",         .caption("Caption\nwith `formatting`"), false),
        ("Hairline",        .hairline,                              false),
        ("Width",           .width,                                 true),
        ("Height",          .height,                                false),
        ("Origin",          .origin,                                false),
        ("SafeArea Insets", .safeAreaInsets,                        false),
        ("All Geometry",    .allGeometry,                           false),
        ("Outer Info"    ,  .outerInfo,                             false)
    ]

    let traits = traitOptions.compactMap { traitTuple in
        return traitTuple.enabled
            ? traitTuple.trait
            : nil
    }

    VStack {
        ForEach(traitOptions.enumerated(), id: \.offset) { index, optionTuple in
            Toggle(optionTuple.label, isOn: $traitOptions[index].enabled)
        }

        DashedDivider()

        Toggle("Use Small Content", isOn: $useSmallContent)
    }

    DashedDivider()

    if useSmallContent {
        Rectangle().fill(.gray.tertiary)
            .frame(width: 100)
            .floatingCaption("Spacer")
        Text("Preview text")
            .foregroundStyle(.quaternary)
            .monospaced()
            .debugOverlay(traits: traits)
            .safeAreaPadding(20)
        Rectangle().fill(.gray.tertiary)
            .frame(width: 100)
            .floatingCaption("Spacer")
    } else {
        PreviewContent.star
            .debugOverlay(traits: traits)
            .safeAreaPadding(.init(horizontal: 50, vertical: 80))
    }

}


#Preview("Alignments", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var useSmallContent: Bool = false
    @Previewable @State var bordersWidth: Double = 5

    @Previewable @State var positionKey: FloatingAlignment.Key = .outer
    @Previewable @State var innerHorizontalAlignment: FloatingAlignment.HorizontalAlignment = .center
    @Previewable @State var innerVerticalAlignment: FloatingAlignment.VerticalAlignment = .top

    @Previewable @State var outerMajorAlignment: FloatingAlignment.OuterAlignment.Key = .top
    @Previewable @State var outerMinorHorizontalAlignment: FloatingAlignment.HorizontalAlignment = .center
    @Previewable @State var outerMinorVerticalAlignment: FloatingAlignment.OuterVerticalAlignment = .center

    let defaultTraits: [DebugOverlayModifier.Configuration.Trait] = [
        .allGeometry,
        .caption("Caption\nwith `formatting`")
    ]

    let makeTraits: () -> [DebugOverlayModifier.Configuration.Trait] = {
        var traits: [DebugOverlayModifier.Configuration.Trait] = defaultTraits + [.bordersWidth(bordersWidth)]

        let positionTrait: DebugOverlayModifier.Configuration.Trait
        switch positionKey {
        case .inner:
            positionTrait = .innerInfo(.init(horizontal: innerHorizontalAlignment, vertical: innerVerticalAlignment))
        case .outer:
            let outerAlignment: FloatingAlignment.OuterAlignment = switch outerMajorAlignment {
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
            Picker("Outer Major Alignment", selection: $outerMajorAlignment, caseFormat: .rawValueCapitalized())
                .pickerStyle(.segmented)

            switch outerMajorAlignment {
            case .top, .bottom:
                Picker("Horizontal Minor Alignment", selection: $outerMinorHorizontalAlignment, caseFormat: .rawValueCapitalized())
                    .pickerStyle(.segmented)
            case .leading, .trailing:
                Picker("Vertical Minor Alignment", selection: $outerMinorVerticalAlignment, caseFormat: .rawValueCapitalized())
                    .pickerStyle(.segmented)
            }
        }

        Slider.captioned(
            "Borders Width", value: $bordersWidth, in: 0...30,
            currentValueFormat: .fractionLength(2),
            boundsValueFormat: .arithmeticRoundedInteger)

        Toggle("Use Small Content", isOn: $useSmallContent)
    }

    DashedDivider()

    if useSmallContent {
        VisibleSpacer()
        Text("Preview text")
            .foregroundStyle(.quaternary)
            .monospaced()
            .debugOverlay(traits: traits)
            .safeAreaPadding(20)
        VisibleSpacer()
    } else {
        PreviewContent.star
        .debugOverlay(traits: traits)
        .safeAreaPadding(.init(horizontal: 100, vertical: 120))
    }

}


#Preview("Zero size", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var bordersWidth: Double = 5
    @Previewable @State var widthIndex: Double = .zero
    @Previewable @State var heightIndex: Double = .zero
    @Previewable @State var width: Double = .zero
    @Previewable @State var height: Double = .zero

    let values: [Double] = Array(
        [
            stride(from: 0.0, to: 2.0, by: 0.1),
            stride(from: 2.0, to: 16.0, by: 1.0),
            stride(from: 20.0, to: 101.0, by: 10.0)
        ]
        .joined()
    )

    VStack {
        Slider.captioned(
            "Line Width", value: $bordersWidth, in: 0...15,
            valueFormat: .arithmeticRoundedInteger)

        Slider(
            "Width", collection: values,
            value: $widthIndex, mapped: $width,
            currentMappedFormat: .fractionLength(1),
            boundsMappedFormat: .fractionLength(1)
        )
        Slider(
            "Height", collection: values,
            value: $heightIndex, mapped: $height,
            currentMappedFormat: .fractionLength(1),
            boundsMappedFormat: .fractionLength(1)
        )

        Text("Size: \(width, format: .fractionLength(1)),\(height, format: .fractionLength(1))")
            .monospaced()
    }

    PreviewContent.star
        .frame(
            width: width,
            height: height
        )
        .debugOverlay(.bordersWidth(bordersWidth), .allGeometry, .outerInfo(.bottomLeading))
        .safeAreaPadding(.init(horizontal: 50, vertical: 30))
        .border(.gray.tertiary)
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
        .padding(.vertical)
}


#Preview("ColorSchemes", traits: .headerFooter(.showDividers), PreviewContent.layout) {
    let content = HStack {
        PreviewContent.star
        Text("Preview Text").font(.title)
    }
    .frame(height: 100)
    .debugOverlay(.caption("Caption text"), .size, .alignment(.outerBottom))
    .safeAreaPadding(.horizontal(40))
    .padding(.horizontal)
    .padding(.vertical, 50)
    .background(.background)

    content
    .colorScheme(.light)

    content
    .colorScheme(.dark)
}


#Preview("Interactive", traits: .headerFooter, PreviewContent.layout) {
    @Previewable @State var counter: Int = 0

    Text("Counter: \(counter)")
        .monospaced()

    ZStack(alignment: .topLeading) {
        PreviewContent.star

        Button("Increment", systemImage: "ladybug") {
            counter += 1
        }
        .buttonStyle(.borderedProminent)
        .padding()
    }
    .debugOverlay(.allGeometry)
}


#Preview("Grouped Alignments", traits: PreviewContent.layout) {
    ForEach(FloatingAlignment.HorizontalAlignment.allCases) { horizontalAlignment in
        DashedDivider()
        Text(horizontalAlignment.displayName, format: .capitalize)

        PreviewContent.star
        .frame(size: [100, 130])
        .overlay {
            let alignments = FloatingAlignment.allCases(withHorizontal: horizontalAlignment)
            ForEach(alignments) { alignment in
                ClearRectangle()
                .debugOverlay(
                    .width, .caption(verbatim: alignment.hyphenatedName),
                    .infoAlignment(alignment)
                )
            }
        }
        .padding(.vertical, 30)
    }
    DashedDivider()
}


#Preview("Caption Alignment", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var bordersWidth: Double = 5

    Slider.captioned(
        "Borders Width", value: $bordersWidth, in: 0...30,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)

    ForEach(FloatingAlignment.HorizontalAlignment.allCases) { horizontalAlignment in
        DashedDivider()
        Text(horizontalAlignment.displayName, format: .capitalize)

        PreviewContent.star(.pink.gradient.tertiary)
        .frame(squareOf: 100)
        .overlay {
            let alignments = FloatingAlignment.allCases(withHorizontal: horizontalAlignment)
            ForEach(alignments) { alignment in
                ClearRectangle()
                .debugOverlay(.caption("Ag"), .alignment(alignment), .drawsCaptionBorder, .bordersWidth(bordersWidth))
            }
        }
        .debugAlignmentGuide(vertical: .top, .extendLength(100))
        .debugAlignmentGuide(vertical: .bottom, .extendLength(100))
        .debugAlignmentGuide(horizontal: .center, .extendLength(40))
        .padding(.vertical, 20)
    }
    DashedDivider()
}



extension Hashable {

    nonisolated
    func isEqual(toAny others: Self...) -> Bool {
        let set = Set(others)
        return set.contains(self)
    }

}

