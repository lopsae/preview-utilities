//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Overlays a visual representation of a view's horizontal or vertical alignment guide.
///
/// Displays in an overlay a visual representation of a view's alignment guide for a single axis,
/// either horizontal or vertical. The alignment marker added by this modifier is layered in an
/// overlay of the owner view; the original layout is never modified.
///
/// Apply this modifier using ``SwiftUICore/View/debugAlignmentGuide(horizontal:_:)`` or
/// ``SwiftUICore/View/debugAlignmentGuide(vertical:_:)``:
///
/// ```swift
/// Text("Sphinx of Black Quartz\nJudge my Vow")
/// .font(.title)
/// .debugAlignmentGuide(horizontal: .trailing)
/// ```
/// ![Text displaying a horizontal trailing alignment markers with the default configuration.](debug-alignment-guide-default-single-axis)
///
///
/// ### Traits and Configuration
///
/// The overlay can be configured by passing [`Trait`](doc:DebugAxisAlignmentGuideModifier/Trait) instances to
/// ``SwiftUICore/View/debugAlignmentGuide(horizontal:_:)`` or ``SwiftUICore/View/debugAlignmentGuide(vertical:_:)``:
///
/// ```swift
/// Text("Lately I saw a house.\nIt was burning.")
/// .font(.title)
/// .multilineTextAlignment(.center)
/// .debugAlignmentGuide(
///     horizontal: .leading,
///     .style(.mint.secondary), // Styles markers to mint.
///     .lineWidth(8),           // Sets the line width.
///     .scaledLength(2)         // Scales the marker to double the owner size.
/// )
/// ```
/// ![Text displaying a horizontal leading alignment marker using example traits.](debug-alignment-guide-explained-traits-single-axis)
///
///
/// ## Aliases and Protocols
///
/// This modifier is setup to receive as a generic the alignment to work with, either
/// `HorizontalAlignment` or `VerticalAlignment`. Convenience aliases for the typed modifiers are
/// available at ``DebugHorizontalAlignmentGuideModifier`` and ``DebugVerticalAlignmentGuideModifier``.
///
/// The traits for this modifier are defined around a shared protocol ``DebugAxisAlignmentGuideConfigurationProtocol``
/// to share a single implementation for both vertical and horizontal alignment. The traits are
/// ultimately applied to the single implementation of this protocol: ``DebugAxisAlignmentGuideConfiguration``.
public struct DebugAxisAlignmentGuideModifier<AxisAlignment>: ViewModifier
where
    AxisAlignment: AlignmentWithOrthogonal,
    AxisAlignment.OrthogonalAlignment: AlignmentWithDefault
{

    /// The concrete type implementing `DebugAxisAlignmentGuideConfigurationProtocol`.
    public typealias ConcreteConfiguration = DebugAxisAlignmentGuideConfiguration<AxisAlignment>

    /// The trait type using `ConcreteConfiguration`.
    public typealias ConcreteTrait = ConfigurationTrait<ConcreteConfiguration>

    let axisAlignment: AxisAlignment
    let configuration: ConcreteConfiguration

    @_documentation(visibility: internal)
    public func body(content: Content) -> some View {
        let alignment = axisAlignment.alignment(withOrthogonal: configuration.anchor)
        content.overlay(alignment: alignment) {
            let axis = axisAlignment.axis
            let orthogonal = axis.orthogonal
            GeometryReader { geometry in
                let baseSize: CGSize = switch configuration.length {
                case .container, .extended: geometry.size
                case .fixed(let length):
                    geometry.size.setting(length: length, along: orthogonal)
                case .scaled(let multiplier):
                    geometry.size.multiplying(by: multiplier, along: orthogonal)
                }
                let additionalSize: CGSize = switch configuration.length {
                case .container, .fixed, .scaled: .zero
                case .extended(let addition):
                    orthogonal.unitSize.multiplying(by: addition)
                }

                // Final mark size is clamped to zero. Negative sizes produce a warning.
                let markSize = baseSize.adding(size: additionalSize).enveloping(.zero)

                AxialLine(orthogonal, style: configuration.shapeStyle, lineWidth: configuration.lineWidth)
                .frame(size: markSize)
                .frame(size: geometry.size, alignment: alignment)
            }
            .frame(length: configuration.lineWidth, along: axisAlignment.axis)
            .opacity(configuration.opacity)
            .allowsHitTesting(false)
        }
    }

}


