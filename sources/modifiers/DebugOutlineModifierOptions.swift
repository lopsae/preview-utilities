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
        var displaysSafeAreaInsets: Bool = false


        init() { }


        init(traits: [Trait]) {
            self.init()
            for trait in traits {
                trait.apply(to: &self)
            }
        }

        var displaysInfo: Bool {
            displaysSafeAreaInsets
        }

    }

}


// MARK: - InfoPosition


extension DebugOutlineModifier.NewOptions {

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


extension DebugOutlineModifier.NewOptions {

    /// Customizations that can be applied to a debug outline.
    public enum Trait {
        case modifier(any Modifier)
        case traits([Trait])

        func apply(to options: inout DebugOutlineModifier.NewOptions) {
            switch self {
            case .modifier(let modifier):
                modifier.update(options: &options)
            case .traits(let traits):
                for trait in traits {
                    trait.apply(to: &options)
                }
            }
        }


        static let hairline: Trait = .modifier(HairlineModifier())

        static func lineWidth(_ lineWidth: CGFloat) -> Trait {
            .modifier(LineWidthModifier(lineWidth: lineWidth))
        }

        static let safeAreaInsets: Trait = .modifier(SafeAreaInsetsModifier())

        static var innerInfo: Trait = .modifier(InfoPositionModifier(infoPosition: .inner(.topLeading)))

        static func innerInfo(_ innerAlingment: InnerAlignment) -> Trait {
            .modifier(InfoPositionModifier(infoPosition: .inner(innerAlingment)))
        }

        static let outerInfo: Trait = .modifier(InfoPositionModifier(infoPosition: .outer))

        static let allGeometry: Trait = .traits([.safeAreaInsets])

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

    struct SafeAreaInsetsModifier: Modifier {
        func update(options: inout DebugOutlineModifier.NewOptions) {
            options.displaysSafeAreaInsets = true
        }
    }

}
