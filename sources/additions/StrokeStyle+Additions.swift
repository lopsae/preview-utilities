//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


extension StrokeStyle {

    /// Default dashed configuration used by `DashedDivider`.
    ///
    /// Sets a dash configuration based on the line width: 5 measures of dash followed by 6 measures
    /// of space. With a round cap this results visually in a 6 measure dash with 5 measures of
    /// space.
    static func dashed(width: CGFloat = 1, cap: CGLineCap = .round) -> Self {
        .init(
            lineWidth: width, lineCap: cap, lineJoin: .round,
            dash: [width*5, width*6], dashPhase: .zero
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

    static let allCases: [CGLineCap] = [.butt, .round, .square]

}


// MARK: - PreviewContent


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


// MARK: Previews


#Preview("Default", traits: .paddingSpacing, .fixedHeader, PreviewContent.layout) {
    ForEach(CGLineCap.allCases) { lineCap in
        AxialLine(
            .horizontal, style: .red.secondary,
            strokeStyle: .dashed(cap: lineCap)
        )
    }

    let lineWidth: CGFloat = 10
    VStack(items: CGLineCap.allCases) { lineCap in
        let strokeStyle: StrokeStyle = .dashed(width: lineWidth, cap: lineCap)
        AxialLine(.horizontal, style: .red.secondary, strokeStyle: strokeStyle)
    }
    .edgeGraticule(insetSpacing: lineWidth, insetCount: 0, .inset(.leading, count: 30))
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

    // FIXME: use items as parameter for hashable elements.
    init(
        _ data: Data,
        @ContentBuilder content: @escaping (Data.Element) -> Content
    ) where
        Data.Element: Hashable,
        Data.Element == ID
    {
        self.init(data, id: \.self, content: content)
    }

}
