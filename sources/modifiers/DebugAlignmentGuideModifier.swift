//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Overlays a visual representations of a view's alignment guides.
///
/// Displays in an overlay a visual representation of a view's alignment guides. The alignment
/// markers added by this modifier are layered in an overlay of the owner view, the original layout
/// is never modified.
///
/// Apply this modifier using ``SwiftUICore/View/debugAlignmentGuide(_:_:)``:
///
/// ```swift
/// Text("Sphinx of Black Quartz\nJudge my Vow")
/// .font(.title)
/// .debugAlignmentGuide(.leadingLastTextBaseline)
/// ```
/// ![Text displaying a leading last text baseline alignment guide with the default configuration.](debug-alignment-guide-default)
///
///
/// ### Traits and Configuration
///
/// The overlay can be configured by passing [`Trait`](doc:DebugAlignmentGuideModifier/Trait) instances to
/// ``SwiftUICore/View/debugAlignmentGuide(_:_:)``:
///
/// ```swift
/// Text("Lately I saw a house.\nIt was burning.")
/// .font(.title)
/// .multilineTextAlignment(.center)
/// .debugAlignmentGuide(.centerFirstTextBaseline,
///     .style(.mint.secondary),        // Styles both markers to mint.
///     .lineWidth(vertical: 8),        // Sets the vertical line width.
///     .extendedLength(horizontal: 40) // Extends the horizontal marker by 40.
/// )
/// ```
/// ![Text displaying a center first text baseline alignment guide using example traits.](debug-alignment-guide-explained-traits)
public struct DebugAlignmentGuideModifier: ViewModifier {

    let alignment: Alignment
    let configuration: Configuration

    @_documentation(visibility: internal)
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


    // MARK: Configuration

    /// Configuration of a `DebugAlignmentGuideModifier`.
    ///
    /// Contains the configurations for the horizontal and vertical guide visualizations.
    ///
    /// Usually you don't build this object directly, instead one is created and configured using
    /// the [`Trait`](doc:DebugAlignmentGuideModifier/Trait) instances passed to
    /// ``SwiftUICore/View/debugAlignmentGuide(_:_:)``:
    public struct Configuration: TraitInitializable {

        /// Configuration for the horizontal alignment guide visualization.
        public var horizontalConfiguration: DebugAxisAlignmentGuideConfiguration<HorizontalAlignment> = .init()
        /// Configuration for the vertical alignment guide visualization.
        public var verticalConfiguration: DebugAxisAlignmentGuideConfiguration<VerticalAlignment> = .init()

        public init() {}

    }

}


// MARK: - Traits


extension DebugAlignmentGuideModifier {

    /// Customizations that can be applied to the configuration of a `DebugAlignmentGuideModifier`.
    ///
    /// ## Topics
    ///
    /// ### Visibility Traits
    /// + ``ConfigurationTrait/hidden-5k6lf``
    /// + ``ConfigurationTrait/visible(_:)->DebugAlignmentGuideModifier.Trait``
    /// + ``ConfigurationTrait/opacity(_:)->DebugAlignmentGuideModifier.Trait``
    ///
    /// ### Style Traits
    /// + ``ConfigurationTrait/style(_:)->ConfigurationTrait<Configuration>``
    /// + ``ConfigurationTrait/style(horizontal:)``
    /// + ``ConfigurationTrait/style(vertical:)``
    /// + ``ConfigurationTrait/style(horizontal:vertical:)``
    /// + ``ConfigurationTrait/lineWidth(_:)->DebugAlignmentGuideModifier.Trait``
    /// + ``ConfigurationTrait/lineWidth(horizontal:vertical:)``
    ///
    /// ### Length Traits
    /// + ``ConfigurationTrait/length(_:)->DebugAlignmentGuideModifier.Trait``
    /// + ``ConfigurationTrait/length(horizontal:vertical:)``
    /// + ``ConfigurationTrait/containerLength-9z2fj``
    /// + ``ConfigurationTrait/fixedLength(_:)->DebugAlignmentGuideModifier.Trait``
    /// + ``ConfigurationTrait/fixedLength(horizontal:vertical:)``
    /// + ``ConfigurationTrait/extendedLength(_:)->DebugAlignmentGuideModifier.Trait``
    /// + ``ConfigurationTrait/extendedLength(horizontal:vertical:)``
    /// + ``ConfigurationTrait/scaledLength(_:)->DebugAlignmentGuideModifier.Trait``
    /// + ``ConfigurationTrait/scaledLength(horizontal:vertical:)``
    /// + ``ConfigurationTrait/anchor(_:)->DebugAlignmentGuideModifier.Trait``
    public typealias Trait = ConfigurationTrait<Configuration>

}


extension DebugAlignmentGuideModifier.Trait {

    // MARK: Visibility

