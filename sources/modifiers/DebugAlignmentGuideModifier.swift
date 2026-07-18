//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


public struct DebugAlignmentGuideModifier: ViewModifier {

    public typealias Trait = ConfigurationTrait<Configuration>

    let alignment: Alignment
    let configuration: Configuration

    public func body(content: Content) -> some View {
        let horizontalModifier = DebugAxisAlignmentGuideModifier(
            axisAlignment: alignment.horizontal,
            configuration: configuration.horizontalConfiguration
        )
        let verticalModifier = DebugAxisAlignmentGuideModifier(
            axisAlignment: alignment.vertical,
            configuration: configuration.verticalConfiguration
        )
        content
        .modifier(horizontalModifier)
        .modifier(verticalModifier)
    }


    public struct Configuration: TraitConfigurable {

        enum Modifiers {}

        var opacity: Double = .one
        var horizontalLength: DebugAxisAlignmentConfigurationLength = .container
        var verticalLength: DebugAxisAlignmentConfigurationLength = .container
        var anchor: Alignment = .center

        public init() {}

        var horizontalConfiguration: DebugAxisAlignmentGuideConfiguration<HorizontalAlignment> {
            var resultConfiguration = DebugAxisAlignmentGuideConfiguration<HorizontalAlignment>()
            resultConfiguration.opacity = opacity
            resultConfiguration.length = horizontalLength
            resultConfiguration.anchor = anchor.vertical
            return resultConfiguration
        }

        var verticalConfiguration: DebugAxisAlignmentGuideConfiguration<VerticalAlignment> {
            var resultConfiguration = DebugAxisAlignmentGuideConfiguration<VerticalAlignment>()
            resultConfiguration.opacity = opacity
            resultConfiguration.length = verticalLength
            resultConfiguration.anchor = anchor.horizontal
            return resultConfiguration
        }

    }

}


// MARK: - Composite Configuration


/// Contains the configuration traits that can be applied to the configuration of ``DebugAlignmentGuideModifier``.
extension ConfigurationTrait where Configuration == DebugAlignmentGuideModifier.Configuration {

    typealias Modifiers = Configuration.Modifiers

    // FIXME: document.
    public static var hidden: Self {
        .modifier(Modifiers.Opacity(opacity: .zero))
    }

    // FIXME: document.
    public static func visible(_ isVisible: Bool) -> Self {
        .modifier(Modifiers.Opacity(opacity: isVisible ? .one : .zero))
    }

    // FIXME: document.
    public static func opacity(_ opacity: Double) -> Self {
        .modifier(Modifiers.Opacity(opacity: opacity))
    }

    // FIXME: document.
    public static func lengths(
        horizontal: DebugAxisAlignmentConfigurationLength = .container,
        vertical: DebugAxisAlignmentConfigurationLength = .container
    ) -> Self {
        .mutate {
            $0.horizontalLength = horizontal
            $0.verticalLength = vertical
        }
    }

    // FIXME: document.
    public static func lengths(_ lengths: DebugAxisAlignmentConfigurationLength) -> Self {
        .mutate {
            $0.horizontalLength = lengths
            $0.verticalLength = lengths
        }
    }

    // FIXME: document.
    public static func anchor(_ anchor: Alignment) -> Self {
        .modifier(Modifiers.Anchor(anchor: anchor))
    }

}


extension DebugAlignmentGuideModifier.Configuration.Modifiers {

    typealias Configuration = DebugAlignmentGuideModifier.Configuration

    struct Opacity: ConfigurationModifier {
        let opacity: Double
        func update(configuration: inout Configuration) {
            configuration.opacity = opacity
        }
    }

    struct Anchor: ConfigurationModifier {
        let anchor: Alignment
        func update(configuration: inout Configuration) {
            configuration.anchor = anchor
        }
    }

}


// MARK: - Single Axis


