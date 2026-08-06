//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI

// TODO: add images for snippets.

/// Overlays a graticule based on the edges of a view.
///
/// Displays in an overlay a graticule based on the edges of the owner view. The graticule consist
/// of sets of lines evenly spaced for each of the edges of the owner view, both inset and
/// outset. The number of lines and spacing can be configured for each edge, and for
/// each direction.
///
/// All content added by this modifier is layered in an overlay of the owner view, the original
/// layout is never modified.
///
/// Apply this modifier using ``SwiftUICore/View/edgeGraticule(spacing:_:)``:
///
/// ```swift
/// Text("Sphinx\nof Black\nQuartz")
/// .font(.title)
/// .edgeGraticule(spacing: 20)
/// ```
///
/// ### Traits and Configuration
///
/// The graticule can be configured by passing [`Trait`](doc:EdgeGraticuleModifier/Trait) instances
/// to ``SwiftUICore/View/edgeGraticule(spacing:_:)`` or any [sibling function](doc:edge-graticule-api/View-Extensions):.
///
/// ```swift
/// Text("Sphinx\nof Black\nQuartz")
/// .font(.title)
/// .edgeGraticule(
///     spacing: 20,
///     // modifies the spacing and count for bottom inset lines.
///     .inset(.bottom, spacing: 15, count: 2),
///     // Modifies the count for horizontal outset lines.
///     .outset(.horizontal, count: 3),
/// )
/// ```
public struct EdgeGraticuleModifier: ViewModifier {

    let configuration: Configuration

    @_documentation(visibility: internal)
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


    /// Configuration for an edge graticule modifier.
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

        /// A configuration with zero spacing and empty indices for all line sets.
        ///
        /// When using this configuration, the displayed ``EdgeGraticule`` produces an empty path.
        static var empty: Self { .init(insetLineSets: .empty, outsetLineSets: .empty) }

    }

}


// MARK: - Traits


extension EdgeGraticuleModifier {

    /// Customizations that can be applied to the `Configuration` of a `EdgeGraticuleModifier`.
    ///
    /// Traits are passed to ``SwiftUICore/View/edgeGraticule(spacing:_:)`` or any [sibling function](doc:edge-graticule-api/View-Extensions)
    /// to build the [`Configuration`](doc:EdgeGraticuleModifier/Configuration) of an edge graticule.
    ///
    /// All passed traits are applied in order to a default configuration, each trait making a
    /// modification towards the final configuration. If multiple traits modify the same
    /// configuration properties, the last one applied may overwrite former traits.
    ///
    ///
    /// ## Topics
    ///
    /// ### Traits
    /// + ``ConfigurationTrait/inset(_:spacing:count:)``
    /// + ``ConfigurationTrait/outset(_:spacing:count:)``
    /// + ``ConfigurationTrait/straddle(_:spacing:count:)``
    public typealias Trait = ConfigurationTrait<Configuration>

}


extension EdgeGraticuleModifier.Trait {

    /// Updates the inset line sets for the given edges.
    /// - Parameters:
    ///   - edgeSet: The edges for which to update the line sets.
    ///   - spacing: The spacing for the updated line sets.
    ///   - count: The number of lines to display for the updated edges.
    public static func inset(
        _ edgeSet: Edge.Set,
        spacing: CGFloat? = nil,
        count: Int? = nil
    ) -> EdgeGraticuleModifier.Trait {
        .mutate {
            if let count {
                $0.insetLineSets[set: edgeSet].indices = IndexSet(integersIn: 0...count)
            }
            if let spacing {
                $0.insetLineSets[set: edgeSet].spacing = spacing
            }
        }
    }


    /// Updates the outset line sets for the given edges.
    /// - Parameters:
    ///   - edgeSet: The edges for which to update the line sets.
    ///   - spacing: The spacing for the updated line sets.
    ///   - count: The number of lines to display for the updated edges.
    public static func outset(
        _ edgeSet: Edge.Set,
        spacing: CGFloat? = nil,
        count: Int? = nil
    ) -> EdgeGraticuleModifier.Trait {
        .mutate {
            if let count {
                $0.outsetLineSets[set: edgeSet].indices = IndexSet(integersIn: 0...count)
            }
            if let spacing {
                $0.outsetLineSets[set: edgeSet].spacing = spacing
            }
        }
    }


