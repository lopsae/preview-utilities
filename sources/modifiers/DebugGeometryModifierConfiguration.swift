//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


extension DebugGeometryModifier {

    /// Configuration of a `DebugGeometryModifier`.
    ///
    /// Contains the caption, border settings, geometry elements to display, and the floating
    /// alignment for the debug caption.
    ///
    /// Usually you don't build this object directly, instead one is created and configured using
    /// the [`Trait`](doc:Trait) instances passed to ``SwiftUICore/View/debugGeometry(_:)``.
    public struct Configuration {

        /// The visibility of all elements drawn in the debug overlay.
        ///
        /// When set to `false` the modifier will draw no content.
        var isVisible: Bool = true

        /// The caption displayed along the geometry properties.
        var captionSource: CaptionSource? = nil

        /// The visibility of the inner and outer borders.
        var areBordersEnabled: Bool = true

        /// The width of the inner and outer borders.
        ///
        /// Defaults to `4`, a quarter of the default iOS padding.
        var bordersWidth: CGFloat = 4

        // FIXME: Document.
        var geometryProperties: GeometryProperties = .empty
        // FIXME: Document.
        var captionAlignment: FloatingAlignment = .inner(.topLeading)

        /// Enables a border around the debug caption.
        ///
        /// Used to test caption alignment distance.
        internal var drawsCaptionBorder: Bool = false


        // FIXME: Publicize inits and document.
        init() {}


        init(traits: [Trait]) {
            self.init()
            for trait in traits {
                trait.apply(to: &self)
            }
        }


        /// Indicates if the configuration displays any elements in the debug caption.
        var containsCaptionElements: Bool {
            !geometryProperties.isEmpty || captionSource != nil
        }

    }

}


// MARK: - CaptionSource


extension DebugGeometryModifier.Configuration {

    enum CaptionSource {
        case localizedKey(LocalizedStringKey)
        case verbatim(String)
    }

}


// MARK: - GeometryProperties


extension DebugGeometryModifier.Configuration {


    // TODO: could use IdentifiableShift

    // Extends `Sendable` based in other `OptionSet`s present in SwiftUI, like `ContentShapeKinds`
    // and `PinnedScrollableViews`.
    struct GeometryProperties: OptionSet, Sendable {
        let rawValue: Int

        nonisolated init(rawValue: Int) {
            self.rawValue = rawValue
        }

        static let empty: Self =          .init(rawValue: .zero)
        static let width: Self =          .init(shiftedBy: 0)
        static let height: Self =         .init(shiftedBy: 1)
        static let origin: Self =         .init(shiftedBy: 2)
        static let safeAreaInsets: Self = .init(shiftedBy: 3)

        static let size: Self = [.width, .height]
        static let allGeometry: Self = [.width, .height, .origin, .safeAreaInsets]
    }

}


// MARK: - Trait


extension DebugGeometryModifier.Configuration {

    /// Customizations that can be applied to the configuration of a `DebugGeometryModifier`.
    ///  
    /// Traits are passed to ``SwiftUICore/View/debugGeometry(_:)`` or any [sibling function](doc:debug-overlay-api#View-Extensions)
    /// to build the [`Configuration`](doc:DebugGeometryModifier/Configuration) of a debug overlay.
    ///
    /// All passed traits are applied in order to a default configuration, each trait making a
    /// modification towards the final configuration. If multiple traits modify the same
    /// configuration properties, the last one applied may overwrite former traits.
    ///
    ///
    /// ## Topics
    ///
    /// ### Geometry Traits
    /// + ``allGeometry``
    /// + ``safeAreaInsets``
    /// + ``origin``
    /// + ``size``
    /// + ``height``
    /// + ``width``
    ///
    /// ### Visual Traits
    /// + ``bordersWidth(_:)``
    /// + ``hairline``
    ///
    /// ### Caption Traits
    /// + ``caption(_:)``
    /// + ``caption(verbatim:)``
    /// + ``alignment(_:)``
    /// + ``infoAlignment(_:)``
    /// + ``innerInfo``
    /// + ``innerInfo(_:)``
    /// + ``outerInfo``
    /// + ``outerInfo(_:)``
    ///
    public enum Trait: Sendable {