public struct DebugAxisAlignmentGuideModifier<AxisAlignment>: ViewModifier
where
    AxisAlignment: AlignmentWithOrthogonal,
    AxisAlignment.OrthogonalAlignment: AlignmentWithDefault
{

    public typealias Configuration = DebugAxisAlignmentGuideConfiguration<AxisAlignment>
    public typealias Trait = ConfigurationTrait<Configuration>

    let axisAlignment: AxisAlignment
    let configuration: Configuration

    public func body(content: Content) -> some View {
        let alignment = axisAlignment.alignment(withOrthogonal: configuration.anchor)
        content.overlay(alignment: alignment) {
            let lineWidth: CGFloat = 2
            let axis = axisAlignment.axis
            let orthogonal = axis.orthogonal
            GeometryReader { geometry in
                let markSize: CGSize = switch configuration.length {
                case .container, .extended: geometry.size
                case .fixed(let length): geometry.size.setting(length: length, along: orthogonal)
                case .scaled(let multiplier): geometry.size.multiplying(by: multiplier)
                }
                let additionalSize: CGSize = switch configuration.length {
                case .container, .fixed, .scaled: .zero
                case .extended(let addition):
                    orthogonal.unitSize.multiplying(by: addition)
                }

                AxialLine(orthogonal, style: configuration.shapeStyle, lineWidth: lineWidth)
                .frame(size: markSize.adding(size: additionalSize))
                .frame(size: geometry.size, alignment: alignment)
            }
            .frame(length: lineWidth, along: axisAlignment.axis)
            .opacity(configuration.opacity)
            .allowsHitTesting(false)
        }
    }

}


// MARK: - Configuration


/// Protocol for the configuration of a `DebugAxisAlignmentGuideModifier`.
///
/// Provides the protocol for the configuration instance of both horizontal and vertical alignments
/// for `DebugAxisAlignmentGuideModifier`.
///
/// This protocol allows to define the same traits for both horizontal and vertical alignments.
nonisolated
public protocol DebugAxisAlignmentGuideConfigurationProtocol: Sendable {
    associatedtype AnchorAlignment: AlignmentWithDefault
    var opacity: Double { get set }
    var shapeStyle: AnyShapeStyle { get set }
    var length: DebugAxisAlignmentConfigurationLength { get set }
    var anchor: AnchorAlignment { get set }

}


nonisolated
public struct DebugAxisAlignmentGuideConfiguration<AxisAlignment>: DebugAxisAlignmentGuideConfigurationProtocol, TraitConfigurable
where
    AxisAlignment: AlignmentWithOrthogonal,
    AxisAlignment.OrthogonalAlignment: AlignmentWithDefault
{
    public typealias AnchorAlignment = AxisAlignment.OrthogonalAlignment
    public var opacity: Double = .one
    public var shapeStyle: AnyShapeStyle = AnyShapeStyle(.red.secondary)
    public var length: DebugAxisAlignmentConfigurationLength = .container
    public var anchor: AnchorAlignment = .default
    public init() {}
}


// MARK: - ConfigurationLength


// FIXME: Document.
public enum DebugAxisAlignmentConfigurationLength {
    case container
    case fixed(CGFloat)
    case extended(CGFloat)
    case scaled(CGFloat)
}


// MARK: - ConfigurationTrait


/// Contains the configuration traits that can be applied to the configuration of ``DebugAxisAlignmentGuideModifier``
/// for both horizontal and vertical alignments.
extension ConfigurationTrait where Configuration: DebugAxisAlignmentGuideConfigurationProtocol {

    // FIXME: document.
    public static var hidden: Self {
        .modifier(DebugAxisAlignmentModifiers.Opacity(opacity: .zero))
    }

    // FIXME: document.
    public static func visible(_ isVisible: Bool) -> Self {
        .modifier(DebugAxisAlignmentModifiers.Opacity(opacity: isVisible ? .one : .zero))
    }

    // FIXME: document.
    public static func opacity(_ opacity: Double) -> Self {
        .modifier(DebugAxisAlignmentModifiers.Opacity(opacity: opacity))
    }


    // FIXME: document.
    public static func style(_ style: some ShapeStyle) -> Self {
        .mutate { $0.shapeStyle = AnyShapeStyle(style) }
    }

    // FIXME: document.
    public static func length(_ length: DebugAxisAlignmentConfigurationLength) -> Self {
        .mutate { $0.length = length }
    }

    // FIXME: document.
    public static var containerLength: Self {
        .length(.container)
    }

    // FIXME: document.
    public static func fixedLength(_ length: CGFloat) -> Self {
        .length(.fixed(length))
    }