    /// Updates the inner and outset line sets for the given edges.
    /// - Parameters:
    ///   - edgeSet: The edges for which to update the line sets.
    ///   - spacing: The spacing for the updated line sets.
    ///   - count: The number of lines to display for the updated edges.
    public static func straddle(
        _ edgeSet: Edge.Set,
        spacing: CGFloat? = nil,
        count: Int? = nil
    ) -> EdgeGraticuleModifier.Trait {
        .mutate {
            if let count {
                $0.insetLineSets[set: edgeSet].indices  = IndexSet(integersIn: 0...count)
                $0.outsetLineSets[set: edgeSet].indices = IndexSet(integersIn: 0...count)
            }
            if let spacing {
                $0.insetLineSets[set: edgeSet].spacing  = spacing
                $0.outsetLineSets[set: edgeSet].spacing = spacing
            }
        }
    }

}


// MARK: - View Extensions


extension View {

    // TODO: Add images to docs.

    /// Layers in front of this view an edge graticule with the given spacing for all line sets.
    ///
    /// Applies the ``EdgeGraticuleModifier`` with the given spacing for all line sets, and
    /// customized with the given [`Trait`](doc:EdgeGraticuleModifier/Trait) instances, overlaying
    /// a graticule based on the edges of the view.
    ///
    /// The traits are applied in order to a default configuration. Later traits may override
    /// earlier ones depending on the configuration each trait modifies.
    ///
    /// ```swift
    /// Text("Sphinx\nof Black\nQuartz")
    /// .font(.title)
    /// .edgeGraticule(spacing: 20)
    /// ```
    /// 
    /// - Parameters:
    ///   - spacing: The spacing for all line sets.
    ///   - traits: The traits to customize the default configuration.
    ///
    /// - Returns: A view with a configured edge graticule as foreground.
    public func edgeGraticule(
        spacing: CGFloat,
        _ traits: ConfigurationTrait<EdgeGraticuleModifier.Configuration>...
    ) -> some View {
        var configuration = EdgeGraticuleModifier.Configuration(spacing: spacing)
        configuration.apply(traits: traits)
        let graticuleModifier = EdgeGraticuleModifier(configuration: configuration)
        return modifier(graticuleModifier)
    }


    /// Layers in front of this view an edge graticule with the given inset and outset spacing for
    /// all corresponding line sets.
    ///
    /// Applies the ``EdgeGraticuleModifier`` with the given inset and outset spacing for all
    /// corresponding line sets, and customized with the given [`Trait`](doc:EdgeGraticuleModifier/Trait)
    /// instances, overlaying a graticule based on the edges of the view.
    ///
    /// The traits are applied in order to a default configuration. Later traits may override
    /// earlier ones depending on the configuration each trait modifies.
    ///
    /// - Parameters:
    ///   - insetSpacing: The spacing for all inset line sets.
    ///   - outsetSpacing: The spacing for all outset line sets.
    ///   - traits: The traits to customize the default configuration.
    ///
    /// - Returns: A view with a configured edge graticule as foreground.
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


    /// Layers in front of this view an edge graticule with the given inset spacing and line set
    /// count, and no outset line sets.
    ///
    /// Applies the ``EdgeGraticuleModifier`` with the given inset spacing and line set count, no
    /// outset line sets, and customized with the given [`Trait`](doc:EdgeGraticuleModifier/Trait)
    /// instances, overlaying a graticule based on the edges of the view.
    ///
    /// The traits are applied in order to a default configuration. Later traits may override
    /// earlier ones depending on the configuration each trait modifies.
    ///
    /// - Parameters:
    ///   - insetSpacing: The spacing for all inset line sets.
    ///   - count: The number of inset lines to display for all edges.
    ///   - traits: The traits to customize the default configuration.
    ///
    /// - Returns: A view with a configured edge graticule as foreground.
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
