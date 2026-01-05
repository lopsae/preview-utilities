//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


public struct HeaderFooterContainerView<Content: View>: View {

    let options: HeaderFooterPreviewOptions
    let content: () -> Content


    init(options: HeaderFooterPreviewOptions = [], @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.options = options
    }


    public var body: some View {
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


extension HeaderFooterContainerView where Content == Never {

    // TODO: make 12 for ios, 8 for macOS
    static var minimumConcentricRadius: Double { 12.0 }

    static var backgroundStyle: some ShapeStyle { .gray.tertiary }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .fixedLayout(width: 400, height: 600)

}


#Preview("Default", traits: PreviewContent.layout) {
    @Previewable @State var isHeaderFixed: Bool = false
    @Previewable @State var isFooterFixed: Bool = false
    @Previewable @State var showsDividers: Bool = false

    var options: HeaderFooterPreviewOptions = .init()
    if isHeaderFixed { options.formUnion(.fixedHeader) }
    if isFooterFixed { options.formUnion(.fixedFooter) }
    if showsDividers { options.formUnion(.showDividers) }

    return HeaderFooterContainerView(options: options) {
        VStack {
            Toggle("Fixed Header", isOn: $isHeaderFixed)
            Toggle("Fixed Footer", isOn: $isFooterFixed)
            Toggle("Show Dividers", isOn: $showsDividers)
        }.padding(.horizontal)


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


#Preview("Multiple traits", traits: PreviewContent.layout) {
    HeaderFooterContainerView(options: [.fixed, .showDividers]) {
        StarShape(points: 8, concaveVertexRatio: 0.5)
            .fill(.orange)
    }
}
