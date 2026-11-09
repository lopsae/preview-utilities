//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


/// Overlays a visual representation of a view's geometry properties.
///
/// Displays in an overlay a visual representation of a view's geometry properties: its boundaries,
/// origin point, and any applied safe area insets. The overlay can also display a caption with the
/// view's size, global origin coordinates, safe area insets, and a given text caption.
///
/// All content added by this modifier is layered in an overlay of the owner view; the original
/// layout is never modified.
///
/// Apply this modifier using ``SwiftUICore/View/debugGeometry(_:)``:
///
/// ```swift
/// Text("Sphinx of Black Quartz")
///     .font(.title)
/// Text("Judge my Vow")
///     .font(.title)
///     .debugGeometry()
/// ```
/// ![Debug geometry overlay with default configuration.](debug-geometry-default)
///
///
/// ### Traits and Configuration
///
/// The overlay can be configured by passing [`Trait`](doc:Configuration/Trait) instances to
/// ``SwiftUICore/View/debugGeometry(_:)``:
///
/// ```swift
/// RoundedRectangle(cornerRadius: 16)
/// .fill(.yellow.gradient.secondary)
/// .frame(width: 200, height: 80)
/// .debugGeometry(
///     .size,                     // prints the size of the owner view
///     .bordersWidth(2),          // sets debug borders width to 2
///     .alignment(.innerTrailing) // aligns caption to trailing-center
/// )
/// ```
/// ![Debug geometry overlay using traits.](debug-geometry-simple-traits)
///
///
/// ### Visual Components
///
/// The boundaries of the owner view are visualized using two strokes: a dashed inner stroke (by
/// default red) drawn inset of the view's boundaries, and a solid outer stroke (by default blue)
/// drawn outside. A cross `+` marks the origin point, and green rectangles represent safe area
/// insets applied to the view.
///
/// ![Visual components of the debug geometry overlay.](debug-geometry-components)
///
///
/// ### Caption Alignment
///
/// The overlay uses ``FloatingAlignment`` to determine the position of the debug caption,
/// supporting positions both inside and outside of the owner view. When an ``FloatingAlignment/OuterAlignment``
/// is used, the space occupied by the owner view does not change, even if the caption is
/// displayed outside of its boundaries:
/// ```swift
/// HStack(spacing: 16) {
///     Rectangle()
///         .fill(.green.gradient)
///         .frame(width: 100, height: 60)
///         .debugGeometry(.caption("Inner Top"), .alignment(.innerTop))
///     Rectangle()
///         .fill(.mint.gradient)
///         .frame(width: 100, height: 60)
///         .debugGeometry(.caption("Outer Bottom\nLeading"), .alignment(.outerBottomLeading))
///     Rectangle()
///         .fill(.teal.gradient)
///         .frame(width: 100, height: 60)
///         .debugGeometry(.caption("Outer Top\nTrailing"), .alignment(.outerTopTrailing))
/// }
/// ```
/// ![Debug geometry overlay example alignments.](debug-geometry-alignments)
///
public struct DebugGeometryModifier: ViewModifier {

    /// Minimum limit for the border width. Ensures there is always a visual overlay even on sizes
    /// approaching zero. Smaller values are clamped to this minimum.
    private static let minBordersWidth: CGFloat = 1

    /// Minimum limit for the reticule length. Ensures there is always a visual reticule even on
    /// sizes approaching zero. Smaller values are clamped to this minimum.
    private static let minReticuleLength: CGFloat = 2


    @Environment(\.colorScheme) private var colorScheme

    let configuration: Configuration


    /// Creates a modifier with the given configuration.
    public init(configuration: Configuration) {
        self.configuration = configuration
    }


