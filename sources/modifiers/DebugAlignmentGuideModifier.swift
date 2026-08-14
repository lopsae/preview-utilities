//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Overlays a visual representations of a view's alignment guides.
///
/// Displays in an overlay a visual representation of a view's alignment guides. All content added
/// by this modifier is layered in an overlay of the owner view, the original layout is never
/// modified.
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


    /// Configuration of a `DebugAlignmentGuideModifier`.
    ///
    /// Contains the configurations for the horizontal and vertical guide visualizations.
    ///
    /// Usually you don't build this object directly, instead one is created and configured using
    /// the [`Trait`](doc:DebugAlignmentGuideModifier/Trait) instances passed to
    /// ``SwiftUICore/View/debugAlignmentGuide(_:_:)``:
    public struct Configuration: TraitInitializable {

        enum Modifiers {}

        /// Configuration for the horizontal alignment guide visualization.
        public var horizontalConfiguration: DebugAxisAlignmentGuideConfiguration<HorizontalAlignment> = .init()
        /// Configuration for the vertical alignment guide visualization.
        public var verticalConfiguration: DebugAxisAlignmentGuideConfiguration<VerticalAlignment> = .init()

        public init() {}

    }

}


// MARK: - Composite Traits


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

    typealias Modifiers = Configuration.Modifiers

    // FIXME: document.
    public static var hidden: DebugAlignmentGuideModifier.Trait {
        .modifier(Modifiers.Opacity(opacity: .zero))
    }

    // FIXME: document.
    public static func visible(_ isVisible: Bool) -> DebugAlignmentGuideModifier.Trait {
        .modifier(Modifiers.Opacity(opacity: isVisible ? .one : .zero))
    }

    // FIXME: document.
    public static func opacity(_ opacity: Double) -> DebugAlignmentGuideModifier.Trait {
        .modifier(Modifiers.Opacity(opacity: opacity))
    }

    // FIXME: document.
    public static func style(_ style: some ShapeStyle) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            $0.horizontalConfiguration.shapeStyle = AnyShapeStyle(style)
            $0.verticalConfiguration.shapeStyle = AnyShapeStyle(style)
        }
    }

    // FIXME: document.
    public static func style(horizontal: some ShapeStyle) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            $0.horizontalConfiguration.shapeStyle = AnyShapeStyle(horizontal)
        }
    }

    // FIXME: document.
    public static func style(vertical: some ShapeStyle) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            $0.verticalConfiguration.shapeStyle = AnyShapeStyle(vertical)
        }
    }

    // FIXME: document.
    public static func style(
        horizontal: some ShapeStyle,
        vertical: some ShapeStyle
    ) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            $0.horizontalConfiguration.shapeStyle = AnyShapeStyle(horizontal)
            $0.verticalConfiguration.shapeStyle = AnyShapeStyle(vertical)
        }
    }

    // FIXME: document.
    public static func lineWidth(_ lineWidth: CGFloat) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            $0.horizontalConfiguration.lineWidth = lineWidth
            $0.verticalConfiguration.lineWidth   = lineWidth
        }
    }

    // FIXME: document.
    public static func lineWidth(horizontal: CGFloat? = nil , vertical: CGFloat? = nil) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            if let horizontal { $0.horizontalConfiguration.lineWidth = horizontal }
            if let vertical   { $0.verticalConfiguration.lineWidth =   vertical }
        }
    }

    // FIXME: document.
    public static func length(_ lengths: DebugAxisAlignmentConfigurationLength) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            $0.horizontalConfiguration.length = lengths
            $0.verticalConfiguration.length   = lengths
        }
    }

    // FIXME: document.
    public static func length(
        horizontal: DebugAxisAlignmentConfigurationLength? = nil,
        vertical: DebugAxisAlignmentConfigurationLength? = nil
    ) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            if let horizontal { $0.horizontalConfiguration.length = horizontal }
            if let vertical   { $0.verticalConfiguration.length   = vertical }
        }
    }

    // FIXME: document.
    public static var containerLength: DebugAlignmentGuideModifier.Trait {
        .length(.container)
    }

    // FIXME: document.
    public static func fixedLength(_ length: CGFloat) -> DebugAlignmentGuideModifier.Trait {
        .length(.fixed(length))
    }

    // FIXME: document.
    public static func fixedLength(horizontal: CGFloat? = nil , vertical: CGFloat? = nil) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            if let horizontal { $0.horizontalConfiguration.length = .fixed(horizontal) }
            if let vertical   { $0.verticalConfiguration.length =   .fixed(vertical) }
        }
    }

    // FIXME: document.
    public static func extendedLength(_ addition: CGFloat) -> DebugAlignmentGuideModifier.Trait {
        .length(.extended(addition))
    }

    // FIXME: document.
    public static func extendedLength(horizontal: CGFloat? = nil , vertical: CGFloat? = nil) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            if let horizontal { $0.horizontalConfiguration.length = .extended(horizontal) }
            if let vertical   { $0.verticalConfiguration.length =   .extended(vertical) }
        }
    }

    // FIXME: document.
    public static func scaledLength(_ factor: CGFloat) -> DebugAlignmentGuideModifier.Trait {
        .length(.scaled(factor))
    }

    // FIXME: document.
    public static func scaledLength(horizontal: CGFloat? = nil , vertical: CGFloat? = nil) -> DebugAlignmentGuideModifier.Trait {
        .mutate {
            if let horizontal { $0.horizontalConfiguration.length = .scaled(horizontal) }
            if let vertical   { $0.verticalConfiguration.length =   .scaled(vertical) }
        }
    }

    // FIXME: document.
    public static func anchor(_ anchor: Alignment) -> DebugAlignmentGuideModifier.Trait {
        .modifier(Modifiers.Anchor(anchor: anchor))
    }

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