/// Convenience alias of `DebugAxisAlignmentGuideModifier` for `HorizontalAlignment`.
public typealias DebugHorizontalAlignmentGuideModifier = DebugAxisAlignmentGuideModifier<HorizontalAlignment>
/// Convenience alias of `DebugAxisAlignmentGuideModifier` for `VerticalAlignment`.
public typealias DebugVerticalAlignmentGuideModifier   = DebugAxisAlignmentGuideModifier<VerticalAlignment>


// MARK: - Configuration


/// Protocol for the configuration of a `DebugAxisAlignmentGuideModifier`.
///
/// Provides the protocol for the configuration of both horizontal and vertical alignments
/// for ``DebugAxisAlignmentGuideModifier``.
///
/// [Traits](doc:DebugAxisAlignmentGuideModifier/Trait) for this modifier are defined in terms of
/// this protocol, so that the same implementation is available for both horizontal and vertical
/// alignments.
///
/// The modifier uses the implementing type ``DebugAxisAlignmentGuideConfiguration``.
nonisolated
public protocol DebugAxisAlignmentGuideConfigurationProtocol: Sendable {

    /// The alignment type to which the alignment marker is itself aligned.
    ///
    /// When the size of the alignment marker is customized through ``length``, the marker itself
    /// can be aligned to this anchor alignment of the owner view.
    ///
    /// The anchor alignment is expected to be the ``AlignmentWithOrthogonal/OrthogonalAlignment``
    /// the alignment type being visualized.
    associatedtype AnchorAlignment: AlignmentWithDefault

    /// The opacity of the alignment marker.
    var opacity: Double { get set }
    /// The shape style of the alignment marker line.
    var shapeStyle: AnyShapeStyle { get set }
    /// The line width of the alignment marker line.
    var lineWidth: CGFloat { get set }
    /// The length customization applied to the alignment marker.
    var length: DebugAxisAlignmentConfigurationLength { get set }
    /// The alignment to which the alignment marker is itself aligned.
    var anchor: AnchorAlignment { get set }

}


/// Concrete implementation of `DebugAxisAlignmentGuideConfigurationProtocol`.
///
/// Implementation of ``DebugAxisAlignmentGuideConfigurationProtocol`` used as configuration for
/// ``DebugAxisAlignmentGuideModifier``. A new instance contains the default configuration for the
/// modifier.
nonisolated
public struct DebugAxisAlignmentGuideConfiguration<AxisAlignment>: DebugAxisAlignmentGuideConfigurationProtocol
where
    AxisAlignment: AlignmentWithOrthogonal,
    AxisAlignment.OrthogonalAlignment: AlignmentWithDefault
{
    public typealias AnchorAlignment = AxisAlignment.OrthogonalAlignment
    public var opacity: Double = .one
    public var shapeStyle: AnyShapeStyle = AnyShapeStyle(.red.secondary)
    public var lineWidth: CGFloat = 2
    public var length: DebugAxisAlignmentConfigurationLength = .container
    public var anchor: AnchorAlignment = .default
    public init() {}
}


extension DebugAxisAlignmentGuideConfiguration: TraitInitializable {
    // init() already defined in struct declaration.
}


// MARK: - Length Enum


/// Customization options for the length of the alignment markers of `DebugAlignmentGuideModifier`
/// and `DebugAxisAlignmentGuideModifier`.
public enum DebugAxisAlignmentConfigurationLength {

    /// The alignment guide marker occupies the length of the owner view, along the alignment
    /// orthogonal axis.
    ///
    /// This is the default behavior for the alignment guide marker.
    case container

    /// The alignment guide marker occupies a fixed length along the alignment orthogonal axis.
    case fixed(CGFloat)

    /// The alignment guide marker occupies the length of the owner view plus the given value,
    /// along the alignment orthogonal axis.
    case extended(CGFloat)

