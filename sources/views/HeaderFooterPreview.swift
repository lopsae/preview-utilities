//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct HeaderFooterPreview<Content: View>: View {

    // TODO: make 12 for ios, 8 for macOS
    static var minimumConcentricRadius: Double { 12.0 }

    let options: HeaderFooterPreviewOptions
    let content: Content


    init(options: HeaderFooterPreviewOptions = [], @ViewBuilder content: () -> Content) {
        self.content = content()
        self.options = options
    }


    var body: some View {
        VStack(spacing: 0) {
            PreviewHeaderView(flexibleHeight: !options.contains(.fixedHeader))

            if options.contains(.showDividers) {
                Divider()
            }

            content

            if options.contains(.showDividers) {
                Divider()
            }

            VStack (spacing: 0) {
                if !options.contains(.fixedFooter) {
                    Spacer()
                }
                Text("Footer")
                    .foregroundStyle(.tertiary)
                    // Double padding to account for background padding.
                    .padding(.top)
                    .padding(.top)
                    .maxWidthFrame()
            } // VStack
            .background {
                ConcentricRectangle(corners: .concentric(minimum: 12))
                .fill(.gray.tertiary)
                .padding()
                .ignoresSafeArea()
            } // background
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


// MARK: - Previews.

// TODO: add previews that test the safeareas vs min paddings

// TODO: update all previews with layout
@MainActor
private let previewLayout: PreviewTrait<Preview.ViewTraits> = .fixedLayout(width: 400, height: 600)

#Preview("Default", traits: previewLayout) {
    HeaderFooterPreview {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


#Preview("Fixed Header", traits: previewLayout) {
    HeaderFooterPreview(options: .fixedHeader) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


// TODO: footer looks too tall in watchOS
#Preview("Fixed Footer") {
    HeaderFooterPreview(options: .fixedFooter) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


#Preview("Fixed Both") {
    HeaderFooterPreview(options: .fixed) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


// TODO: with an element of a set height, header and footer have display issues
// TODO: in macOS, in all cases, footer is displayed too close to edge
#Preview("Fixed Both, Inflexible") {
    HeaderFooterPreview(options: .fixed) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
            .frame(width: 100, height: 100)
    }
}


#Preview("Show Dividers") {
    HeaderFooterPreview(options: .showDividers) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}


#Preview("Multiple traits") {
    HeaderFooterPreview(options: [.fixed, .showDividers]) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}
