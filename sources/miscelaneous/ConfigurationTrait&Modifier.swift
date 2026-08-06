//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


/// Customization that can be applied to an instance of type `Configuration`.
///  
/// Traits encapsulate a modification that can be applied to a configuration instance. A collection of
/// traits can be used to initialize and configure a new instance, or can be applied to an existing
/// one to modify its state.
///  
/// When multiple traits are applied in an instance, the application is done in order, with a each
/// trait receiving the resulting instance of previously applied traits. If multiple traits modify
/// the same configuration properties, the last one applied may overwrite former traits.
///  
/// Traits are usually defined as static properties of `ConfigurationTrait` constrained to a given
/// ``Configuration`` type.
///  
/// ```swift
/// extension ConfigurationTrait where Configuration == SomeConfiguration {
///     public static let hidden: Self = .modifier(VisibilityModifier(isVisible: false))
/// }
/// ```
///  
/// For example, a function receiving a variadic parameter of traits can use the available static
/// properties as building blocks to produce a custom configuration instance:
///
/// ```swift
/// func configure(traits: ConfigurationTrait<SomeConfiguration>...) { /* ... */ }
/// configure(traits: .hidden)
/// ```
public enum ConfigurationTrait<Configuration>: Sendable {

    /// Applies the associated mutating closure.
    case mutate(@Sendable (inout Configuration) -> Void)

    /// Applies the associated modifier.
    case modifier(any ConfigurationModifier<Configuration>)

    /// Applies the associated traits.
    ///
    /// The contained traits are applied in order, with each trait receiving the resulting instance
    /// of previously applied traits.
    case traits([ConfigurationTrait<Configuration>])


    /// Applies `self` to the given configuration instance.
    /// - Parameter configuration: The configuration instance to customize.
    public func apply(to configuration: inout Configuration) {
        switch self {
        case .modifier(let modifier):
            modifier.modify(configuration: &configuration)
        case .mutate(let closure):
            closure(&configuration)
        case .traits(let traits):
            for trait in traits {
                trait.apply(to: &configuration)
            }
        }
    }

}


extension ConfigurationTrait: ExpressibleByArrayLiteral {

    /// Creates a trait that contains a collection of traits.
    /// - Parameter elements: The collection of traits to apply.
    public init(arrayLiteral elements: Self...) {
        self = .traits(elements)
    }

}


// MARK: - Modifier


/// Modifications to a configuration instance.
///
/// Modifier instances apply a modification to an instance of type `Configuration`.
///
/// ``ConfigurationTrait`` can use modifiers as building blocks for customizing a configuration
/// instance.
///
/// Usually a modifier can be created for each customizable property of a configuration. These
/// modifiers should be defined along the configuration implementation, or in a container type to
/// group them together. It is not advised to place the modifier implementation in a ``ConfigurationTrait``
/// extension, as the type names may conflict easily with modifiers of other types.
public protocol ConfigurationModifier<Configuration>: Sendable {

    associatedtype Configuration
    
    /// Modifies a given configuration instance.
    /// - Parameter configuration: The configuration to customize.
    func modify(configuration: inout Configuration)

}


// MARK: - TraitConfigurable


/// A configuration that can modified by applying ``ConfigurationTrait`` instances.
///
/// This protocol extends implementing types with a function that applies a collection of traits
/// to `self`.
public protocol TraitConfigurable {}
extension TraitConfigurable {

    /// Applies a collection of traits to `self`.
    /// - Parameter traits: A collection of traits to apply.
    public mutating func apply(traits: [ConfigurationTrait<Self>]) {
        for trait in traits {
            trait.apply(to: &self)
        }
    }

}


// MARK: - TraitInitializable


/// A configuration that can be built by applying ``ConfigurationTrait`` instances to a
/// default instance.
///
/// This protocol extends implementing types with an initializer that builds an instance starting
/// from a default configuration and applying a collection of traits.
public protocol TraitInitializable: TraitConfigurable {

    /// Creates a default configuration instance.
    init()

}


extension TraitInitializable {

    /// Creates a configuration by applying the given traits, in order, to a default instance.
    ///
    /// The traits are applied in order, with each trait receiving the resulting instance of
    /// previously applied traits.
    public init(traits: [ConfigurationTrait<Self>]) {
        self.init()
        self.apply(traits: traits)
    }

}
