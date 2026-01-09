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
        VStack(spacing: .zero) {
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

    public static let empty: Self =        .init(rawValue: .zero)
    public static let fixedHeader: Self  = .init(shiftedBy: 0)
    public static let fixedFooter: Self  = .init(shiftedBy: 1)
    public static let showDividers: Self = .init(shiftedBy: 2)

    public static let fixed: Self = [.fixedHeader, .fixedFooter]
}


extension HeaderFooterContainerView where Content == Never {

    // TODO: make 12 for ios, 8 for macOS
    static var minimumConcentricRadius: Double { 12 }

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
    @Previewable @State var isFixedContent: Bool = false

    var options: HeaderFooterPreviewOptions = []
    if isHeaderFixed { options.formUnion(.fixedHeader) }
    if isFooterFixed { options.formUnion(.fixedFooter) }
    if showsDividers { options.formUnion(.showDividers) }

    return HeaderFooterContainerView(options: options) {
        VStack {
            Toggle("Fixed Header", isOn: $isHeaderFixed)
            Toggle("Fixed Footer", isOn: $isFooterFixed)
            Toggle("Show Dividers", isOn: $showsDividers)
            Divider()
            Toggle("Fixed Content", isOn: $isFixedContent)
                .padding(.bottom)
        }.padding(.horizontal)

        Divider()

        Rectangle()
            .fill(.teal.secondary)
            .frame(width: 200, height: isFixedContent ? 100 : .infinity)
            .debugOverlay(.hairline, .size)
    }
}


// FIXME: in ios when fixed height content pushes the footer out of the view boundaries, triggers an infinite update to currentSafeAreaInset. Issue does not happen in header.
#Preview("Content Height", traits: PreviewContent.layout) {
    @Previewable @State var isHeaderFixed: Bool = false
    @Previewable @State var isFooterFixed: Bool = false
    @Previewable @State var contentHeight: Double = 200

    var options: HeaderFooterPreviewOptions = []
    if isHeaderFixed { options.formUnion(.fixedHeader) }
    if isFooterFixed { options.formUnion(.fixedFooter) }

    return HeaderFooterContainerView(options: options) {
        VStack {
            Toggle("Fixed Header", isOn: $isHeaderFixed)
            Toggle("Fixed Footer", isOn: $isFooterFixed)
            Slider(
                "Content Height",
                value: $contentHeight,
                in: 0...800,
                valueFormat: .roundedIntegerToNearestOrEven)
                .padding(.bottom)
        }.padding(.horizontal)

        Divider()

        Rectangle()
            .fill(.teal.secondary)
            .frame(width: 200, height: contentHeight)
            .debugOverlay(.hairline, .size)
    }
}