    /// The alignment guide marker occupies the length of the owner view multiplied by the given
    /// factor, along the alignment orthogonal axis.
    case scaled(CGFloat)
}


// MARK: - Traits


extension DebugAxisAlignmentGuideModifier {

    /// Customizations that can be applied to the configuration of a `DebugAxisAlignmentGuideModifier`.
    ///
    /// ## Topics
    ///
    /// ### Visibility Traits
    /// + ``ConfigurationTrait/hidden-eo3z``
    /// + ``ConfigurationTrait/visible(_:)->ConfigurationTrait<Configuration>``
    /// + ``ConfigurationTrait/opacity(_:)->ConfigurationTrait<Configuration>``
    ///
    /// ### Style Traits
    /// + ``ConfigurationTrait/style(_:)->ConfigurationTrait<Configuration>``
    /// + ``ConfigurationTrait/lineWidth(_:)->ConfigurationTrait<Configuration>``
    ///
    /// ### Length Traits
    /// + ``ConfigurationTrait/length(_:)->ConfigurationTrait<Configuration>``
    /// + ``ConfigurationTrait/containerLength-589pa``
    /// + ``ConfigurationTrait/fixedLength(_:)->ConfigurationTrait<Configuration>``
    /// + ``ConfigurationTrait/extendedLength(_:)->ConfigurationTrait<Configuration>``
    /// + ``ConfigurationTrait/scaledLength(_:)->ConfigurationTrait<Configuration>``
    /// + ``ConfigurationTrait/anchor(_:)->ConfigurationTrait<Configuration>``
    public typealias Trait<C> = ConfigurationTrait<C> where C: DebugAxisAlignmentGuideConfigurationProtocol

}


extension DebugAxisAlignmentGuideModifier.Trait where Configuration: DebugAxisAlignmentGuideConfigurationProtocol {

    // MARK: Visibility

    /// Hides the entire contents of the modifier.
    ///
    /// Equivalent to setting ``ConfigurationTrait/opacity(_:)->ConfigurationTrait<Configuration>``
    /// to zero.
    public static var hidden: Self {
        .modifier(DebugAxisAlignmentModifiers.Opacity(opacity: .zero))
    }

    /// Sets the visibility of the modifier contents.
    /// 
    /// Equivalent to setting ``ConfigurationTrait/opacity(_:)->ConfigurationTrait<Configuration>``
    /// to either one or zero.
    ///
    /// - Parameter isVisible: A Boolean value that determines if the modifier contents are visible.
    public static func visible(_ isVisible: Bool) -> Self {
        .modifier(DebugAxisAlignmentModifiers.Opacity(opacity: isVisible ? .one : .zero))
    }

    /// Sets the opacity of the modifier contents.
    /// - Parameter opacity: A value between 0 (fully transparent) and 1 (fully
    ///   opaque).
    public static func opacity(_ opacity: Double) -> Self {
        .modifier(DebugAxisAlignmentModifiers.Opacity(opacity: opacity))
    }


    // MARK: Style

    /// Styles the alignment marker with the given `ShapeStyle`.
    /// - Parameter style: The shape style for the alignment marker stroke.
    public static func style(_ style: some ShapeStyle) -> Self {
        .mutate { $0.shapeStyle = AnyShapeStyle(style) }
    }

    /// Sets the width of the stroke of the alignment marker.
    /// - Parameter lineWidth: The width of the stroke of the alignment marker.
    public static func lineWidth(_ lineWidth: CGFloat) -> Self {
        .mutate { $0.lineWidth = lineWidth }
    }


    // MARK: Length

    /// Sets the length option for the alignment marker.
    /// - Parameter length: The length option for the alignment marker.
    public static func length(_ length: DebugAxisAlignmentConfigurationLength) -> Self {
        .mutate { $0.length = length }
    }

    /// Sets the marker length option to
    /// [`container`](doc:DebugAxisAlignmentConfigurationLength/container).
    public static var containerLength: Self {
        .length(.container)
    }

