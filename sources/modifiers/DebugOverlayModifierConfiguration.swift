//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension DebugOverlayModifier {

    public struct Configuration {

        var caption: LocalizedStringKey? = nil
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


        /// Returns `true` if configured to display any geometry information or caption.
        var containsInfoCaptionElements: Bool {
            !infoElements.isEmpty || caption != nil
        }

    }

}


// MARK: - InfoElements


extension DebugOverlayModifier.Configuration {


    // TODO: could use IdentifibleShift

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

    /// Customizations that can be applied to a debug overlay.
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


        public static let hairline: Trait = .modifier(HairlineModifier())

        public static func bordersWidth(_ bordersWidth: CGFloat) -> Trait {
            .modifier(BordersWidthModifier(bordersWidth: bordersWidth))
        }

        public static let width: Trait          = .modifier(InfoElementsModifier(infoElements: .width))
        public static let height: Trait         = .modifier(InfoElementsModifier(infoElements: .height))
        public static let origin: Trait         = .modifier(InfoElementsModifier(infoElements: .origin))
        public static let safeAreaInsets: Trait = .modifier(InfoElementsModifier(infoElements: .safeAreaInsets))

        public static let size: Trait           = .modifier(InfoElementsModifier(infoElements: .size))
        public static let allGeometry: Trait    = .modifier(InfoElementsModifier(infoElements: .allGeometry))

        public static func caption(_ key: LocalizedStringKey) -> Trait {
            .modifier(CaptionModifier(caption: key))
        }

        public static func infoAlignment(_ alignment: FloatingAlignment) -> Trait {
            .modifier(InfoAlignmentModifier(alignment: alignment))
        }

        /// Default inner aligned position for the information caption: top-leading.
        public static let innerInfo: Trait = .modifier(InfoAlignmentModifier(alignment: .inner(.topLeading)))

        public static func innerInfo(_ innerAlingment: FloatingAlignment.InnerAlignment) -> Trait {
            .modifier(InfoAlignmentModifier(alignment: .inner(innerAlingment)))
        }

        /// Default outer aligned position for the information caption: top-leading.
        public static let outerInfo: Trait = .modifier(InfoAlignmentModifier(alignment: .outer(.topLeading)))

        public static func outerInfo(_ outerAlingment: FloatingAlignment.OuterAlignment) -> Trait {
            .modifier(InfoAlignmentModifier(alignment: .outer(outerAlingment)))
        }

    }
}


// MARK: - Modifiers


extension DebugOverlayModifier.Configuration {

    public protocol Modifier: Sendable {
        func update(configuration: inout DebugOverlayModifier.Configuration)
    }

    struct CaptionModifier: Modifier {
        let caption: LocalizedStringKey
        func update(configuration: inout DebugOverlayModifier.Configuration) {
            configuration.caption = caption
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