        /// Applies the associated modifier.
        case modifier(any Modifier)

        /// Applies the associated traits.
        case traits([Trait])


        func apply(to configuration: inout DebugGeometryModifier.Configuration) {
            switch self {
            case .modifier(let modifier):
                modifier.update(configuration: &configuration)
            case .traits(let traits):
                for trait in traits {
                    trait.apply(to: &configuration)
                }
            }
        }

        /// A trait that performs no changes.
        public static let empty: Trait = .traits([])

        // FIXME: also implement opacity.

        /// Hides all elements of the debug overlay.
        public static let hidden: Trait = .modifier(VisibilityModifier(isVisible: false))

        /// Sets the visibility of the debug overlay.
        /// - Parameter isVisible: Indicates if the debug overlay is visible.
        public static func visible(_ isVisible: Bool) -> Trait {
            .modifier(VisibilityModifier(isVisible: isVisible))
        }

        /// Hides the debug overlay borders.
        public static let noBorders: Trait = .modifier(HideBordersModifier())

        /// Sets the debug overlay borders to a width of `1`.
        public static let hairline: Trait = .modifier(HairlineModifier())

        /// Sets the debug overlay borders to the given width.
        ///
        /// The debug overlay always draws with a minimal width of `1`, even if the width is set to
        /// zero through this trait. To hide the borders use ``noBorders``.
        /// - Parameter bordersWidth: Width of the debug overlay borders.
        public static func bordersWidth(_ bordersWidth: CGFloat) -> Trait {
            .modifier(BordersWidthModifier(bordersWidth: bordersWidth))
        }

        /// Prints the width of the owner view in the debug caption.
        public static let width: Trait = .modifier(GeometryPropertiesModifier(property: .width))

        /// Prints the height of the owner view in the debug caption.
        public static let height: Trait = .modifier(GeometryPropertiesModifier(property: .height))

        /// Prints the global origin coordinate of the owner view in the debug caption.
        public static let origin: Trait = .modifier(GeometryPropertiesModifier(property: .origin))

        /// Prints the safe area insets applied to the owner view in the debug caption.
        public static let safeAreaInsets: Trait = .modifier(GeometryPropertiesModifier(property: .safeAreaInsets))

        /// Prints the width and height of the owner view in the debug caption.
        public static let size: Trait = .modifier(GeometryPropertiesModifier(property: .size))

        /// Prints all supported geometry properties in the debug caption.
        public static let allGeometry: Trait = .modifier(GeometryPropertiesModifier(property: .allGeometry))

        /// Prints the given localized string in the debug caption.
        /// 
        /// Only one caption is supported, passing this trait more that once will overwrite any
        /// previous.
        ///
        /// - Parameter key: Localized string key to display.
        public static func caption(_ key: LocalizedStringKey) -> Trait {
            .modifier(CaptionModifier(source: .localizedKey(key)))
        }

        /// Prints the given verbatim string in the debug caption.
        /// 
        /// Only one caption is supported, passing this trait more that once will overwrite any
        /// previous.
        ///
        /// - Parameter string: Verbatim string to display.
        public static func caption(verbatim string: String) -> Trait {
            .modifier(CaptionModifier(source: .verbatim(string)))
        }

        // FIXME: Delete deprecations once unused.

        /// Aligns the debug caption to the given floating alignment.
        /// - Parameter alignment: Floating alignment of the debug caption.
        @available(*, deprecated)
        public static func infoAlignment(_ alignment: FloatingAlignment) -> Trait {
            .modifier(CaptionAlignmentModifier(alignment: alignment))
        }