    /// Sets the marker length option to
    /// [`fixed`](doc:DebugAxisAlignmentConfigurationLength/fixed(_:)) to the given value.
    /// - Parameter length: The fixed length of the alignment marker along the orthogonal axis.
    public static func fixedLength(_ length: CGFloat) -> Self {
        .length(.fixed(length))
    }

    /// Sets the marker length option to
    /// [`extended`](doc:DebugAxisAlignmentConfigurationLength/extended(_:)) by the given value.
    /// - Parameter addition: The value to add to the owner's length along the orthogonal axis.
    public static func extendedLength(_ addition: CGFloat) -> Self {
        .length(.extended(addition))
    }

    /// Sets the marker length option to
    /// [`scaled`](doc:DebugAxisAlignmentConfigurationLength/scaled(_:)) by the given value.
    /// - Parameter factor: The factor to multiply by the owner's length along the orthogonal axis.
    public static func scaledLength(_ factor: CGFloat) -> Self {
        .length(.scaled(factor))
    }

    /// Anchors the alignment marker to the given orthogonal alignment.
    /// 
    /// When the length of the alignment marker is configured to be different that the owner's view
    /// size, the alignment marker itself can be aligned to the given orthogonal alignment guide.
    /// 
    /// The default alignment for the marker is the orthogonal `center` alignment.
    ///
    /// - Parameter anchor: The orthogonal alignment to which to align the marker.
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
        func modify(configuration: inout Configuration) {
            configuration.opacity = opacity
        }
    }

    struct Anchor: ConfigurationModifier {
        let anchor: Configuration.AnchorAlignment
        func modify(configuration: inout Configuration) {
            configuration.anchor = anchor
        }
    }

}


// MARK: - View Extensions


extension View {

    /// Layers in front of this view a visual representation of the given horizontal alignment
    /// guide, customized with the given traits.
    ///
    /// Applies the ``DebugHorizontalAlignmentGuideModifier`` customized with the given [`Trait`](doc:DebugAxisAlignmentGuideModifier/Trait)
    /// instances, overlaying a visual representation of the given horizontal alignment.
    /// 
    /// The traits are applied in the order they are passed to a default configuration. Later
    /// traits may override earlier ones depending on the configuration each trait modifies.
    /// 
    /// - Parameters:
    ///   - horizontalAlignment: The horizontal alignment to visualize.
    ///   - traits: The traits to customize the default configuration.
    ///
    /// - Returns: A view with a configured horizontal alignment guide visualization as foreground.
    public func debugAlignmentGuide(
        horizontal horizontalAlignment: HorizontalAlignment,
        _ traits: DebugHorizontalAlignmentGuideModifier.ConcreteTrait...
    ) -> some View {
        let configuration = DebugHorizontalAlignmentGuideModifier.ConcreteConfiguration(traits: traits)
        let guideModifier = DebugAxisAlignmentGuideModifier(
            axisAlignment: horizontalAlignment,
            configuration: configuration
        )
        return modifier(guideModifier)
    }


    /// Layers in front of this view a visual representation of the given vertical alignment
    /// guide, customized with the given traits.
    ///
    /// Applies the ``DebugVerticalAlignmentGuideModifier`` customized with the given [`Trait`](doc:DebugAxisAlignmentGuideModifier/Trait)
    /// instances, overlaying a visual representation of the given vertical alignment.
    ///
    /// The traits are applied in the order they are passed to a default configuration. Later
    /// traits may override earlier ones depending on the configuration each trait modifies.
    ///
    /// - Parameters:
    ///   - verticalAlignment: The vertical alignment to visualize.
    ///   - traits: The traits to customize the default configuration.
    ///
    /// - Returns: A view with a configured horizontal alignment guide visualization as foreground.
    public func debugAlignmentGuide(
        vertical verticalAlignment: VerticalAlignment,
        _ traits: DebugVerticalAlignmentGuideModifier.ConcreteTrait...
    ) -> some View {
        let configuration = DebugVerticalAlignmentGuideModifier.ConcreteConfiguration(traits: traits)
        let guideModifier = DebugAxisAlignmentGuideModifier(
            axisAlignment: verticalAlignment,
            configuration: configuration
        )
        return modifier(guideModifier)
    }

}


