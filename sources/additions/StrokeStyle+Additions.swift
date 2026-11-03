//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


public import SwiftUI


extension StrokeStyle {

    /// Default dashed stroke style used by `DashedDivider`.
    /// 
    /// Creates a dashed stroke based on the line width: 5 measures of dash followed by 6 measures
    /// of space. With a round cap this results visually in a 6 measure dash with 5 measures of
    /// space.
    ///
    /// - Parameters:
    ///   - width: The line width of the stroke style.
    ///   - cap: The endpoint style.
    /// - Returns: A `DashedDivider` stroke style.
    static public func dividerDash(width: CGFloat = 1, cap: CGLineCap = .round) -> Self {
        .dashed(width: width, dash: 5, space: 6, cap: cap)
    }


    /// Dashed stroke style with dash and space length based on line width.
    ///
    /// Creates a dashed stroke with a dash and space length measured in line-widths. With a `butt`
    /// line cap, the dash and space will measure the given values; with a `round` or `square` line
    /// caps the dash will measure `length+1`, and the space will measure `space-1`.
    ///
    /// ```
    /// // Dashed stroke with a 70 point dash, and 30 point space.
    /// StrokeStyle.dashed(width: 10, length: 7, space: 3, cap: .butt)
    ///
    /// // Dashed stroke with a 80 point dash, and 20 point space.
    /// StrokeStyle.dashed(width: 10, length: 7, space: 3, cap: .round)
    /// ```
    ///
    /// - Parameters:
    ///   - width: The line width of the stroke style, and the unit of measure for dash and space
    ///       length.
    ///   - dash: The length of the dash, in line-widths.
    ///   - space: The length of the space, in line-widths
    ///   - cap: The endpoint style.
    /// - Returns: A dashed stroke style with the given measures.
    static public func dashed(
        width: CGFloat = 1,
        dash: CGFloat,
        space: CGFloat,
        cap: CGLineCap = .round
    ) -> Self {
        .init(
            lineWidth: width, lineCap: cap, lineJoin: .round,
            dash: [width * dash, width * space], dashPhase: .zero
        )
    }

}


extension CGLineCap {

    var displayName: String {
        switch self {
        case .butt:   "butt"
        case .round:  "round"
        case .square: "square"
        @unknown default:
            "unknown"
        }
    }

}


extension CGLineCap: @retroactive CaseIterable {

    public static let allCases: [CGLineCap] = [.butt, .round, .square]

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: Previews


#Preview("Default", traits: .paddingSpacing, .fixedHeader, PreviewContent.layout) {
    let dashLengths: [(dash: CGFloat, space: CGFloat)] = [
        (2, 4),
        (4, 4)
    ]
    ForEach(dashLengths.indexed(), id: \.index) { index, lengths in
        ForEach(items: CGLineCap.allCases) { lineCap in
            let strokeStyle: StrokeStyle = .dashed(
                width: 4, dash: lengths.dash, space: lengths.space, cap: lineCap
            )
            AxialLine(
                .horizontal, style: .red.secondary,
                strokeStyle: strokeStyle
            )
        }

        let lineWidth: CGFloat = 20
        VStack(items: CGLineCap.allCases) { lineCap in
            let strokeStyle: StrokeStyle = .dashed(
                width: lineWidth, dash: lengths.dash, space: lengths.space, cap: lineCap
            )
            AxialLine(.horizontal, style: .red.secondary, strokeStyle: strokeStyle)
        }
        .edgeGraticule(insetSpacing: lineWidth, insetCount: .zero, .inset(.leading, count: 20))
    }

}


#Preview("DividerDash", traits: .paddingSpacing, .fixedHeader, PreviewContent.layout) {
    ForEach(items: CGLineCap.allCases) { lineCap in
        AxialLine(
            .horizontal, style: .red.secondary,
            strokeStyle: .dividerDash(cap: lineCap)
        )
    }

    ForEach(items: CGLineCap.allCases) { lineCap in
        AxialLine(
            .horizontal, style: .red.secondary,
            strokeStyle: .dividerDash(width: 4, cap: lineCap)
        )
    }

    let lineWidth: CGFloat = 20
    VStack(items: CGLineCap.allCases) { lineCap in
        let strokeStyle: StrokeStyle = .dividerDash(width: lineWidth, cap: lineCap)
        AxialLine(.horizontal, style: .red.secondary, strokeStyle: strokeStyle)
    }
    .edgeGraticule(insetSpacing: lineWidth, insetCount: .zero, .inset(.leading, count: 20))
}


// TODO: Consider using selfidentifiable.
// items param could be used for hashable values that self identify
// identifiables: for self-identifying? Picker uses `selectable` since are selectable values.
private extension ForEach {

    init(
        items: ID...,
        @ContentBuilder content: @escaping (ID) -> Content
    ) where Data == [ID] {
        self.init(items, id: \.self, content: content)
    }

    init(
        items: Data,
        @ContentBuilder content: @escaping (Data.Element) -> Content
    ) where
        Data.Element: Hashable,
        Data.Element == ID
    {
        self.init(items, id: \.self, content: content)
    }

}
