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

        var isVisible: Bool = true
        var captionSource: CaptionSource? = nil
        var areBordersEnabled: Bool = true
        // FIXME: change default to 4, 1 quarter of default padding.
        var bordersWidth: CGFloat = 5
        var infoElements: InfoElements = .empty
        // FIXME: Rename to captionAlignment.
        var infoAlignment: FloatingAlignment = .inner(.topLeading)
        var drawsCaptionBorder: Bool = false


        init() {}


        init(traits: [Trait]) {
            self.init()
            for trait in traits {
                trait.apply(to: &self)
            }
        }


        /// Indicates if the configuration displays any elements in the debug caption.
        var containsInfoCaptionElements: Bool {
            !infoElements.isEmpty || captionSource != nil
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


// MARK: - InfoElements


extension DebugGeometryModifier.Configuration {


    // TODO: could use IdentifiableShift

    // Extends `Sendable` based in other `OptionSet`s present in SwiftUI, like `ContentShapeKinds`
    // and `PinnedScrollableViews`.
    struct InfoElements: OptionSet, Sendable {
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
        public static let width: Trait = .modifier(InfoElementsModifier(infoElements: .width))

        /// Prints the height of the owner view in the debug caption.
        public static let height: Trait = .modifier(InfoElementsModifier(infoElements: .height))

        /// Prints the global origin coordinate of the owner view in the debug caption.
        public static let origin: Trait = .modifier(InfoElementsModifier(infoElements: .origin))

        /// Prints the safe area insets applied to the owner view in the debug caption.
        public static let safeAreaInsets: Trait = .modifier(InfoElementsModifier(infoElements: .safeAreaInsets))

        /// Prints the width and height of the owner view in the debug caption.
        public static let size: Trait = .modifier(InfoElementsModifier(infoElements: .size))

        /// Prints all supported geometry information in the debug caption.
        public static let allGeometry: Trait = .modifier(InfoElementsModifier(infoElements: .allGeometry))

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

        // FIXME: deprecate.
        /// Aligns the debug caption to the given floating alignment.
        /// - Parameter alignment: Floating alignment of the debug caption.
        public static func infoAlignment(_ alignment: FloatingAlignment) -> Trait {
            .modifier(InfoAlignmentModifier(alignment: alignment))
        }

        // FIXME: deprecate, replace with innerAlignment
        /// Aligns the debug caption to the default inner floating alignment.
        ///
        /// The default is ``FloatingAlignment/innerTopLeading``.
        public static let innerInfo: Trait = .modifier(InfoAlignmentModifier(alignment: .innerTopLeading))

        // FIXME: deprecate.
        /// Aligns the debug caption to the given inner floating alignment.
        /// - Parameter innerAlignment: Inner floating alignment for the debug caption.
        public static func innerInfo(_ innerAlignment: FloatingAlignment.InnerAlignment) -> Trait {
            .modifier(InfoAlignmentModifier(alignment: .inner(innerAlignment)))
        }

        // FIXME: deprecate, replace with outerAlignment.
        /// Aligns the debug caption to the default outer floating alignment.
        ///
        /// The default is ``FloatingAlignment/outerTopLeading``.
        public static let outerInfo: Trait = .modifier(InfoAlignmentModifier(alignment: .outerTopLeading))

        // FIXME: deprecate.
        /// Aligns the debug caption to the given outer floating alignment.
        /// - Parameter outerAlignment: Outer floating alignment for the debug caption.
        public static func outerInfo(_ outerAlignment: FloatingAlignment.OuterAlignment) -> Trait {
            .modifier(InfoAlignmentModifier(alignment: .outer(outerAlignment)))
        }

        /// Aligns the debug caption to the given floating alignment.
        /// - Parameter alignment: Floating alignment of the debug caption.
        public static func alignment(_ alignment: FloatingAlignment) -> Trait {
            .modifier(InfoAlignmentModifier(alignment: alignment))
        }

        /// Enables drawing a border around the debug caption.
        ///
        /// Used internally for alignment visualization and debugging.
        static var drawsCaptionBorder: Trait { .modifier(EnableCaptionBorder()) }

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

    struct InfoElementsModifier: Modifier {
        let infoElements: InfoElements
        func update(configuration: inout DebugGeometryModifier.Configuration) {
            configuration.infoElements.formUnion(infoElements)
        }
    }

    struct InfoAlignmentModifier: Modifier {
        let alignment: FloatingAlignment
        func update(configuration: inout DebugGeometryModifier.Configuration) {
            configuration.infoAlignment = alignment
        }
    }

    struct EnableCaptionBorder: Modifier {
        func update(configuration: inout DebugGeometryModifier.Configuration) {
            configuration.drawsCaptionBorder = true
        }
    }

}
