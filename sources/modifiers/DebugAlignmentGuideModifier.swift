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


    public struct Configuration: TraitInitializable {

        enum Modifiers {}

        var horizontalConfiguration: DebugAxisAlignmentGuideConfiguration<HorizontalAlignment> = .init()
        var verticalConfiguration: DebugAxisAlignmentGuideConfiguration<VerticalAlignment> = .init()

        public init() {}

    }

}


// MARK: - Composite Traits


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
    public static func style(
        horizontal: some ShapeStyle,
        vertical: some ShapeStyle
    ) -> Self {
        .mutate {
            $0.horizontalConfiguration.shapeStyle = AnyShapeStyle(horizontal)
            $0.verticalConfiguration.shapeStyle = AnyShapeStyle(vertical)
        }
    }

    // FIXME: document.
    public static func style(_ style: some ShapeStyle) -> Self {
        .mutate {
            $0.horizontalConfiguration.shapeStyle = AnyShapeStyle(style)
            $0.verticalConfiguration.shapeStyle = AnyShapeStyle(style)
        }
    }

    // FIXME: document.
    public static func length(
        horizontal: DebugAxisAlignmentConfigurationLength? = nil,
        vertical: DebugAxisAlignmentConfigurationLength? = nil
    ) -> Self {
        .mutate {
            if let horizontal { $0.horizontalConfiguration.length = horizontal }
            if let vertical   { $0.verticalConfiguration.length   = vertical }
        }
    }

    // FIXME: document.
    public static func length(_ lengths: DebugAxisAlignmentConfigurationLength) -> Self {
        .mutate {
            $0.horizontalConfiguration.length = lengths
            $0.verticalConfiguration.length = lengths
        }
    }

    // FIXME: document.
    public static var containerLength: Self {
        .length(.container)
    }

    // FIXME: document.
    public static func fixedLength(_ length: CGFloat) -> Self {
        .length(.fixed(length))
    }

    public static func fixedLength(horizontal: CGFloat? = nil , vertical: CGFloat? = nil) -> Self {
        .mutate {
            if let horizontal { $0.horizontalConfiguration.length = .fixed(horizontal) }
            if let vertical   { $0.verticalConfiguration.length =   .fixed(vertical) }
        }
    }

    // FIXME: document.
    public static func extendLength(_ addition: CGFloat) -> Self {
        .length(.extended(addition))
    }

    // FIXME: document.
    public static func extendLength(horizontal: CGFloat? = nil , vertical: CGFloat? = nil) -> Self {
        .mutate {
            if let horizontal { $0.horizontalConfiguration.length = .extended(horizontal) }
            if let vertical   { $0.verticalConfiguration.length =   .extended(vertical) }
        }
    }

    // FIXME: document.
    public static func scaleLength(_ factor: CGFloat) -> Self {
        .length(.scaled(factor))
    }

    // FIXME: document.
    public static func scaleLength(horizontal: CGFloat? = nil , vertical: CGFloat? = nil) -> Self {
        .mutate {
            if let horizontal { $0.horizontalConfiguration.length = .scaled(horizontal) }
            if let vertical   { $0.verticalConfiguration.length =   .scaled(vertical) }
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
            configuration.horizontalConfiguration.opacity = opacity
            configuration.verticalConfiguration.opacity = opacity
        }
    }

    struct Anchor: ConfigurationModifier {
        let anchor: Alignment
        func update(configuration: inout Configuration) {
            configuration.horizontalConfiguration.anchor = anchor.vertical
            configuration.verticalConfiguration.anchor = anchor.horizontal
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


public typealias DebugHorizontalAlignmentGuideModifier = DebugAxisAlignmentGuideModifier<HorizontalAlignment>
public typealias DebugVerticalAlignmentGuideModifier   = DebugAxisAlignmentGuideModifier<VerticalAlignment>


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
public struct DebugAxisAlignmentGuideConfiguration<AxisAlignment>: DebugAxisAlignmentGuideConfigurationProtocol
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


extension DebugAxisAlignmentGuideConfiguration: TraitInitializable {
    // init() defined in struct declaration.
}


// MARK: - ConfigurationLength


// FIXME: Document.
public enum DebugAxisAlignmentConfigurationLength {
    case container
    case fixed(CGFloat)
    case extended(CGFloat)
    case scaled(CGFloat)
}


// MARK: - Single Axis Traits


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
        _ traits: DebugHorizontalAlignmentGuideModifier.Trait...
    ) -> some View {
        let configuration = DebugHorizontalAlignmentGuideModifier.Configuration(traits: traits)
        let guideModifier = DebugAxisAlignmentGuideModifier(
            axisAlignment: horizontalAlignment,
            configuration: configuration
        )
        return modifier(guideModifier)
    }

    public func debugAlignmentGuide(
        vertical verticalAlignment: VerticalAlignment,
        _ traits: DebugVerticalAlignmentGuideModifier.Trait...
    ) -> some View {
        let configuration = DebugVerticalAlignmentGuideModifier.Configuration(traits: traits)
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

    /// A single-line text that measures exactly 120 points per side.
    static let single: some View =
        Text("Ag")
        .font(.title.pointSize(150))
        .multilineTextAlignment(.leading)
        .minimumScaleFactor(.leastNormalMagnitude)
        .frame(squareOf: 120, alignment: .center)
        .border(.green.tertiary, width: 8)

    /// A multi-line text that measures exactly 120 points per side.
    static let multi: some View =
        Text("Sphinx\nof Black\nQuartz")
        .font(.title.pointSize(50))
        .multilineTextAlignment(.leading)
        .minimumScaleFactor(.leastNormalMagnitude)
        .frame(squareOf: 120, alignment: .leading)
        .border(.green.tertiary, width: 8)

    static let square: some View =
        Rectangle()
        .fill(.green.quinary)
        .border(.green.tertiary, width: 8)
        .frame(squareOf: 100)

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


#Preview("Traits", traits: .spacing(30), .headerFooter, PreviewContent.layout) {
    PreviewContent.single
    .floatingCaption("Extended", .alignment(.outerLeading))
    .edgeGraticule(
        spacing: 10,
        .outset(.horizontal, spacing: 25),
        .inset(.vertical, spacing: 20),
        .inset(.horizontal, spacing: 25)
    )
    .debugAlignmentGuide(
        .topLeading,
        .length(horizontal: .extended(20), vertical: .extended(50))
    )
    .debugAlignmentGuide(
        .bottomTrailing,
        .length(horizontal: .extended(-40), vertical: .extended(-50))
    )

    DashedDivider()

    PreviewContent.single
    .floatingCaption("Extended\n& Anchored", .alignment(.outerLeading))
    .edgeGraticule(
        spacing: 20,
        .outset(.horizontal, spacing: 25, count: 2),
        .inset(.all, spacing: 25, count: 2),
    )
    .debugAlignmentGuide(
        .topLeading,
        .anchor(.topLeading),
        .length(horizontal: .extended(20), vertical: .extended(50))
    )
    .debugAlignmentGuide(
        .centerLastTextBaseline,
        .anchor(.bottomTrailing),
        .length(horizontal: .extended(-50), vertical: .extended(-50))
    )
}


#Preview("Horizontal", traits: .spacing(50), .headerFooter, PreviewContent.layout) {
    PreviewContent.square
    .floatingCaption("Fixed", .alignment(.outerLeading))
    .edgeGraticule(spacing: 25)
    .debugAlignmentGuide(horizontal: .leading, .fixedLength(50))
    .debugAlignmentGuide(horizontal: .center, .fixedLength(50), .anchor(.firstTextBaseline))
    .debugAlignmentGuide(horizontal: .trailing, .fixedLength(150))

    DashedDivider()

    PreviewContent.single
    .floatingCaption("Extended", .alignment(.outerLeading))
    .edgeGraticule(spacing: 20, .inset(.bottom, count: 2), .outset(.top, count: 2))
    .debugAlignmentGuide(horizontal: .leading, .extendLength(40), .anchor(.bottom))
    .debugAlignmentGuide(horizontal: .center, .extendLength(-40), .anchor(.top))
    .debugAlignmentGuide(horizontal: .trailing, .extendLength(20), .anchor(.firstTextBaseline))

    DashedDivider()

    PreviewContent.square
    .floatingCaption("Scaled", .alignment(.outerLeading))
    .edgeGraticule(spacing: 20, .outset(.vertical, count: 2))
    .debugAlignmentGuide(horizontal: .leading, .scaleLength(1.2), .anchor(.firstTextBaseline))
    .debugAlignmentGuide(horizontal: .center, .scaleLength(0.6), )
    .debugAlignmentGuide(horizontal: .trailing, .scaleLength(1.4), .anchor(.top))
}