// MARK: - PreviewContent

// TODO: This content is reused here and in composite modifier, consider creating shared examples.

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


#Preview("Horizontal", traits: .spacing(50), .headerFooter, PreviewContent.layout) {
    PreviewContent.square
    .floatingCaption("Fixed", .alignment(.outerLeading))
    .edgeGraticule(spacing: 25)
    .debugAlignmentGuide(horizontal: .leading,  .fixedLength(50))
    .debugAlignmentGuide(horizontal: .center,   .fixedLength(50), .anchor(.firstTextBaseline))
    .debugAlignmentGuide(horizontal: .trailing, .fixedLength(150))

    DashedDivider()

    PreviewContent.single
    .floatingCaption("Extended", .alignment(.outerLeading))
    .edgeGraticule(spacing: 20, .inset(.bottom, count: 2), .outset(.top, count: 2))
    .debugAlignmentGuide(horizontal: .leading,  .extendedLength(40),  .anchor(.bottom))
    .debugAlignmentGuide(horizontal: .center,   .extendedLength(-40), .anchor(.top))
    .debugAlignmentGuide(horizontal: .trailing, .extendedLength(20),  .anchor(.firstTextBaseline))

    DashedDivider()

    PreviewContent.square
    .floatingCaption("Scaled", .alignment(.outerLeading))
    .edgeGraticule(spacing: 20, .outset(.vertical, count: 2))
    .debugAlignmentGuide(horizontal: .leading,  .scaledLength(1.2), .anchor(.firstTextBaseline))
    .debugAlignmentGuide(horizontal: .center,   .scaledLength(0.6), )
    .debugAlignmentGuide(horizontal: .trailing, .scaledLength(1.4), .anchor(.top))
}


#Preview("Vertical", traits: .spacing(30), .headerFooter, PreviewContent.layout) {
    PreviewContent.multi
    .floatingCaption("Fixed", .alignment(.outerLeadingTop))
    .edgeGraticule(
        spacing: 20,
        .straddle(.horizontal, count: 2)
    )
    .debugAlignmentGuide(vertical: .top,               .fixedLength(80))
    .debugAlignmentGuide(vertical: .firstTextBaseline, .fixedLength(160), .anchor(.trailing))
    .debugAlignmentGuide(vertical: .verticalCenter,    .fixedLength(160), .anchor(.center))
    .debugAlignmentGuide(vertical: .lastTextBaseline,  .fixedLength(140), .anchor(.leading))
    .debugAlignmentGuide(vertical: .bottom,            .fixedLength(40))

    DashedDivider()

    PreviewContent.multi
    .floatingCaption("Extended", .alignment(.outerLeadingTop))
    .edgeGraticule(
        spacing: 20,
        .straddle(.horizontal, count: 2)
    )
    .debugAlignmentGuide(vertical: .top,               .extendedLength(-40))
    .debugAlignmentGuide(vertical: .firstTextBaseline, .extendedLength(40), .anchor(.trailing))
    .debugAlignmentGuide(vertical: .verticalCenter,    .extendedLength(40), .anchor(.center))
    .debugAlignmentGuide(vertical: .lastTextBaseline,  .extendedLength(40), .anchor(.leading))
    .debugAlignmentGuide(vertical: .bottom,            .extendedLength(40))

    DashedDivider()

    PreviewContent.multi
    .floatingCaption("Scaled", .alignment(.outerLeadingTop))
    .edgeGraticule(
        spacing: 24,
        .inset(.horizontal, count: 2),
        .outset(.horizontal, count: 3)
    )
    .debugAlignmentGuide(vertical: .top,               .scaledLength(1.4))
    .debugAlignmentGuide(vertical: .firstTextBaseline, .scaledLength(1.6), .anchor(.trailing))
    .debugAlignmentGuide(vertical: .verticalCenter,    .scaledLength(0.6), .anchor(.center))
    .debugAlignmentGuide(vertical: .lastTextBaseline,  .scaledLength(1.4), .anchor(.leading))
    .debugAlignmentGuide(vertical: .bottom,            .scaledLength(0.2))
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
