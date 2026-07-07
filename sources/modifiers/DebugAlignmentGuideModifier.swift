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
        .debugAlignmentGuide(vertical:  alignment.vertical)
    }

}


// MARK: - Horizontal


public struct DebugHorizontalAlignmentGuideModifier: ViewModifier {

    let horizontalAlignment: HorizontalAlignment
    let configuration: Configuration

    public func body(content: Content) -> some View {
        let alignment = Alignment(horizontal: horizontalAlignment, vertical: configuration.anchor)
        content.overlay(alignment: alignment) {
            ExtendedSizeLayout(addHeight: configuration.heightAddition) {
                Rectangle()
                .fill(.red.secondary)
                .frame(width: 2)
            }
        }
    }

    public struct Configuration: TraitConfigurable {

        var isVisible: Bool = true
        var heightAddition: CGFloat = .zero
        var anchor: VerticalAlignment = .center

        public init() {}

    }


    public typealias Trait = ConfigurationTrait<Configuration>


    struct VisibilityModifier: ConfigurationModifier {
        let isVisible: Bool
        func update(configuration: inout Configuration) {
            configuration.isVisible = isVisible
        }
    }

    struct HeightAdditionModifier: ConfigurationModifier {
        let heightAddition: CGFloat
        func update(configuration: inout Configuration) {
            configuration.heightAddition = heightAddition
        }
    }

    struct AnchorModifier: ConfigurationModifier {
        let anchor: VerticalAlignment
        func update(configuration: inout Configuration) {
            configuration.anchor = anchor
        }
    }

}


extension ConfigurationTrait
where Configuration == DebugHorizontalAlignmentGuideModifier.Configuration {

    // FIXME: document.
    public static var hidden: Self {
        .modifier(DebugHorizontalAlignmentGuideModifier.VisibilityModifier(isVisible: false))
    }

    // FIXME: document.
    public static func visible(_ isVisible: Bool) -> Self {
        .modifier(DebugHorizontalAlignmentGuideModifier.VisibilityModifier(isVisible: isVisible))
    }

    // FIXME: document.
    public static func addHeight(_ addition: CGFloat) -> Self {
        .modifier(DebugHorizontalAlignmentGuideModifier.HeightAdditionModifier(heightAddition: addition))
    }

    // FIXME: document.
    public static func anchor(_ anchor: VerticalAlignment) -> Self {
        .modifier(DebugHorizontalAlignmentGuideModifier.AnchorModifier(anchor: anchor))
    }

}


// MARK: - Configuration Traits


/// Modifications to a configuration instance.
///
/// Modifier instances apply a modification to an instance of type `Configuration`.
///
/// ``ConfigurationTrait`` uses modifiers as building blocks for customizing a configuration instance.
public protocol ConfigurationModifier<Configuration>: Sendable {
    associatedtype Configuration
    func update(configuration: inout Configuration)
}


/// Customization that can be applied to an instance of type `Configuration`.
///
/// Traits are used to build a configuration by applying either a modifier or a collection of other
/// traits to a configuration instance. Usually a collection of traits is passed as a variadic
/// parameter to a function that uses those trait to generate a configuration instance, to then
/// consume that configuration.
///
/// passed to a view modifier method to build its configuration. All passed traits
/// are applied in order to a default configuration, each trait making a modification towards
/// the final configuration. If multiple traits modify the same configuration properties, the
/// last one applied may overwrite former traits.
///
/// Trait convenience members are declared in extensions constrained to a specific
/// configuration:
///
/// ```swift
/// extension ConfigurationTrait where Configuration == SomeConfiguration {
///     public static let hidden: Self = .modifier(VisibilityModifier(isVisible: false))
/// }
/// ```
public enum ConfigurationTrait<Configuration>: Sendable {

    /// Applies the associated modifier.
    case modifier(any ConfigurationModifier<Configuration>)

    /// Applies the associated traits.
    case traits([ConfigurationTrait<Configuration>])


    public func apply(to configuration: inout Configuration) {
        switch self {
        case .modifier(let modifier):
            modifier.update(configuration: &configuration)
        case .traits(let traits):
            for trait in traits {
                trait.apply(to: &configuration)
            }
        }
    }

}


/// A configuration that can be built by applying ``ConfigurationTrait`` instances to a
/// default instance.
///
/// This protocol extends implementing types with an initializer that builds an instance starting
/// from a default configuration and applying a collection of traits.
public protocol TraitConfigurable {

    /// Creates a default configuration instance.
    init()
}


extension TraitConfigurable {

    /// Creates a configuration by applying the given traits, in order, to a default instance.
    ///
    /// Each trait is applied in order to a default configuration instance. If multiple traits
    /// modify the same configuration properties, the last one applied may overwrite former traits.
    public init(traits: [ConfigurationTrait<Self>]) {
        self.init()
        for trait in traits {
            trait.apply(to: &self)
        }
    }

}



// MARK: - Vertical


struct DebugVerticalAlignmentGuideModifier: ViewModifier {

    let verticalAlignment: VerticalAlignment

    func body(content: Content) -> some View {
        let alignment = Alignment(horizontal: .center, vertical: verticalAlignment)
        content.overlay(alignment: alignment) {
            Rectangle()
            .fill(.red.secondary)
            .frame(height: 2)
        }
    }

}


// MARK: - View Extension


extension View {

    public func debugAlignmentGuide(_ alignment: Alignment) -> some View {
        return modifier(DebugAlignmentGuideModifier(alignment: alignment))
    }

    public func debugAlignmentGuide(
        horizontal horizontalAlignment: HorizontalAlignment,
        _ traits: DebugHorizontalAlignmentGuideModifier.Trait...
    ) -> some View {
        let configuration = DebugHorizontalAlignmentGuideModifier.Configuration(traits: traits)
        let guideModifier = DebugHorizontalAlignmentGuideModifier(
            horizontalAlignment: horizontalAlignment,
            configuration: configuration
        )
        return modifier(guideModifier)
    }

    public func debugAlignmentGuide(vertical verticalAlignment: VerticalAlignment) -> some View {
        return modifier(DebugVerticalAlignmentGuideModifier(verticalAlignment: verticalAlignment))
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
    .debugAlignmentGuide(horizontal: .center, .addHeight(-50))
    .debugAlignmentGuide(horizontal: .trailing, .addHeight(50))
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .alignmentGuide(.leading, offsetBy: 10)
    .debugAlignmentGuide(horizontal: .leading)
    .alignmentGuide(.bottom, offsetBy: -10)
    .debugAlignmentGuide(horizontal: .trailing, .addHeight(50))
    // FIXME: implement hidden/visibility trit
    .debugAlignmentGuide(horizontal: .center, .hidden)
    .border(.green.tertiary, width: 8)

}


#Preview("Horizontal Anchored", traits: .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(horizontal: .leading, .addHeight(50), .anchor(.top))
    .debugAlignmentGuide(horizontal: .center, .addHeight(50) , .anchor(.firstTextBaseline))
    .debugAlignmentGuide(horizontal: .trailing, .addHeight(50), .anchor(.bottom))
    .border(.green.tertiary, width: 8)
}


#Preview("Vertical", traits: .fixedHeader, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
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
    .debugAlignmentGuide(vertical: .firstTextBaseline)
    .debugAlignmentGuide(vertical: .verticalCenter)
    .debugAlignmentGuide(vertical: .lastTextBaseline)
    .debugAlignmentGuide(vertical: .bottom)
    .border(.green.tertiary, width: 8)
}

