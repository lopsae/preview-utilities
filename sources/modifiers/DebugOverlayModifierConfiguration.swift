//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension DebugOverlayModifier {

    public struct Configuration {

        var lineWidth: CGFloat = 5
        var infoElements: InfoElements = .empty
        var infoPosition: InfoPosition = .inner(.topLeading)


        init() { }


        init(traits: [Trait]) {
            self.init()
            for trait in traits {
                trait.apply(to: &self)
            }
        }

    }

}


// MARK: - InfoElements


extension DebugOverlayModifier.Configuration {

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


// MARK: - InfoPosition


extension DebugOverlayModifier.Configuration {

    enum InfoPosition {

        case inner(InnerAlignment)
        case outer // TODO: pending to add alignment options

        var textAlignment: SwiftUI.TextAlignment {
            switch self {
            case .inner(let InnerAlignment):
                return InnerAlignment.horizontal.textAlignment
            case .outer:
                return .leading
            }
        }

    }


    struct InnerAlignment {
        let horizontal: HorizontalAlignment
        let vertical: VerticalAlignment

        static var topLeading: InnerAlignment { .init(horizontal: .leading, vertical: .top) }

        var swiftAlignment: SwiftUI.Alignment {
            .init(horizontal: horizontal.swiftAlignment, vertical: vertical.swiftAlignment)
        }

    }


    enum HorizontalAlignment: String, CaseIterable, Identifiable {

        case leading, center, trailing

        var id: RawValue { self.rawValue }

        var swiftAlignment: SwiftUI.HorizontalAlignment {
            switch self {
            case .leading:  .leading
            case .center:   .center
            case .trailing: .trailing
            }
        }

        var textAlignment: SwiftUI.TextAlignment {
            switch self {
            case .leading:  .leading
            case .center:   .center
            case .trailing: .trailing
            }
        }
    }


    enum VerticalAlignment: String, CaseIterable, Identifiable {
        case top, center, bottom

        var id: RawValue { self.rawValue }

        var swiftAlignment: SwiftUI.VerticalAlignment {
            switch self {
            case .top:    .top
            case .center: .center
            case .bottom: .bottom
            }
        }
    }

}


// MARK: - Trait


extension DebugOverlayModifier.Configuration {

    /// Customizations that can be applied to a debug overlay.
    public enum Trait {
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


        static let hairline: Trait = .modifier(HairlineModifier())

        static func lineWidth(_ lineWidth: CGFloat) -> Trait {
            .modifier(LineWidthModifier(lineWidth: lineWidth))
        }

        static let width: Trait          = .modifier(InfoElementsModifier(infoElements: .width))
        static let height: Trait         = .modifier(InfoElementsModifier(infoElements: .height))
        static let origin: Trait         = .modifier(InfoElementsModifier(infoElements: .origin))
        static let safeAreaInsets: Trait = .modifier(InfoElementsModifier(infoElements: .safeAreaInsets))

        static let size: Trait           = .modifier(InfoElementsModifier(infoElements: .size))
        static let allGeometry: Trait    = .modifier(InfoElementsModifier(infoElements: .allGeometry))

        static var innerInfo: Trait = .modifier(InfoPositionModifier(infoPosition: .inner(.topLeading)))

        static func innerInfo(_ innerAlingment: InnerAlignment) -> Trait {
            .modifier(InfoPositionModifier(infoPosition: .inner(innerAlingment)))
        }

        static let outerInfo: Trait = .modifier(InfoPositionModifier(infoPosition: .outer))

    }
}


// MARK: - Modifiers


extension DebugOverlayModifier.Configuration {

    public protocol Modifier {
        func update(configuration: inout DebugOverlayModifier.Configuration)
    }

    struct HairlineModifier: Modifier {
        func update(configuration: inout DebugOverlayModifier.Configuration) {
            configuration.lineWidth = 1
        }
    }

    struct LineWidthModifier: Modifier {
        let lineWidth: CGFloat
        func update(configuration: inout DebugOverlayModifier.Configuration) {
            configuration.lineWidth = lineWidth
        }
    }

    struct InfoElementsModifier: Modifier {
        let infoElements: InfoElements
        func update(configuration: inout DebugOverlayModifier.Configuration) {
            configuration.infoElements.formUnion(infoElements)
        }
    }

    struct InfoPositionModifier: Modifier {
        let infoPosition: InfoPosition
        func update(configuration: inout DebugOverlayModifier.Configuration) {
            configuration.infoPosition = infoPosition
        }
    }

}
