//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct HeaderFooterContainerView<Content: View>: View {

    // TODO: make 12 for ios, 8 for macOS
    static var minimumConcentricRadius: Double { 12.0 }

    let options: HeaderFooterPreviewOptions
    let content: () -> Content


    init(options: HeaderFooterPreviewOptions = [], @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.options = options
    }


    var body: some View {
        VStack(spacing: 0) {
            PreviewHeaderView(flexibleHeight: !options.contains(.fixedHeader))

            if options.contains(.showDividers) {
                Divider()
            }

            content()

            if options.contains(.showDividers) {
                Divider()
            }

            PreviewFooterView(flexibleHeight: !options.contains(.fixedFooter))
        } // VStack
    }

}


// Extends `Sendable` based in other `OptionSet`s present in SwiftUI, like `ContentShapeKinds` and
// `PinnedScrollableViews`.
public struct HeaderFooterPreviewOptions: OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let empty: Self =        .init(rawValue: 0)
    public static let fixedHeader: Self  = .init(shiftedBy: 0)
    public static let fixedFooter: Self  = .init(shiftedBy: 1)
    public static let showDividers: Self = .init(shiftedBy: 2)

    public static let fixed: Self = [.fixedHeader, .fixedFooter]
}


// MARK: - Previews


private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .fixedLayout(width: 400, height: 600)

}


#Preview("Default", traits: PreviewContent.layout) {
    HeaderFooterContainerView {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


#Preview("Fixed Header", traits: PreviewContent.layout) {
    HeaderFooterContainerView(options: .fixedHeader) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


// TODO: footer looks too tall in watchOS
#Preview("Fixed Footer", traits: PreviewContent.layout) {
    HeaderFooterContainerView(options: .fixedFooter) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


#Preview("Fixed Both", traits: PreviewContent.layout) {
    HeaderFooterContainerView(options: .fixed) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


#Preview("Fixed Both, Inflexible", traits: PreviewContent.layout) {
    HeaderFooterContainerView(options: .fixed) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
            .frame(width: 100, height: 100)
    }
}


#Preview("Show Dividers", traits: PreviewContent.layout) {
    HeaderFooterContainerView(options: .showDividers) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


#Preview("Multiple traits", traits: PreviewContent.layout) {
    HeaderFooterContainerView(options: [.fixed, .showDividers]) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}
