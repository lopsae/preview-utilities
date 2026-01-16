//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


public struct HeaderFooterContainer<Content: View>: View {

    let enableEdgePadding: Bool
    let options: HeaderFooterPreviewOptions
    let content: () -> Content


    // Enable edge padding is enabled by default assuming that when this view is used directly, it
    // is used in an environment without large safe areas. There are not many examples of this use
    // tho. Also, SafeAreaPad may now provide a better alternative in those cases.
    // To use standalone, the header needs modified padding, otherwise it sticks too close to the
    // edge. An enum of possible configuration (iOS, macOS, standalone) could be used.
    init(
        enableEdgePadding: Bool = true,
        options: HeaderFooterPreviewOptions = .default,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.enableEdgePadding = enableEdgePadding
        self.content = content
        self.options = options
    }


    public var body: some View {
        VStack(spacing: .zero) {
            let contentPadding: CGFloat? = options.contains(.padContent)
                ? nil // Default padding.
                : .zero

            PreviewHeader(enableTopPadding: enableEdgePadding, flexibleHeight: !options.contains(.fixedHeader))

            if options.contains(.showDividers) {
                DashedDivider()
                .padding(.horizontal, contentPadding)
            }

            VStack {
                content()
            }
            .padding(.horizontal, contentPadding)

            if options.contains(.showDividers) {
                DashedDivider()
                .padding(.horizontal, contentPadding)
            }

            PreviewFooter(enableBottomPadding: enableEdgePadding, flexibleHeight: !options.contains(.fixedFooter))
        } // VStack
    }

}


// MARK: - Defaults


extension HeaderFooterContainer where Content == Never {

    // TODO: make 12 for ios, 8 for macOS
    static var minimumConcentricRadius: Double { 12 }

    static var backgroundStyle: some ShapeStyle { .gray.tertiary }

}


// MARK: - Options


// TODO: rename to HeaderFooterContainerOptions or Traits
// Extends `Sendable` based in other `OptionSet`s present in SwiftUI, like `ContentShapeKinds` and
// `PinnedScrollableViews`.
public struct HeaderFooterPreviewOptions: OptionSet, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let empty:        Self = .init(rawValue: .zero)
    public static let fixedHeader:  Self = .init(shiftedBy: 0)
    public static let fixedFooter:  Self = .init(shiftedBy: 1)
    public static let showDividers: Self = .init(shiftedBy: 2)
    public static let padContent:   Self = .init(shiftedBy: 3)
    public static let all:          Self = .init(allUpTo:   4)

    public static let `default`: Self = .padContent

    public static let fixed: Self = [.fixedHeader, .fixedFooter]
}


// MARK: - Trait


// TODO: can a OptionSetOperationTrait be abstracted into a protocol?
public enum HeaderFooterContainerTrait {
    case union(HeaderFooterPreviewOptions)
    case remove(HeaderFooterPreviewOptions)

    func apply(to options: HeaderFooterPreviewOptions) -> HeaderFooterPreviewOptions {
        switch self {
        case .union(let traitOptions):
            return options.union(traitOptions)
        case .remove(let traitOptions):
            let inverse = traitOptions.symmetricDifference(.all)
            return options.intersection(inverse)
        }
    }


    public static let fixedHeader:  Self = .union(.fixedHeader)
    public static let fixedFooter:  Self = .union(.fixedFooter)
    public static let showDividers: Self = .union(.showDividers)
    public static let padContent:   Self = .union(.padContent)

    public static let fixed:        Self = .union(.fixed)

    public static let noPadding: Self = .remove(.padContent)

}


extension Sequence where Element == HeaderFooterContainerTrait {
    func apply(to options: HeaderFooterPreviewOptions) -> HeaderFooterPreviewOptions {
        return self.reduce(options) { options, trait in
            trait.apply(to: options)
        }
    }
}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .fixedLayout(width: 400, height: 600)

    /// Representative of behaviour used in ``HeaderFooterPreviewModifier``, where the header and
    /// footer is always displayed in a preview where in iOS there is a top and bottom safe-area.
    static var platformEnableEdgePadding: Bool {
        #if os(macOS)
        true
        #else
        false
        #endif
    }

}


#Preview("Default", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var isHeaderFixed: Bool = false
    @Previewable @State var isFooterFixed: Bool = false
    @Previewable @State var showsDividers: Bool = false
    @Previewable @State var useDeviceSafeArea: Bool = true
    @Previewable @State var enableEdgePadding: Bool = PreviewContent.platformEnableEdgePadding

    let makeOptions: () -> HeaderFooterPreviewOptions = {
        var options: HeaderFooterPreviewOptions = .default
        if isHeaderFixed { options.formUnion(.fixedHeader) }
        if isFooterFixed { options.formUnion(.fixedFooter) }
        if showsDividers { options.formUnion(.showDividers) }
        return options
    }

    let options = makeOptions()

    if !useDeviceSafeArea {
        SafeAreaPad(edge: .top, showDivider: true)
    }

    HeaderFooterContainer(enableEdgePadding: enableEdgePadding, options: options) {
        Toggle("Fixed Header", isOn: $isHeaderFixed)
        Toggle("Fixed Footer", isOn: $isFooterFixed)
        Toggle("Show Dividers", isOn: $showsDividers)
        Divider()
        Toggle("Use Device SafeArea", isOn: $useDeviceSafeArea)
        Toggle("Enable Edge Padding", isOn: $enableEdgePadding)
        Text("Platform default: \(PreviewContent.platformEnableEdgePadding.description)")
            .font(.caption.monospaced())
    }

    if !useDeviceSafeArea {
        SafeAreaPad(edge: .bottom, showDivider: true)
    }
}


#Preview("Content Height", traits: .zeroSpacing, PreviewContent.layout) {
    @Previewable @State var isHeaderFixed: Bool = false
    @Previewable @State var isFooterFixed: Bool = false
    @Previewable @State var useDeviceSafeArea: Bool = true
    @Previewable @State var enableEdgePadding: Bool = PreviewContent.platformEnableEdgePadding
    @Previewable @State var fixedHeight: Double = 200

    let makeOptions: () -> HeaderFooterPreviewOptions = {
        var options: HeaderFooterPreviewOptions = [.default, .showDividers]
        if isHeaderFixed { options.formUnion(.fixedHeader) }
        if isFooterFixed { options.formUnion(.fixedFooter) }
        return options
    }

    let options = makeOptions()

    if !useDeviceSafeArea {
        SafeAreaPad(edge: .top, showDivider: true)
    }

    HeaderFooterContainer(enableEdgePadding: enableEdgePadding, options: options) {
        VStack {
            Toggle("Fixed Header", isOn: $isHeaderFixed)
            Toggle("Fixed Footer", isOn: $isFooterFixed)
            Slider.captioned(
                "Fixed Content Height",
                value: $fixedHeight,
                in: 0...800,
                currentValueFormat: .fractionLength(2),
                boundsValueFormat: .arithmeticRoundedInteger)
                .padding(.bottom)
            Divider()
            Toggle("Use Device SafeArea", isOn: $useDeviceSafeArea)
            Toggle("Enable Edge Padding", isOn: $enableEdgePadding)
            Text("Platform default: \(PreviewContent.platformEnableEdgePadding.description)")
                .font(.caption.monospaced())
        }
        .padding(.vertical)

        CaptionRectangle(
            "Fixed Content", color: .red,
            width: 150, height: fixedHeight,
            traits: .height)
    }

    if !useDeviceSafeArea {
        SafeAreaPad(edge: .bottom, showDivider: true)
    }
}