    // FIXME: document.
    public static func extendLength(_ addition: CGFloat) -> Self {
        .length(.extended(addition))
    }

    // FIXME: document.
    public static func scaleLength(_ factor: CGFloat) -> Self {
        .length(.scaled(factor))
    }

    // FIXME: document.
    public static func anchor(_ anchor: Configuration.AnchorAlignment) -> Self {
        .modifier(DebugAxisAlignmentModifiers.Anchor(anchor: anchor))
    }

}


/// Container type for modifiers for `DebugAxisAlignmentGuideModifier` configurations.
///
/// Contains the modifiers for the configuration of `DebugAxisAlignmentGuideModifier` for both
/// horizontal and vertical alignments.
enum DebugAxisAlignmentModifiers<Configuration: DebugAxisAlignmentGuideConfigurationProtocol> {

    struct Opacity: ConfigurationModifier {
        let opacity: Double
        func update(configuration: inout Configuration) {
            configuration.opacity = opacity
        }
    }

    struct Anchor: ConfigurationModifier {
        let anchor: Configuration.AnchorAlignment
        func update(configuration: inout Configuration) {
            configuration.anchor = anchor
        }
    }

}


// MARK: - Alignment Protocols


// FIXME: Document these types and likely move to AlignmentAdditions
public nonisolated
protocol AlignmentWithOrthogonal {
    associatedtype OrthogonalAlignment: Sendable
    var axis: Axis { get }
    func alignment(withOrthogonal orthogonalAlignment: OrthogonalAlignment) -> Alignment
}


nonisolated
extension HorizontalAlignment: AlignmentWithOrthogonal {
    public typealias OrthogonalAlignment = VerticalAlignment
    public var axis: Axis { .horizontal }
    public func alignment(withOrthogonal orthogonalAlignment: OrthogonalAlignment) -> Alignment {
        .init(horizontal: self, vertical: orthogonalAlignment)
    }
}


nonisolated
extension VerticalAlignment: AlignmentWithOrthogonal {
    public typealias OrthogonalAlignment = HorizontalAlignment
    public var axis: Axis { .vertical }
    public func alignment(withOrthogonal orthogonalAlignment: OrthogonalAlignment) -> Alignment {
        .init(horizontal: orthogonalAlignment, vertical: self)
    }
}


public nonisolated
protocol AlignmentWithDefault {
    static var `default`: Self { get }
}


nonisolated
extension HorizontalAlignment: AlignmentWithDefault {
    public static var `default`: Self { .center }
}


nonisolated
extension VerticalAlignment: AlignmentWithDefault {
    public static var `default`: Self { .center }
}


// MARK: - View Extensions


extension View {

    public func debugAlignmentGuide(
        _ alignment: Alignment,
        _ traits: DebugAlignmentGuideModifier.Trait...
    ) -> some View {
        let configuration = DebugAlignmentGuideModifier.Configuration(traits: traits)
        let guideModifier = DebugAlignmentGuideModifier(
            alignment: alignment,
            configuration: configuration
        )
        return modifier(guideModifier)
    }

    public func debugAlignmentGuide(
        horizontal horizontalAlignment: HorizontalAlignment,
        _ traits: DebugAxisAlignmentGuideModifier<HorizontalAlignment>.Trait...
    ) -> some View {
        let configuration = DebugAxisAlignmentGuideModifier<HorizontalAlignment>.Configuration(traits: traits)
        let guideModifier = DebugAxisAlignmentGuideModifier(
            axisAlignment: horizontalAlignment,
            configuration: configuration
        )
        return modifier(guideModifier)
    }

    public func debugAlignmentGuide(
        vertical verticalAlignment: VerticalAlignment,
        _ traits: DebugAxisAlignmentGuideModifier<VerticalAlignment>.Trait...
    ) -> some View {
        let configuration = DebugAxisAlignmentGuideModifier<VerticalAlignment>.Configuration(traits: traits)
        let guideModifier = DebugAxisAlignmentGuideModifier(
            axisAlignment: verticalAlignment,
            configuration: configuration
        )
        return modifier(guideModifier)
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

    static let single: some View =
        Text("Ag")
        .font(.title.pointSize(100))
        .border(.green.tertiary, width: 8)

    static let multi: some View =
        Text("Sphinx\nof Black\nQuartz")
        .fixedSize()
        .font(.largeTitle)
        .border(.green.tertiary, width: 8)

}


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    PreviewContent.single
    .floatingCaption("Composite", .alignment(.outerLeading))
    .debugAlignmentGuide(.topLeading)
    .debugAlignmentGuide(.centerFirstTextBaseline)
    .debugAlignmentGuide(.bottomTrailing)

