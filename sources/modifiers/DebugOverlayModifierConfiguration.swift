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
        case outer(OuterAlignment)

        enum Key: String, CaseIterable, SelfIdentifiable {
            case inner, outer
        }

        var key: Key {
            switch self {
            case .inner: .inner
            case .outer: .outer
            }
        }

        // TODO: might make more sense to have along the views, also for other textAlignment vars.
        var textAlignment: SwiftUI.TextAlignment {
            switch self {
            case .inner(let innerAlignment):
                return innerAlignment.horizontal.textAlignment
            case .outer(let outerAlignment):
                return outerAlignment.textAlignment
            }
        }

    }

}


// MARK: - InnerAlignment


extension DebugOverlayModifier.Configuration {

    struct InnerAlignment {
        let horizontal: HorizontalAlignment
        let vertical: VerticalAlignment

        static var topLeading: InnerAlignment { .init(horizontal: .leading, vertical: .top) }

        var swiftAlignment: SwiftUI.Alignment {
            .init(horizontal: horizontal.swiftAlignment, vertical: vertical.swiftAlignment)
        }
    }


    enum HorizontalAlignment: String, CaseIterable, SelfIdentifiable {
        case leading, center, trailing

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


    enum VerticalAlignment: String, CaseIterable, SelfIdentifiable {
        case top, center, bottom

        var swiftAlignment: SwiftUI.VerticalAlignment {
            switch self {
            case .top:    .top
            case .center: .center
            case .bottom: .bottom
            }
        }
    }

}


extension DebugOverlayModifier.Configuration {

    enum OuterAlignment {
        case top(HorizontalAlignment)
        case leading(OuterVerticalAlignment)
        case bottom(HorizontalAlignment)
        case trailing(OuterVerticalAlignment)

        enum Key: String, CaseIterable, SelfIdentifiable {
            case top, leading, bottom, trailing
        }

        var key: Key {
            switch self {
            case .top:      .top
            case .leading:  .leading
            case .bottom:   .bottom
            case .trailing: .trailing
            }
        }

        // TODO: might make more sense to have along the views, also for other textAlignment vars.
        var textAlignment: SwiftUI.TextAlignment {
            switch self {
            case .top(let horizontalAlignment), .bottom(let horizontalAlignment):
                horizontalAlignment.textAlignment
            case .leading: .trailing
            case .trailing: .leading
            }
        }

        // TODO: might make more sense to have along the views.
        // Alignment for the VStack containing the info view.
        var containerHorizontal: HorizontalAlignment {
            switch self {
            case .top(let horizontalAlignment), .bottom(let horizontalAlignment):
                horizontalAlignment
            case .leading: .trailing
            case .trailing: .leading
            }
        }

        // TODO: Dry!
        var frameAlignment: SwiftUI.Alignment {
            switch self {
            case .top(let horizontalAlignment):
                return .init(horizontal: horizontalAlignment.swiftAlignment, vertical: .bottom)
            case .bottom(let horizontalAlignment):
                return .init(horizontal: horizontalAlignment.swiftAlignment, vertical: .top)
            case .leading(let outerVerticalAlignment):
                let vertical: SwiftUI.VerticalAlignment = switch outerVerticalAlignment {
                case .above:
                        .bottom
                case .top:
                        .top
                case .center:
                        .center
                case .bottom:
                        .bottom
                case .below:
                        .top
                }
                return .init(horizontal: .trailing, vertical: vertical)
            case .trailing(let outerVerticalAlignment):
                let vertical: SwiftUI.VerticalAlignment = switch outerVerticalAlignment {
                case .above:
                        .bottom
                case .top:
                        .top
                case .center:
                        .center
                case .bottom:
                        .bottom
                case .below:
                        .top
                }
                return .init(horizontal: .leading, vertical: vertical)
            }
        }

        static var topLeading:     OuterAlignment { .top(.leading) }
        static var topCenter:      OuterAlignment { .top(.center) }
        static var topTrailing:    OuterAlignment { .top(.trailing) }

        static var bottomLeading:  OuterAlignment { .bottom(.leading) }
        static var bottomCenter:   OuterAlignment { .bottom(.center) }
        static var bottomTrailing: OuterAlignment { .bottom(.trailing) }

        static var leadingAbove:   OuterAlignment { .leading(.above) }
        static var leadingTop:     OuterAlignment { .leading(.top) }
        static var leadingCenter:  OuterAlignment { .leading(.center) }
        static var leadingBottom:  OuterAlignment { .leading(.bottom) }
        static var leadingUnder:   OuterAlignment { .leading(.below) }

        static var trailingAbove:  OuterAlignment { .trailing(.above) }
        static var trailingTop:    OuterAlignment { .trailing(.top) }
        static var trailingCenter: OuterAlignment { .trailing(.center) }
        static var trailingBottom: OuterAlignment { .trailing(.bottom) }
        static var trailingBelow:  OuterAlignment { .trailing(.below) }

    }


    enum OuterVerticalAlignment: String, CaseIterable, SelfIdentifiable {
        case above, top, center, bottom, below
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

        /// Default inner aligned position for the information caption: top-leading.
        static var innerInfo: Trait = .modifier(InfoPositionModifier(infoPosition: .inner(.topLeading)))

        static func innerInfo(_ innerAlingment: InnerAlignment) -> Trait {
            .modifier(InfoPositionModifier(infoPosition: .inner(innerAlingment)))
        }

        /// Default outer aligned position for the information caption: top-leading.
        static let outerInfo: Trait = .modifier(InfoPositionModifier(infoPosition: .outer(.topLeading)))

        static func outerInfo(_ outerAlingment: OuterAlignment) -> Trait {
            .modifier(InfoPositionModifier(infoPosition: .outer(outerAlingment)))
        }

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
