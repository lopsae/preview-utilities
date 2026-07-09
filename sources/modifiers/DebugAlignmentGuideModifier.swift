//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct DebugAlignmentGuideModifier: ViewModifier {

    let alignment: Alignment

    func body(content: Content) -> some View {
        content
        .debugAlignmentGuide(horizontal: alignment.horizontal)
        .debugAlignmentGuide(vertical:   alignment.vertical)
    }

}


// MARK: - Single Axis


// FIXME: Figure out final names for protocols.


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
            let extendedSize = axisAlignment.unitSize.transposed.multiplying(by: configuration.lengthAddition)
            ExtendedSizeLayout(addWidth: extendedSize.width , addHeight: extendedSize.height) {
                let unitSize = axisAlignment.unitSize
                // FIXME: actually draw a line instead of rectangle.
                let lineWidth: CGFloat = 2
                Rectangle()
                .fill(.red.secondary)
                .frame(
                    width:  unitSize.width  == .zero ? nil : lineWidth,
                    height: unitSize.height == .zero ? nil : lineWidth
                )
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
    var unitSize: CGSize { get }
    func alignment(withOrthogonal orthogonalAlignment: OrthogonalAlignment) -> Alignment
}


extension HorizontalAlignment: AlignmentWithOrthogonal {
    public typealias OrthogonalAlignment = VerticalAlignment
    public var unitSize: CGSize { .init(width: CGFloat.one, height: .zero) }
    public func alignment(withOrthogonal orthogonalAlignment: OrthogonalAlignment) -> Alignment {
        .init(horizontal: self, vertical: orthogonalAlignment)
    }
}


extension VerticalAlignment: AlignmentWithOrthogonal {
    public typealias OrthogonalAlignment = HorizontalAlignment
    public var unitSize: CGSize { .init(width: CGFloat.zero, height: .one) }
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

    public func debugAlignmentGuide(_ alignment: Alignment) -> some View {
        return modifier(DebugAlignmentGuideModifier(alignment: alignment))
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


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.body.pointSize(60))
    .debugAlignmentGuide(.topLeading)
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(60))
    .debugAlignmentGuide(.centerCenter)
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(60))
    .debugAlignmentGuide(.trailingLastTextBaseline)
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
