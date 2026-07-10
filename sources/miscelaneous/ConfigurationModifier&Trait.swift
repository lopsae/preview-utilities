//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


// FIXME: add tests with a dummy configuration.


/// Modifications to a configuration instance.
///
/// Modifier instances apply a modification to an instance of type `Configuration`.
///
/// ``ConfigurationTrait`` uses modifiers as building blocks for customizing a configuration instance.
///
/// Usually a modifier is created for each customizable property of a configuration. This modifiers
/// should be defined along the configuration implementation, or in a container type to group them
/// together. It is not advised to place the modifier implementation in the ``ConfigurationTrait``
/// extension, as the type names may conflict easily with modifiers of other types.
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

    // FIXME: document.
    case mutate((inout Configuration) -> Void)

    /// Applies the associated traits.
    case traits([ConfigurationTrait<Configuration>])


    public func apply(to configuration: inout Configuration) {
        switch self {
        case .modifier(let modifier):
            modifier.update(configuration: &configuration)
        case .mutate(let closure):
            closure(&configuration)
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