    DashedDivider()

    PreviewContent.single
    .floatingCaption("All Horizontal", .alignment(.outerLeading))
    .debugAlignmentGuide(horizontal: .leading)
    .debugAlignmentGuide(horizontal: .center)
    .debugAlignmentGuide(horizontal: .trailing)

    DashedDivider()

    PreviewContent.multi
    .floatingCaption("All Vertical", .alignment(.outerLeading))
    .debugAlignmentGuide(vertical: .top)
    .debugAlignmentGuide(vertical: .firstTextBaseline)
    .debugAlignmentGuide(vertical: .verticalCenter)
    .debugAlignmentGuide(vertical: .lastTextBaseline)
    .debugAlignmentGuide(vertical: .bottom)
}


#Preview("Traits", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    PreviewContent.single
    .floatingCaption("Extended", .alignment(.outerLeading))
    .debugAlignmentGuide(.topLeading, .lengths(horizontal: .extended(20), vertical: .extended(50)))
    .debugAlignmentGuide(.bottomTrailing, .lengths(horizontal: .extended(-50), vertical: .extended(-50)))

    DashedDivider()

    PreviewContent.single
    .floatingCaption("Extended\n& Anchored", .alignment(.outerLeading))
    .debugAlignmentGuide(.topLeading, .anchor(.topLeading), .lengths(horizontal: .extended(20), vertical: .extended(50)))
    .debugAlignmentGuide(.centerLastTextBaseline, .anchor(.bottomTrailing), .lengths(horizontal: .extended(-50), vertical: .extended(-50)))
}


#Preview("Horizontal", traits: .spacing(40), .headerFooter, PreviewContent.layout) {
    PreviewContent.single
    .floatingCaption("Fixed", .alignment(.outerLeading))
    .debugAlignmentGuide(horizontal: .leading, .fixedLength(50))
    .debugAlignmentGuide(horizontal: .center, .fixedLength(50), .anchor(.firstTextBaseline))
    .debugAlignmentGuide(horizontal: .trailing, .fixedLength(150))

    DashedDivider()

    PreviewContent.single
    .floatingCaption("Extended", .alignment(.outerLeading))
    .debugAlignmentGuide(horizontal: .leading, .extendLength(40), .anchor(.bottom))
    .debugAlignmentGuide(horizontal: .center, .extendLength(20), .anchor(.firstTextBaseline))
    .debugAlignmentGuide(horizontal: .trailing, .extendLength(-40), .anchor(.top))

    DashedDivider()

    PreviewContent.single
    .floatingCaption("Scaled", .alignment(.outerLeading))
    .debugAlignmentGuide(horizontal: .leading, .scaleLength(1.2), .anchor(.firstTextBaseline))
    .debugAlignmentGuide(horizontal: .center, .scaleLength(0.5), )
    .debugAlignmentGuide(horizontal: .trailing, .scaleLength(1.2), .anchor(.top))
}


#Preview("Vertical", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    PreviewContent.multi
    .floatingCaption("Fixed", .alignment(.outerLeadingTop))
    .debugAlignmentGuide(vertical: .top, .fixedLength(50))
    .debugAlignmentGuide(vertical: .firstTextBaseline, .fixedLength(150), .anchor(.trailing))
    .debugAlignmentGuide(vertical: .verticalCenter, .fixedLength(50), .anchor(.trailing))
    .debugAlignmentGuide(vertical: .lastTextBaseline)
    .debugAlignmentGuide(vertical: .bottom)

    DashedDivider()

    PreviewContent.multi
    .floatingCaption("Extended", .alignment(.outerLeadingTop))
    .debugAlignmentGuide(vertical: .top, .extendLength(-40))
    .debugAlignmentGuide(vertical: .firstTextBaseline, .extendLength(40), .anchor(.trailing))
    .debugAlignmentGuide(vertical: .verticalCenter, .extendLength(40))
    .debugAlignmentGuide(vertical: .lastTextBaseline, .extendLength(40), .anchor(.leading))
    .debugAlignmentGuide(vertical: .bottom, .extendLength(40))

    DashedDivider()

    PreviewContent.multi
    .floatingCaption("Scaled", .alignment(.outerLeadingTop))
    .debugAlignmentGuide(vertical: .top, .scaleLength(1.5))
    .debugAlignmentGuide(vertical: .firstTextBaseline, .scaleLength(1.5), .anchor(.trailing))
    .debugAlignmentGuide(vertical: .verticalCenter, .scaleLength(0.5))
    .debugAlignmentGuide(vertical: .lastTextBaseline, .scaleLength(1.5), .anchor(.leading))
    .debugAlignmentGuide(vertical: .bottom, .scaleLength(0.5), .anchor(.leading))
}