#Preview("Vertical", traits: .spacing(30), .headerFooter, PreviewContent.layout) {
    PreviewContent.multi
    .floatingCaption("Fixed", .alignment(.outerLeadingTop))
    .edgeGraticule(
        spacing: 20,
        // FIXME: implement trait both and use here.
        .inset(.horizontal, count: 2),
        .outset(.horizontal, count: 2)
    )
    .debugAlignmentGuide(vertical: .top, .fixedLength(80))
    .debugAlignmentGuide(vertical: .firstTextBaseline, .fixedLength(160), .anchor(.trailing))
    .debugAlignmentGuide(vertical: .verticalCenter, .fixedLength(160), .anchor(.center))
    .debugAlignmentGuide(vertical: .lastTextBaseline, .fixedLength(140), .anchor(.leading))
    .debugAlignmentGuide(vertical: .bottom, .fixedLength(40))

    DashedDivider()

    PreviewContent.multi
    .floatingCaption("Extended", .alignment(.outerLeadingTop))
    .edgeGraticule(
        spacing: 20,
        .inset(.horizontal, count: 2),
        .outset(.horizontal, count: 2)
    )
    .debugAlignmentGuide(vertical: .top, .extendLength(-40))
    .debugAlignmentGuide(vertical: .firstTextBaseline, .extendLength(40), .anchor(.trailing))
    .debugAlignmentGuide(vertical: .verticalCenter, .extendLength(40), .anchor(.center))
    .debugAlignmentGuide(vertical: .lastTextBaseline, .extendLength(40), .anchor(.leading))
    .debugAlignmentGuide(vertical: .bottom, .extendLength(40))

    DashedDivider()

    PreviewContent.multi
    .floatingCaption("Scaled", .alignment(.outerLeadingTop))
    .edgeGraticule(
        spacing: 24,
        .inset(.horizontal, count: 2),
        .outset(.horizontal, count: 3)
    )
    .debugAlignmentGuide(vertical: .top, .scaleLength(1.4))
    .debugAlignmentGuide(vertical: .firstTextBaseline, .scaleLength(1.6), .anchor(.trailing))
    .debugAlignmentGuide(vertical: .verticalCenter, .scaleLength(0.6), .anchor(.center))
    .debugAlignmentGuide(vertical: .lastTextBaseline, .scaleLength(1.4), .anchor(.leading))
    .debugAlignmentGuide(vertical: .bottom, .scaleLength(0.2))
}