        // FIXME: Replace with innerAlignment
        /// Aligns the debug caption to the default inner floating alignment.
        ///
        /// The default is ``FloatingAlignment/innerTopLeading``.
        @available(*, deprecated)
        public static let innerInfo: Trait = .modifier(CaptionAlignmentModifier(alignment: .innerTopLeading))

        /// Aligns the debug caption to the given inner floating alignment.
        /// - Parameter innerAlignment: Inner floating alignment for the debug caption.
        @available(*, deprecated)
        public static func innerInfo(_ innerAlignment: FloatingAlignment.InnerAlignment) -> Trait {
            .modifier(CaptionAlignmentModifier(alignment: .inner(innerAlignment)))
        }

        // FIXME: Replace with outerAlignment.
        /// Aligns the debug caption to the default outer floating alignment.
        ///
        /// The default is ``FloatingAlignment/outerTopLeading``.
        @available(*, deprecated)
        public static let outerInfo: Trait = .modifier(CaptionAlignmentModifier(alignment: .outerTopLeading))

        /// Aligns the debug caption to the given outer floating alignment.
        /// - Parameter outerAlignment: Outer floating alignment for the debug caption.
        @available(*, deprecated)
        public static func outerInfo(_ outerAlignment: FloatingAlignment.OuterAlignment) -> Trait {
            .modifier(CaptionAlignmentModifier(alignment: .outer(outerAlignment)))
        }

        /// Aligns the debug caption to the given floating alignment.
        /// - Parameter alignment: Floating alignment of the debug caption.
        public static func alignment(_ alignment: FloatingAlignment) -> Trait {
            .modifier(CaptionAlignmentModifier(alignment: alignment))
        }

        /// Enables drawing a border around the debug caption.
        ///
        /// Used internally for alignment visualization and debugging.
        public static var drawsCaptionBorder: Trait { .modifier(EnableCaptionBorder()) }

    }
}


// MARK: - Modifiers


extension DebugGeometryModifier.Configuration {

    /// Modifier for a debug overlay configuration.
    ///
    /// Applies an update to a debug overlay configuration. Used by ``DebugGeometryModifier/Configuration/Trait``
    /// instances as building blocks for a configuration instance.
    public protocol Modifier: Sendable {
        func update(configuration: inout DebugGeometryModifier.Configuration)
    }

    struct VisibilityModifier: Modifier {
        let isVisible: Bool
        func update(configuration: inout DebugGeometryModifier.Configuration) {
            configuration.isVisible = isVisible
        }
    }

    struct CaptionModifier: Modifier {
        let source: DebugGeometryModifier.Configuration.CaptionSource
        func update(configuration: inout DebugGeometryModifier.Configuration) {
            configuration.captionSource = source
        }
    }

    struct HideBordersModifier: Modifier {
        func update(configuration: inout DebugGeometryModifier.Configuration) {
            configuration.areBordersEnabled = false
            configuration.bordersWidth = 1
        }
    }

    struct HairlineModifier: Modifier {
        func update(configuration: inout DebugGeometryModifier.Configuration) {
            configuration.areBordersEnabled = true
            configuration.bordersWidth = 1
        }
    }

    struct BordersWidthModifier: Modifier {
        let bordersWidth: CGFloat
        func update(configuration: inout DebugGeometryModifier.Configuration) {
            configuration.areBordersEnabled = true
            configuration.bordersWidth = bordersWidth
        }
    }

    struct GeometryPropertiesModifier: Modifier {
        let property: GeometryProperties
        func update(configuration: inout DebugGeometryModifier.Configuration) {
            configuration.geometryProperties.formUnion(property)
        }
    }

    struct CaptionAlignmentModifier: Modifier {
        let alignment: FloatingAlignment
        func update(configuration: inout DebugGeometryModifier.Configuration) {
            configuration.captionAlignment = alignment
        }
    }

    struct EnableCaptionBorder: Modifier {
        func update(configuration: inout DebugGeometryModifier.Configuration) {
            configuration.drawsCaptionBorder = true
        }
    }

}
