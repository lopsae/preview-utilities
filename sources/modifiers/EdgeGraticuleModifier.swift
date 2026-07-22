//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


public struct EdgeGraticuleModifier: ViewModifier {

    typealias Trait = ConfigurationTrait<Configuration>

    let configuration: Configuration

    public func body(content: Content) -> some View {
        content
        .overlay {
            EdgeGraticule(
                insetLineSets: configuration.insetLineSets,
                outsetLineSets: configuration.outsetLineSets
            )
            .stroke(.quaternary)
        }
    }


    public struct Configuration: TraitConfigurable {

        var insetLineSets: EdgeValues<EdgeGraticule.LineSet>
        var outsetLineSets: EdgeValues<EdgeGraticule.LineSet>

        init(inset: EdgeValues<EdgeGraticule.LineSet>, outset: EdgeValues<EdgeGraticule.LineSet>) {
            self.insetLineSets  = inset
            self.outsetLineSets = outset
        }

        init(spacing: CGFloat) {
            insetLineSets  = .init(spacing: spacing)
            outsetLineSets = .init(spacing: spacing)
        }

        init(spacing: CGFloat, indices: IndexSet) {
            insetLineSets  = .init(spacing: spacing, indices: indices)
            outsetLineSets = .init(spacing: spacing, indices: indices)
        }

        init(insetSpacing: CGFloat = .zero, outsetSpacing: CGFloat = .zero) {
            insetLineSets  = .init(spacing: insetSpacing)
            outsetLineSets = .init(spacing: outsetSpacing)
        }

        /// A configuration with zero spacing and empty indices for both line sets.
        ///
        /// When using this configuration `EdgeGraticule` produces an empty path.
        static var empty: Self { .init(inset: .empty, outset: .empty) }

    }

}


// MARK: - Traits


/// Contains the configuration traits that can be applied to ``EdgeGraticuleModifier.Configuration``.
extension EdgeGraticuleModifier.Trait {

    // FIXME: document.
    public static func inset(_ edgeSet: Edge.Set, _ count: Int) -> Self {
        .mutate {
            $0.insetLineSets[set: edgeSet].indices = IndexSet(integersIn: 0...count)
        }
    }

}


// MARK: - View Extensions


extension View {

    // FIXME: Delete.
    public func edgeGraticule(
        insetSpacing: CGFloat,
        through insetCount: Int,
        outsetSpacing: CGFloat,
        through outsetCount: Int
    ) -> some View {
        let insetLineSets: EdgeValues<EdgeGraticule.LineSet> = .init(spacing: insetSpacing, through: insetCount)
        let outsetLineSets: EdgeValues<EdgeGraticule.LineSet> = .init(spacing: outsetSpacing, through: outsetCount)
        var configuration = EdgeGraticuleModifier.Configuration()
        configuration.insetLineSets = insetLineSets
        configuration.outsetLineSets = outsetLineSets
        let graticuleModifier = EdgeGraticuleModifier(configuration: configuration)
        return modifier(graticuleModifier)
    }


    // FIXME: Document.
    public func edgeGraticule(
        insetSpacing: CGFloat,
        outsetSpacing: CGFloat,
        _ traits: ConfigurationTrait<EdgeGraticuleModifier.Configuration>...
    ) -> some View {
        var configuration = EdgeGraticuleModifier.Configuration(
            insetSpacing: insetSpacing,
            outsetSpacing: outsetSpacing
        )
        configuration.apply(traits: traits)
        let graticuleModifier = EdgeGraticuleModifier(configuration: configuration)
        return modifier(graticuleModifier)
    }


    // FIXME: Document.
    public func edgeGraticule(insetSpacing: CGFloat, through count: Int) -> some View {
        var configuration = EdgeGraticuleModifier.Configuration()
        configuration.insetLineSets = .init(spacing: insetSpacing, through: count)
        configuration.outsetLineSets = .empty // FIXME: Empty is used and valid here to not show any inset
        let graticuleModifier = EdgeGraticuleModifier(configuration: configuration)
        return modifier(graticuleModifier)
    }


    // FIXME: Document.
    public func edgeGraticule(outsetSpacing: CGFloat, through count: Int) -> some View {
        var configuration = EdgeGraticuleModifier.Configuration()
        configuration.insetLineSets = .empty  // FIXME: Empty is used and valid here to not show any inset
        configuration.outsetLineSets = .init(spacing: outsetSpacing, through: count)
        let graticuleModifier = EdgeGraticuleModifier(configuration: configuration)
        return modifier(graticuleModifier)
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .spacing(30), .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .floatingCaption("Inset/Outset", .alignment(.outerTop))
    .edgeGraticule(insetSpacing: 10, outsetSpacing: 20, .inset(.vertical, 3), .inset(.trailing, 5))

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .floatingCaption("Only Inset", .alignment(.outerTop))
    .edgeGraticule(insetSpacing: 10, through: 2)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .floatingCaption("Only Outset", .alignment(.outerTop))
    .edgeGraticule(outsetSpacing: 20, through: 2)
}
