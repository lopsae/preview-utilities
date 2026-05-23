//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension DebugOverlayModifier {

    /// Configuration of a `DebugOverlayModifier`.
    ///
    /// Contains the caption, border settings, geometry elements to display, and the floating
    /// alignment for the debug caption.
    ///
    /// Usually you don't build this object directly, instead one is created and configured using
    /// the ``Trait`` instances passed to ``SwiftUICore/View/debugOverlay(_:)``.
    public struct Configuration {

        var captionSource: CaptionSource? = nil
        var bordersWidth: CGFloat = 5
        var infoElements: InfoElements = .empty
        var infoAlignment: FloatingAlignment = .inner(.topLeading)


        init() { }


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


extension DebugOverlayModifier.Configuration {

    enum CaptionSource {
        case localizedKey(LocalizedStringKey)
        case verbatim(String)
    }

}


// MARK: - InfoElements


extension DebugOverlayModifier.Configuration {


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


extension DebugOverlayModifier.Configuration {

    /// Customizations that can be applied to the `Configuration` for a `DebugOverlayModifier`.
    ///
    /// Traits are passed to ``SwiftUICore/View/debugOverlay(_:)`` to build the
    /// [`Configuration`](doc:DebugOverlayModifier/Configuration) of a debug overlay. All passed
    /// traits are applied in order to a default configuration, each trait making a modification
    /// towards the final configuration. If multiple traits modify the same configuration
    /// properties, the last one applied may overwrite former traits.
    public enum Trait: Sendable {
        case modifier(any Modifier)
        case traits([Trait])

        func apply(to configuration: inout DebugOverlayModifier.Configuration) {
            switch self {
            case .modifier(let modifier):
                modifier.update(configuration: &configuration)
            case .traits(let traits):
                for trait in traits {
                    trait.apply(to: &configuration)
                }
            }
        }


        /// Sets the debug overlay borders to a width of `1`.
        public static let hairline: Trait = .modifier(HairlineModifier())

        /// Sets the debug overlay borders to the given width
        /// - Parameter bordersWidth: Width of the debug overlay borders.
        public static func bordersWidth(_ bordersWidth: CGFloat) -> Trait {
            .modifier(BordersWidthModifier(bordersWidth: bordersWidth))
        }

        /// Prints the width of the parent view in the debug caption.
        public static let width: Trait = .modifier(InfoElementsModifier(infoElements: .width))

        /// Prints the height of the parent view in the debug caption.
        public static let height: Trait = .modifier(InfoElementsModifier(infoElements: .height))

        /// Prints the global origin coordinate of the parent view in the debug caption.
        public static let origin: Trait = .modifier(InfoElementsModifier(infoElements: .origin))

        /// Prints the safe area insets applied to the parent view in the debug caption.
        public static let safeAreaInsets: Trait = .modifier(InfoElementsModifier(infoElements: .safeAreaInsets))

        /// Prints the width and height of the parent view in the debug caption.
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

        // TODO: deprecate.
        /// Aligns the debug caption to the given floating alignment.
        /// - Parameter alignment: Floating alignment of the debug caption.
        public static func infoAlignment(_ alignment: FloatingAlignment) -> Trait {
            .modifier(InfoAlignmentModifier(alignment: alignment))
        }

        // TODO: deprecate, replace with innerAlignment
        /// Aligns the debug caption to the default inner floating alignment.
        ///
        /// The default is ``FloatingAlignment/innerTopLeading``.
        public static let innerInfo: Trait = .modifier(InfoAlignmentModifier(alignment: .innerTopLeading))

        // TODO: deprecate.
        /// Aligns the debug caption to the given inner floating alignment.
        /// - Parameter innerAlignment: Inner floating alignment for the debug caption.
        public static func innerInfo(_ innerAlignment: FloatingAlignment.InnerAlignment) -> Trait {
            .modifier(InfoAlignmentModifier(alignment: .inner(innerAlignment)))
        }

        // TODO: deprecate, replace with outerAlignment.
        /// Aligns the debug caption to the default outer floating alignment.
        ///
        /// The default is ``FloatingAlignment/outerTopLeading``.
        public static let outerInfo: Trait = .modifier(InfoAlignmentModifier(alignment: .outerTopLeading))

        // TODO: deprecate.
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

    }
}


// MARK: - Modifiers


extension DebugOverlayModifier.Configuration {

    /// Modifier for a debug overlay configuration.
    ///
    /// Applies an update to a debug overlay configuration. Used by ``DebugOverlayModifier/Configuration/Trait``
    /// instances as building blocks for a configuration instance.
    public protocol Modifier: Sendable {
        func update(configuration: inout DebugOverlayModifier.Configuration)
    }

    struct CaptionModifier: Modifier {
        let source: DebugOverlayModifier.Configuration.CaptionSource
        func update(configuration: inout DebugOverlayModifier.Configuration) {
            configuration.captionSource = source
        }
    }

    struct HairlineModifier: Modifier {
        func update(configuration: inout DebugOverlayModifier.Configuration) {
            configuration.bordersWidth = 1
        }
    }

    struct BordersWidthModifier: Modifier {
        let bordersWidth: CGFloat
        func update(configuration: inout DebugOverlayModifier.Configuration) {
            configuration.bordersWidth = bordersWidth
        }
    }

    struct InfoElementsModifier: Modifier {
        let infoElements: InfoElements
        func update(configuration: inout DebugOverlayModifier.Configuration) {
            configuration.infoElements.formUnion(infoElements)
        }
    }

    struct InfoAlignmentModifier: Modifier {
        let alignment: FloatingAlignment
        func update(configuration: inout DebugOverlayModifier.Configuration) {
            configuration.infoAlignment = alignment
        }
    }

}
