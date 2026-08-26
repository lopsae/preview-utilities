//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


/// Overlays a graticule based on the edges of a view.
///
/// Displays in an overlay a graticule based on the edges of the owner view. The graticule consists
/// of sets of lines evenly spaced for each of the edges of the owner view, both inset and
/// outset:
///
/// ![Inset components of the edge graticule.](edge-graticule-inset-components)
///
/// ![Outset components of the edge graticule.](edge-graticule-outset-components)
///
/// All content added by this modifier is layered in an overlay of the owner view; the original
/// layout is never modified.
///
/// Apply this modifier using ``SwiftUICore/View/edgeGraticule(spacing:_:)`` or any
/// [sibling function](doc:edge-graticule-api/View-Extensions):
///
/// ```swift
/// Capsule()
/// .fill(.cyan.gradient.secondary)
/// .frame(width: 200, height: 60)
/// .edgeGraticule(spacing: 16)
/// ```
/// ![Edge graticule overlaid on a capsule shape, showing inset and outset line sets of even spacing.](edge-graticule-default)
///
///
/// ### Traits and Configuration
///
/// The number of lines and spacing can be customized for each edge, and for
/// each direction, by passing [`Trait`](doc:EdgeGraticuleModifier/Trait) instances to ``SwiftUICore/View/edgeGraticule(spacing:_:)``
/// or any [sibling function](doc:edge-graticule-api/View-Extensions):
///
/// ```swift
/// RoundedRectangle(cornerRadius: 16)
/// .fill(.teal.gradient.secondary)
/// .frame(width: 100, height: 100)
/// .edgeGraticule(
///     spacing: 8,
///     // Customize spacing for leading outset.
///     .outset(.leading, spacing: 8*3),
///     // Customize count for bottom inset.
///     .inset(.bottom, count: 3)
/// )
/// ```
/// ![Edge graticule overlaid on a rounded rectangle shape, showing a customized graticule with modified linesets.](edge-graticule-per-edge-traits)
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


    /// Configuration of an `EdgeGraticuleModifier`.
    ///
    /// Contains the configuration for all line sets composing the edge graticule.
    ///
    /// Usually you don't build this object directly, instead one is created and configured using
    /// the [`Trait`](doc:EdgeGraticuleModifier/Trait) instances passed to ``SwiftUICore/View/edgeGraticule(spacing:_:)``
    /// or other [sibling functions](doc:edge-graticule-api/View-Extensions):
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

    /// Layers in front of this view an edge graticule with the given spacing for all line sets.
    ///
    /// Applies the ``EdgeGraticuleModifier`` overlaying a graticule based on the edges of the view.
    /// The given spacing is set for all line sets, with a count of 1. The modifier can be
    /// customized with the given [`Trait`](doc:EdgeGraticuleModifier/Trait) instances.
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


    /// Layers in front of this view an edge graticule with the given inset and outset spacing and
    /// counts for all line sets.
    ///
    /// Applies the ``EdgeGraticuleModifier`` overlaying a graticule based on the edges of the view.
    /// The inset and outset spacing and counts are set to the given values. The modifier can be
    /// customized with the given [`Trait`](doc:EdgeGraticuleModifier/Trait) instances.
    ///
    /// When an spacing value is not given, the count is ignored and set to `zero`. If no parameters
    /// are given to this function, no graticule is drawn.
    ///
    /// The traits are applied in order to a default configuration. Later traits may override
    /// earlier ones depending on the configuration each trait modifies.
    /// 
    /// - Parameters:
    ///   - insetSpacing: The spacing for all inset line sets.
    ///   - insetCount: The number of inset line sets; only used if `insetSpacing` is also given;
    ///     defaults to `zero`.
    ///   - outsetSpacing: The spacing for all outset line sets.
    ///   - outsetCount: The number of outset line sets; only used if `outsetSpacing` is also given;
    ///     defaults to `zero`.
    ///   - traits: The traits to customize the default configuration.
    ///
    /// - Returns: A view with a configured edge graticule as foreground.
    public func edgeGraticule(
        insetSpacing: CGFloat? = nil,
        insetCount: Int? = nil,
        outsetSpacing: CGFloat? = nil,
        outsetCount: Int? = nil,
        _ traits: ConfigurationTrait<EdgeGraticuleModifier.Configuration>...
    ) -> some View {
        var configuration: EdgeGraticuleModifier.Configuration = .empty
        if let insetSpacing {
            configuration.insetLineSets = .init(spacing: insetSpacing, through: insetCount ?? .one)
        }
        if let outsetSpacing {
            configuration.outsetLineSets = .init(spacing: outsetSpacing, through: outsetCount ?? .one)
        }
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
    .edgeGraticule(outsetSpacing: 20, outsetCount: 2)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .floatingCaption("Only Inset", .alignment(.outerTop))
    .floatingCaption("3", .alignment(.top))
    .edgeGraticule(insetSpacing: 10, insetCount: 3)

    DashedDivider()

    Text("Ag")
    .font(.title.pointSize(100))
    .border(.green.tertiary, width: 10)
    .floatingCaption("Inset & Outset", .alignment(.outerTop))
    .floatingCaption("3", .alignment(.top))
    .floatingCaption("2", .alignment(.outerTrailing))
    .edgeGraticule(insetSpacing: 10, insetCount: 3, outsetSpacing: 20, outsetCount: 2)
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
