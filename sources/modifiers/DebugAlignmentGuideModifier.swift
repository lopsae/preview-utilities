//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct DebugAlignmentGuideModifier: ViewModifier {

    let alignment: Alignment

    func body(content: Content) -> some View {
        content
        .debugAlignmentGuide(horizontal: alignment.horizontal)
        .debugAlignmentGuide(vertical:  alignment.vertical)
    }

}


public struct DebugHorizontalAlignmentGuideModifier: ViewModifier {

    let horizontalAlignment: HorizontalAlignment
    let configuration: Configuration

    public func body(content: Content) -> some View {
        let alignment = Alignment(horizontal: horizontalAlignment, vertical: configuration.anchor)
        content.overlay(alignment: alignment) {
            ExtendedSizeLayout(addHeight: configuration.heightAddition) {
                Rectangle()
                .fill(.red.secondary)
                .frame(width: 2)
            }
        }
    }

    public struct Configuration {

        var isVisible: Bool = true
        var heightAddition: CGFloat = .zero
        var anchor: VerticalAlignment = .center

        init() {}

        init(traits: [Trait]) {
            self.init()
            for trait in traits {
                trait.apply(to: &self)
            }
        }
    }


    public enum Trait: Sendable {

        /// Applies the associated modifier.
        case modifier(any Modifier)

        /// Applies the associated traits.
        case traits([Trait])


        func apply(to configuration: inout Configuration) {
            switch self {
            case .modifier(let modifier):
                modifier.update(configuration: &configuration)
            case .traits(let traits):
                for trait in traits {
                    trait.apply(to: &configuration)
                }
            }
        }


        // FIXME: document.
        public static let hidden: Trait = .modifier(VisibilityModifier(isVisible: false))

        // FIXME: document.
        public static func visible(_ isVisible: Bool) -> Trait {
            .modifier(VisibilityModifier(isVisible: isVisible))
        }

        // FIXME: document.
        public static func addHeight(_ addition: CGFloat) -> Trait {
            .modifier(HeightAdditionModifier(heightAddition: addition))
        }

        // FIXME: document.
        public static func anchor(_ anchor: VerticalAlignment) -> Trait {
            .modifier(AnchorModifier(anchor: anchor))
        }

    }


    public protocol Modifier: Sendable {
        func update(configuration: inout Configuration)
    }

    struct VisibilityModifier: Modifier {
        let isVisible: Bool
        func update(configuration: inout Configuration) {
            configuration.isVisible = isVisible
        }
    }


    struct HeightAdditionModifier: Modifier {
        let heightAddition: CGFloat
        func update(configuration: inout Configuration) {
            configuration.heightAddition = heightAddition
        }
    }

    struct AnchorModifier: Modifier {
        let anchor: VerticalAlignment
        func update(configuration: inout Configuration) {
            configuration.anchor = anchor
        }
    }

}


struct DebugVerticalAlignmentGuideModifier: ViewModifier {

    let verticalAlignment: VerticalAlignment

    func body(content: Content) -> some View {
        let alignment = Alignment(horizontal: .center, vertical: verticalAlignment)
        content.overlay(alignment: alignment) {
            Rectangle()
            .fill(.red.secondary)
            .frame(height: 2)
        }
    }

}


// MARK: - View Extension


extension View {

    public func debugAlignmentGuide(_ alignment: Alignment) -> some View {
        return modifier(DebugAlignmentGuideModifier(alignment: alignment))
    }

    public func debugAlignmentGuide(
        horizontal horizontalAlignment: HorizontalAlignment,
        _ traits: DebugHorizontalAlignmentGuideModifier.Trait...
    ) -> some View {
        let configuration = DebugHorizontalAlignmentGuideModifier.Configuration(traits: traits)
        let guideModifier = DebugHorizontalAlignmentGuideModifier(
            horizontalAlignment: horizontalAlignment,
            configuration: configuration
        )
        return modifier(guideModifier)
    }

    public func debugAlignmentGuide(vertical verticalAlignment: VerticalAlignment) -> some View {
        return modifier(DebugVerticalAlignmentGuideModifier(verticalAlignment: verticalAlignment))
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.body.pointSize(60))
    .debugAlignmentGuide(.topLeading)
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(60))
    .debugAlignmentGuide(.centerCenter)
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(60))
    .debugAlignmentGuide(.trailingLastTextBaseline)
    .border(.green.tertiary, width: 8)
}


#Preview("Horizontal", traits: .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(horizontal: .leading)
    .debugAlignmentGuide(horizontal: .center, .addHeight(-50))
    .debugAlignmentGuide(horizontal: .trailing, .addHeight(50))
    .border(.green.tertiary, width: 8)
}


#Preview("Horizontal Anchored", traits: .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(horizontal: .leading, .addHeight(50), .anchor(.top))
    .debugAlignmentGuide(horizontal: .center, .addHeight(50) , .anchor(.firstTextBaseline))
    .debugAlignmentGuide(horizontal: .trailing, .addHeight(50), .anchor(.bottom))
    .border(.green.tertiary, width: 8)
}


#Preview("Vertical", traits: .fixedHeader, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .debugAlignmentGuide(vertical: .top)
    .debugAlignmentGuide(vertical: .firstTextBaseline)
    .debugAlignmentGuide(vertical: .verticalCenter)
    .debugAlignmentGuide(vertical: .lastTextBaseline)
    .debugAlignmentGuide(vertical: .bottom)
    .border(.green.tertiary, width: 8)

    DashedDivider()

    Text("Sphinx\nof Black\nQuartz")
    .font(.largeTitle)
    .debugAlignmentGuide(vertical: .top)
    .debugAlignmentGuide(vertical: .firstTextBaseline)
    .debugAlignmentGuide(vertical: .verticalCenter)
    .debugAlignmentGuide(vertical: .lastTextBaseline)
    .debugAlignmentGuide(vertical: .bottom)
    .border(.green.tertiary, width: 8)
}

