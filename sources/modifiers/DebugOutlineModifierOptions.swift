//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension DebugOutlineModifier {

    // TODO: does it need to be sendable?
    // TODO: move trait outside of options, might allow to make options interal
    public struct NewOptions {

        var lineWidth: CGFloat = 5
        var infoPosition: InfoPosition = .inner(.topLeading)
//        var displaysWidth: Bool = false
//        var displaysHeight: Bool = false
//        var displaysOrigin: Bool = false
//        var displaysSafeAreaInsets: Bool = false
//        var displaysInfoOutside: Bool = false


        init() { }


        init(traits: [Trait]) {
            self.init()
            for trait in traits {
                trait.apply(to: &self)
            }
        }

    }

}


extension DebugOutlineModifier.NewOptions {

    enum InfoPosition {

        case inner(Alignment)
        case outer // TODO: pending to add alignment options

        var isOuter: Bool {
            switch self {
            case .inner: false
            case .outer: true
            }
        }

        var innerAlignment: Alignment? {
            switch self {
            case .inner(let alignment):
                return alignment
            case .outer:
                return nil
            }
        }

    }

}


// MARK: - Trait


extension DebugOutlineModifier.NewOptions {

    /// Customizations that can be applied to a debug outline.
    public enum Trait {
        case modifier(any Modifier)

        func apply(to options: inout DebugOutlineModifier.NewOptions) {
            switch self {
            case .modifier(let aModifier):
                aModifier.update(options: &options)
            }
        }


        static var hairline: Trait { .modifier(HairlineModifier()) }

        static func lineWidth(_ lineWidth: CGFloat) -> Trait {
            .modifier(LineWidthModifier(lineWidth: lineWidth))
        }

        static var innerInfo: Trait {
            .modifier(InfoPositionModifier(infoPosition: .inner(.topLeading)))
        }

        static func innerInfo(_ innerAlingment: Alignment) -> Trait {
            .modifier(InfoPositionModifier(infoPosition: .inner(innerAlingment)))
        }

        static var outerInfo: Trait {
            .modifier(InfoPositionModifier(infoPosition: .outer))
        }

    }
}


// MARK: - Modifiers


extension DebugOutlineModifier.NewOptions {

    public protocol Modifier {
        func update(options: inout DebugOutlineModifier.NewOptions)
    }

    struct HairlineModifier: Modifier {
        func update(options: inout DebugOutlineModifier.NewOptions) {
            options.lineWidth = 1
        }
    }

    struct LineWidthModifier: Modifier {
        let lineWidth: CGFloat
        func update(options: inout DebugOutlineModifier.NewOptions) {
            options.lineWidth = lineWidth
        }
    }

    struct InfoPositionModifier: Modifier {
        let infoPosition: InfoPosition
        func update(options: inout DebugOutlineModifier.NewOptions) {
            options.infoPosition = infoPosition
        }
    }

}