#Preview("Offset", traits: .spacing(30), .headerFooter, PreviewContent.layout) {
    PreviewContent.single
    .floatingCaption("Horizontal", .alignment(.outerLeading))
    .edgeGraticule(spacing: 20)

    .debugAlignmentGuide(horizontal: .leading, .style(.indigo.secondary))
    .alignmentGuide(.leading, offsetBy: 20)
    .debugAlignmentGuide(horizontal: .leading)

    .debugAlignmentGuide(horizontal: .trailing, .style(.indigo.secondary))
    .alignmentGuide(.trailing, offsetBy: 20)
    .debugAlignmentGuide(horizontal: .trailing)

    DashedDivider()

    PreviewContent.single
    .floatingCaption("Vertical", .alignment(.outerLeading))
    .edgeGraticule(spacing: 20)

    .debugAlignmentGuide(vertical: .top, .style(.indigo.secondary))
    .alignmentGuide(.top, offsetBy: 20)
    .debugAlignmentGuide(vertical: .top)

    .debugAlignmentGuide(vertical: .firstTextBaseline, .style(.indigo.secondary))
    .alignmentGuide(.firstTextBaseline, offsetBy: -20)
    .debugAlignmentGuide(vertical: .firstTextBaseline)

    .debugAlignmentGuide(vertical: .bottom, .style(.indigo.secondary))
    .alignmentGuide(.bottom, offsetBy: 20)
    .debugAlignmentGuide(vertical: .bottom)
}
