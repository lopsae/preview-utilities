//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// A annotation mark that spans a length and points toward a describing label.
///
/// A caliper draws a bar along one edge of its frame and a stem from the middle of the bar to the
/// opposite edge. The stem points away from the bar, toward the label that describes the spanned
/// region.
struct Caliper: Shape {

    /// The edge along which the spanning bar is drawn.
    ///
    /// The stem extends from the middle of the bar toward the opposite edge, where the describing
    /// label is expected to sit.
    var barEdge: Edge

    nonisolated func path(in rect: CGRect) -> Path {
        Path { path in
            switch barEdge {
            case .leading:
                path.move(to: [rect.minX, rect.minY])
                path.addLine(to: [rect.minX, rect.maxY])
                path.move(to: [rect.minX, rect.midY])
                path.addLine(to: [rect.maxX, rect.midY])
            case .trailing:
                path.move(to: [rect.maxX, rect.minY])
                path.addLine(to: [rect.maxX, rect.maxY])
                path.move(to: [rect.minX, rect.midY])
                path.addLine(to: [rect.maxX, rect.midY])
            case .top:
                path.move(to: [rect.minX, rect.minY])
                path.addLine(to: [rect.maxX, rect.minY])
                path.move(to: [rect.midX, rect.minY])
                path.addLine(to: [rect.midX, rect.maxY])
            case .bottom:
                path.move(to: [rect.minX, rect.maxY])
                path.addLine(to: [rect.maxX, rect.maxY])
                path.move(to: [rect.midX, rect.minY])
                path.addLine(to: [rect.midX, rect.maxY])
            }
        }
    }

}


extension View {

    /// Pairs `self`, used as a label, with a `Caliper` pointing back toward it.
    ///
    /// The caliper is placed on the side of `self` indicated by `barEdge`, so that its stem points
    /// from the bar back toward the label.
    ///
    /// - Parameters:
    ///   - barEdge: The edge along which the caliper's bar is drawn, and the side of `self` on which
    ///     the caliper is placed.
    ///   - size: The size of the caliper mark.
    ///   - spacing: The spacing between the label and the caliper.
    func caliper(
        _ barEdge: Edge,
        size: CGSize,
        spacing: CGFloat = 4,
    ) -> some View {
        let mark = Caliper(barEdge: barEdge)
            .stroke(.primary)
            .frame(size: size)

        // FUTURE: can this be laidout with a generic Layout and the direction?
        switch barEdge {
        case .leading:
            return AnyView(HStack(spacing: spacing) { mark; self })
        case .trailing:
            return AnyView(HStack(spacing: spacing) { self; mark })
        case .top:
            return AnyView(VStack(spacing: spacing) { mark; self })
        case .bottom:
            return AnyView(VStack(spacing: spacing) { self; mark })
        }
    }

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter, PreviewContent.layout) {
    Text("Top Caliper")
    .caliper(.top, size: [40, 20])

    DashedDivider()

    Text("Bottom Caliper")
    .caliper(.bottom, size: [40, 20])

    DashedDivider()

    Text("Leading Caliper")
    .caliper(.trailing, size: [40, 20])

    DashedDivider()

    Text("Trailing Caliper")
    .caliper(.trailing, size: [40, 20])
}
