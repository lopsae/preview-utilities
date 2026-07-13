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
        var horizontalAddition: CGFloat = .zero
        var verticalAddition: CGFloat = .zero
        var anchor: Alignment = .center

        public init() {}

        var horizontalConfiguration: DebugAxisAlignmentGuideConfiguration<HorizontalAlignment> {
            var resultConfiguration = DebugAxisAlignmentGuideConfiguration<HorizontalAlignment>()
            resultConfiguration.opacity = opacity
            resultConfiguration.lengthAddition = horizontalAddition
            resultConfiguration.anchor = anchor.vertical
            return resultConfiguration
        }

        var verticalConfiguration: DebugAxisAlignmentGuideConfiguration<VerticalAlignment> {
            var resultConfiguration = DebugAxisAlignmentGuideConfiguration<VerticalAlignment>()
            resultConfiguration.opacity = opacity
            resultConfiguration.lengthAddition = verticalAddition
            resultConfiguration.anchor = anchor.horizontal
            return resultConfiguration
        }

    }

}


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
    public static func lengthAddition(_ horizontalAddition: CGFloat, _ verticalAddition: CGFloat) -> Self {
        .mutate {
            $0.horizontalAddition = horizontalAddition
            $0.verticalAddition = verticalAddition
        }
    }

    public static func lengthAddition(horz: CGFloat = .zero, vert: CGFloat = .zero) -> Self {
        .lengthAddition(horz, vert)
    }

    // FIXME: document.
    public static func anchor(_ anchor: Alignment) -> Self {
        .modifier(Modifiers.Anchor(anchor: anchor))
    }

}


// FIXME: implement fixed length too.


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
            let axisUnitSize = axisAlignment.axis.unitSize
            let extendedSize = axisUnitSize.transposed.multiplying(by: configuration.lengthAddition)
            ExtendedSizeLayout(addWidth: extendedSize.width , addHeight: extendedSize.height) {
                let lineWidth: CGFloat = 2
                AxialLine(axisAlignment.axis.orthogonal, style: .red.secondary, lineWidth: lineWidth)
            }
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
public protocol DebugAxisAlignmentGuideConfigurationProtocol {
    associatedtype AnchorAlignment: AlignmentWithDefault
    var opacity: Double { get set }
    var lengthAddition: CGFloat { get set }
    var anchor: AnchorAlignment { get set }

}


public struct DebugAxisAlignmentGuideConfiguration<AxisAlignment>: DebugAxisAlignmentGuideConfigurationProtocol, TraitConfigurable
where
    AxisAlignment: AlignmentWithOrthogonal,
    AxisAlignment.OrthogonalAlignment: AlignmentWithDefault
{
    public typealias AnchorAlignment = AxisAlignment.OrthogonalAlignment
    public var opacity: Double = .one
    public var lengthAddition: CGFloat = .zero
    public var anchor: AnchorAlignment = .default
    public init() {}
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
    public static func addLength(_ addition: CGFloat) -> Self {
        .modifier(DebugAxisAlignmentModifiers.LengthAddition(lengthAddition: addition))
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

    struct LengthAddition: ConfigurationModifier {
        let lengthAddition: CGFloat
        func update(configuration: inout Configuration) {
            configuration.lengthAddition = lengthAddition
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
public protocol AlignmentWithOrthogonal {
    associatedtype OrthogonalAlignment
    var axis: Axis { get }
    func alignment(withOrthogonal orthogonalAlignment: OrthogonalAlignment) -> Alignment
}


extension HorizontalAlignment: AlignmentWithOrthogonal {
    public typealias OrthogonalAlignment = VerticalAlignment
    public var axis: Axis { .horizontal }
    public func alignment(withOrthogonal orthogonalAlignment: OrthogonalAlignment) -> Alignment {
        .init(horizontal: self, vertical: orthogonalAlignment)
    }
}


extension VerticalAlignment: AlignmentWithOrthogonal {
    public typealias OrthogonalAlignment = HorizontalAlignment
    public var axis: Axis { .vertical }
    public func alignment(withOrthogonal orthogonalAlignment: OrthogonalAlignment) -> Alignment {
        .init(horizontal: orthogonalAlignment, vertical: self)
    }
}


public protocol AlignmentWithDefault {
    static var `default`: Self { get }
}

extension HorizontalAlignment: AlignmentWithDefault {
    public static var `default`: Self { .center }
}


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

}


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(.topLeading)
    .debugAlignmentGuide(.centerFirstTextBaseline)
    .debugAlignmentGuide(.bottomTrailing)
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(horizontal: .leading)
    .debugAlignmentGuide(horizontal: .center)
    .debugAlignmentGuide(horizontal: .trailing)
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Sphinx\nof Black\nQuartz")
    .fixedSize()
    .font(.largeTitle)
    .debugAlignmentGuide(vertical: .top)
    .debugAlignmentGuide(vertical: .firstTextBaseline)
    .debugAlignmentGuide(vertical: .verticalCenter)
    .debugAlignmentGuide(vertical: .lastTextBaseline)
    .debugAlignmentGuide(vertical: .bottom)
    .border(.green.tertiary, width: 8)
}


#Preview("Traits", traits: .paddingSpacing, .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(.topLeading, .lengthAddition(20, 50), )
    .debugAlignmentGuide(.bottomTrailing, .lengthAddition(-50, -50))
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(.topLeading, .lengthAddition(20, 50), .anchor(.topLeading))
    .debugAlignmentGuide(.centerLastTextBaseline, .lengthAddition(-50, -50), .anchor(.bottomTrailing))
    .border(.green.tertiary, width: 8)
}


#Preview("Horizontal", traits: .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(horizontal: .leading)
    .debugAlignmentGuide(horizontal: .center)
    .debugAlignmentGuide(horizontal: .trailing)
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .alignmentGuide(.leading, offsetBy: 10)
    .debugAlignmentGuide(horizontal: .leading, .addLength(50), .anchor(.bottom))
    .alignmentGuide(.trailing, offsetBy: -10)
    .debugAlignmentGuide(horizontal: .trailing, .addLength(50), .anchor(.top))
    .debugAlignmentGuide(horizontal: .center, .anchor(.firstTextBaseline))
    .border(.green.tertiary, width: 8)
}


#Preview("Vertical", traits: .fixedHeader, PreviewContent.layout) {
    Text("Sphinx\nof Black\nQuartz")
    .font(.largeTitle)
    .debugAlignmentGuide(vertical: .top)
    .debugAlignmentGuide(vertical: .firstTextBaseline)
    .debugAlignmentGuide(vertical: .verticalCenter)
    .debugAlignmentGuide(vertical: .lastTextBaseline)
    .debugAlignmentGuide(vertical: .bottom)
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Sphinx\nof Black\nQuartz")
    .font(.largeTitle)
    .debugAlignmentGuide(vertical: .top)
    .debugAlignmentGuide(vertical: .firstTextBaseline, .addLength(50), .anchor(.leading))
    .debugAlignmentGuide(vertical: .verticalCenter, .addLength(100))
    .debugAlignmentGuide(vertical: .lastTextBaseline, .addLength(50), .anchor(.trailing))
    .debugAlignmentGuide(vertical: .bottom)
    .border(.green.tertiary, width: 8)
}