    @_documentation(visibility: internal)
    public func body(content: Content) -> some View {
        content.overlay {
            GeometryReader { geometry in
                safeAreaRects(geometry: geometry)
                if configuration.outerBorderVisibility.isEqual(toAny: .visible, .automatic) {
                    outerStrokeRect(geometry: geometry)
                }
                if configuration.innerBorderVisibility.isEqual(toAny: .visible, .automatic) {
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
        let boundedBordersWidth = configuration.outerBorderWidth.clamped(to: Self.minBordersWidth...)

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
        let boundedBordersWidth = configuration.outerBorderWidth.clamped(to: Self.minBordersWidth...)

        Rectangle()
            // Stroke draws over the rectangle boundary, half inside half outside.
            // Drawn outset to sit outside the view's boundaries.
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
        let boundedBordersWidth = configuration.innerBorderWidth.clamped(to: Self.minBordersWidth...)
        // When content view is smaller that `bordersWidth*2` the lineWidth used is reduced to
        // allow drawing at smaller sizes, otherwise strokes smaller that half the half the side
        // of the rectangle are NOT drawn.
        let correctedLineWidth = min(geometry.size.minComponent, boundedBordersWidth * 2) / 2.0
        let strokeStyle = StrokeStyle(
            lineWidth: correctedLineWidth, lineCap: .butt,
            dash: [boundedBordersWidth * 3, boundedBordersWidth * 2]
        )
        // FIXME: Add support of styling inner and outer strokes.
        // FIXME: Add support for innerStrokePosition: .inner .outer .middle? .inset? .outset?
        // FIXME: Add support to ignore concentricCornerRadii.
        if let cornerRadii = geometry.backport.concentricCornerRadii.unwrappedValue,
           cornerRadii != .zero
        {
            UnevenRoundedRectangle(cornerRadii: cornerRadii)
            .strokeBorder(innerStrokeShapeStyle, style: strokeStyle)
        } else {
            PhasedRect(phase: boundedBordersWidth * 1.5)
            .strokeBorder(innerStrokeShapeStyle, style: strokeStyle)
        }
    }


    // MARK: Origin Reticule

    @ViewBuilder
    private func originReticuleRects(geometry: GeometryProxy) -> some View {
        // FIXME: Add to documentation that the reticule depends only on the outerBorderWidth.
        // FIXME: Add to test reticule size with different border widths and visibilities.
        let thickness: CGFloat = .one
        let borderWidth = configuration.outerBorderVisibility == .hidden ?
            .one : configuration.outerBorderWidth
        let boundedLength = borderWidth.clamped(to: Self.minReticuleLength...)
        // `+ thickness` to correctly center the reticule, specially at very small sizes.
        let reticuleLength = (boundedLength * 2) + thickness

        // FIXME: Figure out if this can be done with AxialLines or Paths.crosshair.
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
        if configuration.containsCaptionElements {

            let spacing = captionSpacing
            FloatingAlignedContainer(
                alignment: configuration.captionAlignment,
                horizontalSpacing: spacing.width,
                verticalSpacing: spacing.height,
            ) { alignments in
                // Spacing is derived from the contained Text elements, which so far works well.
                VStack(alignment: alignments.content.horizontal) {
                    let globalFrame = geometry.frame(in: .global)
                    let twoFractionals: FloatingPointFormatStyle<Double> = .twoFractionals

                    // Caption.
                    switch configuration.captionSource {
                    case .localizedKey(let localizedStringKey):
                        Text(localizedStringKey)
                        .font(.caption)
                        // FIXME: can multiline text alignment be moved to outside the group?
                    case .verbatim(let string):
                        Text(verbatim: string)
                        .font(.caption)
                    case .none:
                        EmptyView()
                    }

                    // Width, Height, or Size.
                    if configuration.geometryProperties.contains(.size) {
                        let formattedWidth = globalFrame.width.formatted(twoFractionals)
                        let formattedHeight = globalFrame.height.formatted(twoFractionals)
                        Text("size: \(formattedWidth), \(formattedHeight)")
                    } else if configuration.geometryProperties.contains(.width) {
                        let formattedWidth = globalFrame.width.formatted(twoFractionals)
                        Text("width: \(formattedWidth)")
                    } else if configuration.geometryProperties.contains(.height) {
                        let formattedHeight = globalFrame.height.formatted(twoFractionals)
                        Text("height: \(formattedHeight)")
                    }

                    // Origin.
                    if configuration.geometryProperties.contains(.origin) {
                        let formattedX = globalFrame.origin.x.formatted(twoFractionals)
                        let formattedY = globalFrame.origin.y.formatted(twoFractionals)
                        Text("origin: \(formattedX), \(formattedY)")
                    }

                    // SafeAreaInsets.
                    if configuration.geometryProperties.contains(.safeAreaInsets) {
                        Text("safeAreaInsets:\n\(geometry.safeAreaInsets, format: .edgeInsetDebugString)")
                    }

                    // ConcentricCornerRadii
                    if configuration.geometryProperties.contains(.concentricCornerRadii) {
                        let label = "concentricCornerRadii"
                        switch geometry.backport.concentricCornerRadii {
                        case .available(.some(let cornerRadii)):
                            Text("\(label):\n\(cornerRadii, format: .concentricRadiiDebugString)")
                        case .available(.none):
                            Text("\(label): none)")
                        case .unavailable:
                            Text("\(label): unavailable)")
                        }
                    }
                } // Group
                .font(.caption.monospaced())
                .foregroundStyle(.secondary)
                .multilineTextAlignment(alignments.text)
                .fixedSize()
                .border(configuration.drawsCaptionBorder ? AnyShapeStyle(.tertiary) : AnyShapeStyle(.clear))
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
        let outerAlignment = configuration.captionAlignment.outerAlignment

        let borderWidth: CGFloat
        if outerAlignment == nil {
            // Inner caption.
            borderWidth = configuration.innerBorderVisibility == .hidden
                ? .one : configuration.innerBorderWidth
        } else {
            // Outer caption.
            borderWidth = configuration.outerBorderVisibility == .hidden
                ? .one : configuration.outerBorderWidth
        }

        let boundedBordersWidth = borderWidth.clamped(to: Self.minBordersWidth...)

        // At most, the caption sits 4 points away from the borders.
        let maxSpacingFromBoundary = boundedBordersWidth + 4
        // At smaller sizes, the spacing is reduced along the borders width,
        // with a different ratio for each axis.
        let horizontalSpacingFromBoundary = (boundedBordersWidth * 2.0).clamped(to: ...maxSpacingFromBoundary)
        let verticalSpacingFromBoundary = (boundedBordersWidth * 1.2).clamped(to: ...maxSpacingFromBoundary)

        var horizontalSpacing = horizontalSpacingFromBoundary
        var verticalSpacing = verticalSpacingFromBoundary

        if let outerAlignment {
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

        return [horizontalSpacing, verticalSpacing]
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

    /// Layers in front of this view a visual representation of a view's geometry properties.
    ///
    /// Applies the ``DebugGeometryModifier`` customized with the given [`Trait`](doc:DebugGeometryModifier/Configuration/Trait)
    /// instances, overlaying a visual representation of the views boundaries, origin point, and
    /// safe area insets.
    ///
    /// The traits are applied in order to a default configuration. Later traits may override
    /// earlier ones depending on the configuration each trait modifies.
    ///
    /// ```swift
    /// Text("a sort of splendid torch")
    ///     .debugGeometry(.width, .alignment(.outerTop))
    /// Text("which I have got hold of for the moment")
    /// ```
    /// ![Debug geometry overlay with traits applied to a single Text.](debug-geometry-torch-traits)
    ///
    /// - Parameters:
    ///   - traits: The traits to customize the default configuration.
    ///
    /// - Returns: A view with a configured geometry visualization as foreground.
    public func debugGeometry(_ traits: DebugGeometryModifier.Configuration.Trait...) -> some View {
        let configuration = DebugGeometryModifier.Configuration(traits: traits)
        return modifier(DebugGeometryModifier(configuration: configuration))
    }


    /// Layers in front of this view a visual representation of a view's geometry properties.
    ///
    /// Applies the ``DebugGeometryModifier`` customized with the given [`Trait`](doc:DebugGeometryModifier/Configuration/Trait)
    /// instances, overlaying a visual representation of the views boundaries, origin point, and
    /// safe area insets.
    ///
    /// The traits are applied in order to a default configuration. Later traits may override
    /// earlier ones depending on the configuration each trait modifies.
    ///
    /// - Parameters:
    ///   - traits: The traits to customize the default configuration.
    ///
    /// - Returns: A view with a configured geometry visualization as foreground.
    public func debugGeometry(
        traits: [DebugGeometryModifier.Configuration.Trait],
    ) -> some View {
        let configuration = DebugGeometryModifier.Configuration(traits: traits)
        return modifier(DebugGeometryModifier(configuration: configuration))
    }

}


private extension View {

    @ContentBuilder
    func optionalContainerShape(_ shape: some RoundedRectangularShape?) -> some View {
        if let shape {
            self.containerShape(shape)
        } else {
            self
        }
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
    .debugGeometry()
    .safeAreaPadding(.init(horizontal: 20, vertical: 30))
}


#Preview("Configuration", traits: .fixedHeaderFooter, PreviewContent.layout) {
    @Previewable @State var useSmallContent: Bool = false
    @Previewable @State var useContainerShape: Bool = true
    @Previewable @State var traitOptions: [(
        label: String,
        trait: DebugGeometryModifier.Configuration.Trait,
        enabled: Bool
    )] = [
        ("Hidden",       .hidden,                                false),
        ("Caption",      .caption("Caption\nwith `formatting`"), false),
        ("Hairline",     .hairline,                              false),
        ("Width",        .width,                                 true),
        ("Height",       .height,                                false),
        ("Origin",       .origin,                                false),
        ("SafeAreas",    .safeAreaInsets,                        false),
        ("CornerRadii",  .concentricCornerRadii,                 true),
        ("All Geometry", .allGeometry,                           false),
        ("Outer Align.", .outerAlignment,                        false)
    ]

    let traits = traitOptions.compactMap { traitTuple in
        return traitTuple.enabled
            ? traitTuple.trait
            : nil
    }

    LazyVGrid(
        columns: .repeating(2, .flexible),
        alignment: .leading,
        spacing: 4.0
    ) {
        ForEach(traitOptions.indexed(), id: \.index) { index, optionTuple in
            Toggle(optionTuple.label, isOn: $traitOptions[index].enabled)
        }

        // FIXME: add toggle for wrapping in container shape.

        Section {
            Toggle("Small Content", isOn: $useSmallContent)
            Toggle("ContainerShape", isOn: $useContainerShape)
        } header: {
            DashedDivider()
            .padding(.vertical, 4)
        }
    }

    DashedDivider()

    if useSmallContent {
        VisibleSpacer()
        Text("Preview text")
            .foregroundStyle(.quaternary)
            .monospaced()
            .debugGeometry(traits: traits)
            .optionalContainerShape(useContainerShape ? Capsule() : nil)
            .safeAreaPadding(20)
        VisibleSpacer()
    } else {
        let roundedRect = UnevenRoundedRectangle(
            topLeadingRadius: 38,
            bottomLeadingRadius: 12,
            bottomTrailingRadius: 12,
            topTrailingRadius: 38
        )
        PreviewContent.star
            .debugGeometry(traits: traits)
            .optionalContainerShape(useContainerShape ? roundedRect : nil)
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

    let defaultTraits: [DebugGeometryModifier.Configuration.Trait] = [
        .allGeometry,
        .caption("Caption\nwith `formatting`")
    ]

    let makeTraits: () -> [DebugGeometryModifier.Configuration.Trait] = {
        var traits: [DebugGeometryModifier.Configuration.Trait] = defaultTraits + [.bordersWidth(bordersWidth)]

        let positionTrait: DebugGeometryModifier.Configuration.Trait
        switch positionKey {
        case .inner:
            positionTrait = .alignment(.inner(.init(horizontal: innerHorizontalAlignment, vertical: innerVerticalAlignment)))
        case .outer:
            let outerAlignment: FloatingAlignment.OuterAlignment = switch outerMajorAlignment {
            case .top:      .top(     outerMinorHorizontalAlignment)
            case .bottom:   .bottom(  outerMinorHorizontalAlignment)
            case .leading:  .leading( outerMinorVerticalAlignment)
            case .trailing: .trailing(outerMinorVerticalAlignment)
            }
            positionTrait = .alignment(.outer(outerAlignment))
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
            .debugGeometry(traits: traits)
            .safeAreaPadding(20)
        VisibleSpacer()
    } else {
        PreviewContent.star
        .debugGeometry(traits: traits)
        .safeAreaPadding(.init(horizontal: 100, vertical: 120))
    }

}


// FIXME: Add capsule container shape, to test small sizes.
#Preview("Zero size", traits: .fixedHeader, PreviewContent.layout) {
    @Previewable @State var bordersWidth: Double = 5
    @Previewable @State var widthIndex: Double = .zero
    @Previewable @State var heightIndex: Double = .zero
    @Previewable @State var width: Double = .zero
    @Previewable @State var height: Double = .zero

    let values: [Double] = [
        (0...0.9) .stride(by: 0.1),
        (1...1.9) .stride(by: 0.2),
        (2...15)  .stride(by: 1),
        (20...100).stride(by: 10)
    ].joined().toArray

    VStack {
        Slider.captioned(
            "Line Width", value: $bordersWidth, in: 0...15,
            currentValueFormat: .twoFractionals,
            boundsValueFormat: .arithmeticRoundedInteger
        )

        Slider(
            "Width", collection: values,
            value: $widthIndex, mapped: $width,
            currentMappedFormat: .fractionLength(1),
            boundsMappedFormat: .arithmeticRoundedInteger
        )
        Slider(
            "Height", collection: values,
            value: $heightIndex, mapped: $height,
            currentMappedFormat: .fractionLength(1),
            boundsMappedFormat: .arithmeticRoundedInteger
        )

        Text("Size: \(width, format: .fractionLength(1)),\(height, format: .fractionLength(1))")
            .monospaced()
    }

    PreviewContent.star
        .frame(size: [width, height])
        .debugGeometry(.bordersWidth(bordersWidth), .allGeometry, .alignment(.outerBottomLeading)
        )
        .safeAreaPadding(.init(horizontal: 50, vertical: 30))
        .border(.gray.tertiary)
}


#Preview("SafeAreas", traits: .headerFooter(.showDividers), PreviewContent.layout) {
    PreviewContent.star
        .debugGeometry(.allGeometry, .outerAlignment)
        .safeAreaPadding(.init(
            top:      20,
            leading:  30,
            bottom:   40,
            trailing: 50
        ))
        .border(.gray.tertiary)
        .padding(.vertical)
}


// FIXME: Cleanup or delete.
#Preview("Corners", traits: PreviewContent.layout) {
    @Previewable @State var printOnce: PrintOnce = .previewStarted

    printOnce.print()

    ZStack {
        ConcentricRectangle(minimumConcentricRadius: .zero)
            .fill(.orange)

        let uneven = UnevenRoundedRectangle(
            topLeadingRadius: 50,
            bottomLeadingRadius: 20,
            bottomTrailingRadius: 50,
            topTrailingRadius: 20,
            style: .continuous
        )

        VStack {
            ZStack {
                ConcentricRectangle(minimumConcentricRadius: .zero)
                .fill(.purple)

                GeometryReader { geometry in
                    VStack {
                        Text("GeometryProxy")
                        switch geometry.backport.concentricCornerRadii {
                        case .available(.some(let cornerRadii)):
                            Text(cornerRadii, format: .concentricRadiiDebugString)
                            .monospaced()
                        case .available(.none):
                            Text("nil corner-radii")
                            .monospaced()
                        case .unavailable:
                            Text("unavailable corner-radii")
                            .monospaced()
                        }
                    }
                    .font(.caption)
                    .fixedSize()
                }
            }
            .containerShape(uneven)
            .frame(squareOf: 200)

            ConcentricRectangle()
            .fill(.purple.quinary)
            .debugGeometry(.concentricCornerRadii)
            .containerShape(uneven)
            .frame(squareOf: 200)
        }
    }
    .padding(8)
    .ignoresSafeArea()
}


#Preview("ColorSchemes", traits: .headerFooter(.showDividers), PreviewContent.layout) {
    let content = HStack {
        PreviewContent.star
        Text("Preview Text").font(.title)
    }
    .frame(height: 100)
    .debugGeometry(.caption("Caption text"), .size, .alignment(.outerBottom))
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
    .debugGeometry(.allGeometry)
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
                .debugGeometry(
                    .width, .caption(verbatim: alignment.hyphenatedName),
                    .alignment(alignment)
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
                // FIXME: Implement style for all borders, setting it to clear would respect caption position, with no borders.
                // TODO: Maybe implement borderVisibility trait, to allow only one border to draw, but keeping caption spacing.
//                let noBorderTrait = alignment.innerAlignment?.vertical == .center
//                    ? DebugGeometryModifier.Configuration.Trait.empty
//                    : .noBorders
                ClearRectangle()
                .debugGeometry(
                    .caption("Ag"), .alignment(alignment),
                    .drawsCaptionBorder, .bordersWidth(bordersWidth)
                )
            }
        }
        .debugAlignmentGuide(horizontal: horizontalAlignment.swiftAlignment, .extendedLength(50))
        .debugAlignmentGuide(vertical: .top,    .extendedLength(100))
        .debugAlignmentGuide(vertical: .bottom, .extendedLength(100))
        .padding(.vertical, 20)
    }
    DashedDivider()
}


// FIXME: Move to additions

extension Array {

    static func repeating(_ count: Int, _ element: Element) -> Self {
        .init(repeating: element, count: count)
    }

}
