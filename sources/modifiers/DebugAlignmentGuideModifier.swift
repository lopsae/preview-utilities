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

    // FIXME: Check if there are significant performance impacts between modifier and mutate
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
            Group {
                let lineWidth: CGFloat = 2
                let axialLine = AxialLine(axisAlignment.axis.orthogonal, style: .red.secondary, lineWidth: lineWidth)

                switch configuration.length {
                case .container:
                    axialLine
                case .extended(let addition):
                    let orthogonalUnitSize = axisAlignment.axis.orthogonal.unitSize
                    let extendedSize = orthogonalUnitSize.multiplying(by: addition)
                    ExtendedSizeLayout(addWidth: extendedSize.width, addHeight: extendedSize.height) {
                        axialLine
                    }
                    // FIXME: ExtendedSizeLayout is having issues when contained in a Group+Switch
                    // size is being recalculated multiple times, and thus being increased multiple times.
                    .debugOverlay(.height)
                }
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
    var length: DebugAxisAlignmentConfigurationLength { get set }
    var anchor: AnchorAlignment { get set }

}


public struct DebugAxisAlignmentGuideConfiguration<AxisAlignment>: DebugAxisAlignmentGuideConfigurationProtocol, TraitConfigurable
where
    AxisAlignment: AlignmentWithOrthogonal,
    AxisAlignment.OrthogonalAlignment: AlignmentWithDefault
{
    public typealias AnchorAlignment = AxisAlignment.OrthogonalAlignment
    public var opacity: Double = .one
    public var length: DebugAxisAlignmentConfigurationLength = .container
    public var anchor: AnchorAlignment = .default
    public init() {}
}


// MARK: - ConfigurationLength


public enum DebugAxisAlignmentConfigurationLength {
    case container
    case extended(CGFloat)

    // FIXME: implement.
//    case fixed(CGFloat)

    // FIXME: implement.
//    case factor(CGFloat)
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
    public static func length(_ length: DebugAxisAlignmentConfigurationLength) -> Self {
        .mutate{
            $0.length = length
        }
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
    .debugAlignmentGuide(.topLeading, .lengths(horizontal: .extended(20), vertical: .extended(50)))
    .debugAlignmentGuide(.bottomTrailing, .lengths(horizontal: .extended(-50), vertical: .extended(-50)))
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(.topLeading, .anchor(.topLeading), .lengths(horizontal: .extended(20), vertical: .extended(50)))
    .debugAlignmentGuide(.centerLastTextBaseline, .anchor(.bottomTrailing), .lengths(horizontal: .extended(-50), vertical: .extended(-50)))
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
    // FIXME: .extended causes display issues, the alignment marker ends up with a 20 addition.
    .debugAlignmentGuide(horizontal: .leading, .length(.extended(10)), .anchor(.bottom))
//    .alignmentGuide(.trailing, offsetBy: -10)
//    .debugAlignmentGuide(horizontal: .trailing, .length(.extended(50)), .anchor(.top))
//    .debugAlignmentGuide(horizontal: .center, .anchor(.firstTextBaseline))
    .floatingCaption("", .height, .alignment(.outerTrailingBottom))
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
    .debugAlignmentGuide(vertical: .firstTextBaseline, .length(.extended(50)), .anchor(.leading))
    .debugAlignmentGuide(vertical: .verticalCenter, .length(.extended(100)))
    .debugAlignmentGuide(vertical: .lastTextBaseline, .length(.extended(50)), .anchor(.trailing))
    .debugAlignmentGuide(vertical: .bottom)
    .border(.green.tertiary, width: 8)
}