    /// Hides the entire contents of the modifier.
    ///
    /// Equivalent to setting ``ConfigurationTrait/opacity(_:)->DebugAlignmentGuideModifier.Trait``
    /// to zero.
    public static var hidden: DebugAlignmentGuideModifier.Trait {
        .modifier(Configuration.Modifiers.Opacity(opacity: .zero))
    }

    /// Sets the visibility of the modifier contents.
    ///
    /// Equivalent to setting ``ConfigurationTrait/opacity(_:)->DebugAlignmentGuideModifier.Trait``
    /// to either one or zero.
    ///
    /// - Parameter isVisible: A Boolean value that determines if the modifier contents are visible.
    public static func visible(_ isVisible: Bool) -> DebugAlignmentGuideModifier.Trait {
        .modifier(Configuration.Modifiers.Opacity(opacity: isVisible ? .one : .zero))
    }

    /// Sets the opacity of the modifier contents.
    /// - Parameter opacity: A value between 0 (fully transparent) and 1 (fully
    ///   opaque).
    public static func opacity(_ opacity: Double) -> DebugAlignmentGuideModifier.Trait {
        .modifier(Configuration.Modifiers.Opacity(opacity: opacity))
    }


    // MARK: Style

    /// Styles both alignment markers with the given `ShapeStyle`.
    /// - Parameter style: The shape style for the alignment marker strokes.
    public static func style(_ style: some ShapeStyle) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            $0.horizontalConfiguration.shapeStyle = AnyShapeStyle(style)
            $0.verticalConfiguration.shapeStyle = AnyShapeStyle(style)
        }
    }

    /// Styles the horizontal alignment marker with the given `ShapeStyle`.
    /// - Parameter horizontal: The shape style for the horizontal alignment marker stroke.
    public static func style(horizontal: some ShapeStyle) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            $0.horizontalConfiguration.shapeStyle = AnyShapeStyle(horizontal)
        }
    }

    /// Styles the vertical alignment marker with the given `ShapeStyle`.
    /// - Parameter vertical: The shape style for the vertical alignment marker stroke.
    public static func style(vertical: some ShapeStyle) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            $0.verticalConfiguration.shapeStyle = AnyShapeStyle(vertical)
        }
    }

    /// Styles each alignment marker with the given `ShapeStyle`.
    /// - Parameter horizontal: The shape style for the horizontal alignment marker stroke.
    /// - Parameter vertical: The shape style for the vertical alignment marker stroke.
    public static func style(
        horizontal: some ShapeStyle,
        vertical: some ShapeStyle
    ) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            $0.horizontalConfiguration.shapeStyle = AnyShapeStyle(horizontal)
            $0.verticalConfiguration.shapeStyle = AnyShapeStyle(vertical)
        }
    }

    /// Sets the width of the stroke of both alignment markers.
    /// - Parameter lineWidth: The width of the stroke of the alignment markers.
    public static func lineWidth(_ lineWidth: CGFloat) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            $0.horizontalConfiguration.lineWidth = lineWidth
            $0.verticalConfiguration.lineWidth   = lineWidth
        }
    }

    /// Sets the width of the stroke of each alignment marker.
    /// - Parameter horizontal: The width of the stroke of the horizontal alignment marker.
    /// - Parameter vertical: The width of the stroke of the vertical alignment marker.
    public static func lineWidth(horizontal: CGFloat? = nil , vertical: CGFloat? = nil) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            if let horizontal { $0.horizontalConfiguration.lineWidth = horizontal }
            if let vertical   { $0.verticalConfiguration.lineWidth =   vertical }
        }
    }


    // MARK: Length

    /// Sets the length option for both alignment markers.
    /// - Parameter lengths: The length option for both alignment markers.
    public static func length(_ lengths: DebugAxisAlignmentConfigurationLength) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            $0.horizontalConfiguration.length = lengths
            $0.verticalConfiguration.length   = lengths
        }
    }

    /// Sets the length option for each alignment marker.
    /// - Parameters:
    ///   - horizontal: The length option for the horizontal alignment marker.
    ///   - vertical: The length option for the vertical alignment marker.
    public static func length(
        horizontal: DebugAxisAlignmentConfigurationLength? = nil,
        vertical: DebugAxisAlignmentConfigurationLength? = nil
    ) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            if let horizontal { $0.horizontalConfiguration.length = horizontal }
            if let vertical   { $0.verticalConfiguration.length   = vertical }
        }
    }

    /// Sets both markers length option to
    /// [`container`](doc:DebugAxisAlignmentConfigurationLength/container).
    public static var containerLength: DebugAlignmentGuideModifier.Trait {
        .length(.container)
    }

    /// Sets both markers length option to
    /// [`fixed`](doc:DebugAxisAlignmentConfigurationLength/fixed(_:)) to the given value.
    /// - Parameter length: The fixed length of the alignment markers along the both axis.
    public static func fixedLength(_ length: CGFloat) -> DebugAlignmentGuideModifier.Trait {
        .length(.fixed(length))
    }

    /// Sets each marker length option to
    /// [`fixed`](doc:DebugAxisAlignmentConfigurationLength/fixed(_:)) to the given values.
    ///
    /// - Parameters:
    ///   - horizontal: The fixed length of the horizontal alignment marker along the vertical axis.
    ///   - vertical: The fixed length of the vertical alignment marker along the horizontal axis.
    public static func fixedLength(horizontal: CGFloat? = nil , vertical: CGFloat? = nil) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            if let horizontal { $0.horizontalConfiguration.length = .fixed(horizontal) }
            if let vertical   { $0.verticalConfiguration.length =   .fixed(vertical) }
        }
    }

    /// Sets both markers length option to
    /// [`extended`](doc:DebugAxisAlignmentConfigurationLength/extended(_:)) by the given values.
    /// - Parameter addition: The value to add to the owner's length along both axis.
    public static func extendedLength(_ addition: CGFloat) -> DebugAlignmentGuideModifier.Trait {
        .length(.extended(addition))
    }

    /// Sets each marker length option to
    /// [`extended`](doc:DebugAxisAlignmentConfigurationLength/extended(_:)) by the given value.
    ///
    /// - Parameters:
    ///   - horizontal: The value to add to the owner's vertical length for the horizontal marker.
    ///   - vertical: The value to add to the owner's horizontal length for the vertical marker.
    public static func extendedLength(horizontal: CGFloat? = nil , vertical: CGFloat? = nil) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            if let horizontal { $0.horizontalConfiguration.length = .extended(horizontal) }
            if let vertical   { $0.verticalConfiguration.length =   .extended(vertical) }
        }
    }

    /// Sets both markers length option to
    /// [`scaled`](doc:DebugAxisAlignmentConfigurationLength/scaled(_:)) by the given values.
    /// - Parameter factor: The factor to multiply by the owner's length along both axis.
    public static func scaledLength(_ factor: CGFloat) -> DebugAlignmentGuideModifier.Trait {
        .length(.scaled(factor))
    }

    /// Sets each marker length option to
    /// [`scaled`](doc:DebugAxisAlignmentConfigurationLength/scaled(_:)) by the given value.
    ///
    /// - Parameters:
    ///   - horizontal: The factor to multiply by the owner's vertical length for the horizontal marker.
    ///   - vertical: The factor to multiply by the owner's horizontal length for the vertical marker.
    public static func scaledLength(horizontal: CGFloat? = nil , vertical: CGFloat? = nil) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            if let horizontal { $0.horizontalConfiguration.length = .scaled(horizontal) }
            if let vertical   { $0.verticalConfiguration.length =   .scaled(vertical) }
        }
    }

    /// Anchors the alignment markers to the given alignment.
    ///
    /// When the length of any alignment marker is configured to be different that the owner's view
    /// size, the alignment marker itself can be aligned to the alignment guide.
    ///
    /// The default alignment for the markers is `center`.
    ///
    /// - Parameter anchor: The alignment to which to align the markers.
    public static func anchor(_ anchor: Alignment) -> DebugAlignmentGuideModifier.Trait {
        .modifier(Configuration.Modifiers.Anchor(anchor: anchor))
    }

}