#Preview("Offset", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    PreviewContent.single
    .floatingCaption("Horizontal", .alignment(.outerLeading))

    .debugAlignmentGuide(horizontal: .leading, .style(.mint.secondary))
    .alignmentGuide(.leading, offsetBy: 10)
    .debugAlignmentGuide(horizontal: .leading)

    .debugAlignmentGuide(horizontal: .trailing, .style(.mint.secondary))
    .alignmentGuide(.trailing, offsetBy: -10)
    .debugAlignmentGuide(horizontal: .trailing)

    DashedDivider()

    PreviewContent.single
    .floatingCaption("Vertical", .alignment(.outerLeading))
    .debugAlignmentGuide(vertical: .top, .style(.mint.secondary))
    .alignmentGuide(.top, offsetBy: 10)
    .debugAlignmentGuide(vertical: .top)

    .debugAlignmentGuide(vertical: .firstTextBaseline, .style(.mint.secondary))
    .alignmentGuide(.firstTextBaseline, offsetBy: -10)
    .debugAlignmentGuide(vertical: .firstTextBaseline)

    .debugAlignmentGuide(vertical: .bottom, .style(.mint.secondary))
    .alignmentGuide(.bottom, offsetBy: -10)
    .debugAlignmentGuide(vertical: .bottom)
}


// MARK: - ReticuleGrid

// FIXME: Move to its own file.


/// Shape that draws a grid of vertical and horizontal lines in all its available space.
///
/// The grid lines are drawn at multiples of `spacing`, with `spacing.width` separating the vertical
/// lines and `spacing.height` the horizontal ones. The grid is anchored to the origin point of its
/// coordinate system, not to the origin of the rect the path is provided; a rect with a non-zero
/// origin draws the same grid lines that fall within it.
struct ReticuleGrid: Shape {

    let spacing: CGSize

    func path(in rect: CGRect) -> Path {
        var path = Path()

        if spacing.width > .zero {
            let firstX = (rect.minX / spacing.width).rounded(.up) * spacing.width
            for x in stride(from: firstX, through: rect.maxX, by: spacing.width) {
                path.moveTo(x: x, y: rect.minY)
                path.addLineTo(x: x, y: rect.maxY)
            }
        }

        if spacing.height > .zero {
            let firstY = (rect.minY / spacing.height).rounded(.up) * spacing.height
            for y in stride(from: firstY, through: rect.maxY, by: spacing.height) {
                path.moveTo(x: rect.minX, y: y)
                path.addLineTo(x: rect.maxX, y: y)
            }
        }

        return path
    }

}


#Preview("Reticule", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    ReticuleGrid(spacing: .square(of: 50))
    .stroke(.secondary)
}


#Preview("Reticule Offset", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    Canvas { context, size in
        let fullRect = CGRect(origin: .zero, size: size)
        let insetRect = fullRect.insetBy(dx: 40, dy: 40)
        let grid = ReticuleGrid(spacing: .square(of: 50))

        // Full-space grid, as reference.
        context.stroke(grid.path(in: fullRect), with: .style(.quaternary))
        // Same grid drawn in the offset rect.
        context.stroke(grid.path(in: insetRect), with: .style(.red.secondary))
        // Boundary of the offset rect.
        let dashedStyle = StrokeStyle(lineWidth: 1, dash: [4, 4])
        context.stroke(Path(insetRect), with: .style(.green.secondary), style: dashedStyle)
    }
}


