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

        init(insetLineSets: EdgeValues<EdgeGraticule.LineSet>, outsetLineSets: EdgeValues<EdgeGraticule.LineSet>) {
            self.insetLineSets  = insetLineSets
            self.outsetLineSets = outsetLineSets
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
        static var empty: Self { .init(insetLineSets: .empty, outsetLineSets: .empty) }

    }

}


// MARK: - Traits


/// Contains the configuration traits that can be applied to ``EdgeGraticuleModifier.Configuration``.
extension EdgeGraticuleModifier.Trait {

    // FIXME: Document.
    public static func inset(
        _ edgeSet: Edge.Set,
        spacing: CGFloat? = nil,
        count: Int? = nil
    ) -> Self {
        .mutate {
            if let count {
                $0.insetLineSets[set: edgeSet].indices = IndexSet(integersIn: 0...count)
            }
            if let spacing {
                $0.insetLineSets[set: edgeSet].spacing = spacing
            }
        }
    }


    // FIXME: Document.
    public static func outset(
        _ edgeSet: Edge.Set,
        spacing: CGFloat? = nil,
        count: Int? = nil
    ) -> Self {
        .mutate {
            if let count {
                $0.outsetLineSets[set: edgeSet].indices = IndexSet(integersIn: 0...count)
            }
            if let spacing {
                $0.outsetLineSets[set: edgeSet].spacing = spacing
            }
        }
    }

}


// MARK: - View Extensions


extension View {

    // FIXME: Document.
    public func edgeGraticule(
        spacing: CGFloat,
        _ traits: ConfigurationTrait<EdgeGraticuleModifier.Configuration>...
    ) -> some View {
        var configuration = EdgeGraticuleModifier.Configuration(spacing: spacing)
        configuration.apply(traits: traits)
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
    public func edgeGraticule(
        insetSpacing: CGFloat,
        through count: Int,
        _ traits: ConfigurationTrait<EdgeGraticuleModifier.Configuration>...
    ) -> some View {
        var configuration = EdgeGraticuleModifier.Configuration(
            insetLineSets:  .init(spacing: insetSpacing, through: count),
            outsetLineSets: .empty
        )
        configuration.apply(traits: traits)
        let graticuleModifier = EdgeGraticuleModifier(configuration: configuration)
        return modifier(graticuleModifier)
    }


    // FIXME: Document.
    public func edgeGraticule(
        outsetSpacing: CGFloat,
        through count: Int,
        _ traits: ConfigurationTrait<EdgeGraticuleModifier.Configuration>...
    ) -> some View {
        var configuration = EdgeGraticuleModifier.Configuration(
            insetLineSets:  .empty,
            outsetLineSets: .init(spacing: outsetSpacing, through: count)
        )
        configuration.apply(traits: traits)
        let graticuleModifier = EdgeGraticuleModifier(configuration: configuration)
        return modifier(graticuleModifier)
    }


    // FIXME: Document.
    public func edgeGraticule(
        insetSpacing: CGFloat,
        through insetCount: Int,
        outsetSpacing: CGFloat,
        through outsetCount: Int,
        _ traits: ConfigurationTrait<EdgeGraticuleModifier.Configuration>...
    ) -> some View {
        var configuration = EdgeGraticuleModifier.Configuration(
            insetLineSets:  .init(spacing: insetSpacing,  through: insetCount),
            outsetLineSets: .init(spacing: outsetSpacing, through: outsetCount)
        )
        configuration.apply(traits: traits)
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
    .floatingCaption("Only Spacing", .alignment(.outerTop))
    .edgeGraticule(spacing: 20)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .floatingCaption("Both Spacings", .alignment(.outerTop))
    .edgeGraticule(insetSpacing: 10, outsetSpacing: 20)
}


#Preview("Through", traits: .spacing(30), .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .floatingCaption("Only Outset", .alignment(.outerTop))
    .floatingCaption("2", .alignment(.outerTrailing))
    .edgeGraticule(outsetSpacing: 20, through: 2)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .floatingCaption("Only Inset", .alignment(.outerTop))
    .floatingCaption("3", .alignment(.top))
    .edgeGraticule(insetSpacing: 10, through: 3)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .floatingCaption("Inset & Outset", .alignment(.outerTop))
    .floatingCaption("3", .alignment(.top))
    .floatingCaption("2", .alignment(.outerTrailing))
    .edgeGraticule(insetSpacing: 10, through: 3, outsetSpacing: 20, through: 2)
}


#Preview("Traits", traits: .spacing(50), .headerFooter, PreviewContent.layout) {
    Text("Ag")
    .font(.title.pointSize(100))
    .foregroundStyle(.quinary)
    .border(.green.tertiary, width: 10)
    .floatingCaption("Only Inset", .alignment(.outerTop))
    .floatingCaption("3", .alignment(.top))
    .floatingCaption("5+SP", .alignment(.trailing))
    .edgeGraticule(insetSpacing: 10, outsetSpacing: 20,
        .inset(.vertical, count: 3),
        .inset(.trailing, spacing: 15, count: 5)
    )

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .floatingCaption("Only Outset", .alignment(.outerTop))
    .floatingCaption("2", .alignment(.outerBottom))
    .floatingCaption("3+SP", .alignment(.outerLeading))
    .edgeGraticule(insetSpacing: 10, outsetSpacing: 20,
        .outset(.vertical, count: 2),
        .outset(.leading, spacing: 30, count: 3)
    )

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .foregroundStyle(.quinary)
    .border(.green.tertiary, width: 10)
    .floatingCaption("Only Outset", .alignment(.outerTop))
    .floatingCaption("3+SP", .alignment(.top))
    .floatingCaption("2", .alignment(.outerTrailing))
    .edgeGraticule(insetSpacing: 10, outsetSpacing: 20,
        .inset(.vertical, spacing: 15, count: 3),
        .outset(.horizontal, count: 2)
    )
}