extension DebugAlignmentGuideModifier.Configuration {
    enum Modifiers {}
}


extension DebugAlignmentGuideModifier.Configuration.Modifiers {

    typealias Configuration = DebugAlignmentGuideModifier.Configuration

    struct Opacity: ConfigurationModifier {
        let opacity: Double
        func modify(configuration: inout Configuration) {
            configuration.horizontalConfiguration.opacity = opacity
            configuration.verticalConfiguration.opacity = opacity
        }
    }

    struct Anchor: ConfigurationModifier {
        let anchor: Alignment
        func modify(configuration: inout Configuration) {
            configuration.horizontalConfiguration.anchor = anchor.vertical
            configuration.verticalConfiguration.anchor = anchor.horizontal
        }
    }

}


// MARK: - View Extensions


extension View {

    /// Layers in front of this view a visual representation of the given alignment guide,
    /// customized with the given traits.
    ///
    /// Applies the ``DebugAlignmentGuideModifier`` customized with the given [`Trait`](doc:DebugAlignmentGuideModifier/Trait)
    /// instances, overlaying a visual representation of the given alignment.
    ///
    /// The traits are applied in the order they are passed to a default configuration. Later
    /// traits may override earlier ones depending on the configuration each trait modifies.
    ///
    /// - Parameters:
    ///   - alignment: The alignment to visualize.
    ///   - traits: The traits to customize the default configuration.
    ///
    /// - Returns: A view with a configured alignment guide visualization as foreground.
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
