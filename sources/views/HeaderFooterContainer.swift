//
//  Preview Utilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


public struct HeaderFooterContainer<Content: View>: View {

    let enableEdgePadding: Bool
    let options: HeaderFooterContainerOptions
    let content: () -> Content


    // Enable edge padding is enabled by default assuming that when this view is used directly, it
    // is used in an environment without large safe areas. There are not many examples of this use
    // tho. Also, SafeAreaPad may now provide a better alternative in those cases.
    // To use standalone, the header needs modified padding, otherwise it sticks too close to the
    // edge. An enum of possible configuration (iOS, macOS, standalone) could be used.
    init(
        enableEdgePadding: Bool = true,
        options: HeaderFooterContainerOptions = .default,
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


// Extends `Sendable` based in other `OptionSet`s present in SwiftUI, like `ContentShapeKinds` and
// `PinnedScrollableViews`.
nonisolated
public struct HeaderFooterContainerOptions: OptionSet, IdentifiableShift, Sendable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    enum Shift: Int, CaseIterable, SelfIdentifiable, DisplayKeyProvider {
        case fixedHeader = 0,
             fixedFooter,
             showDividers,
             padContent

        var displayKey: LocalizedStringKey {
            switch self {
            case .fixedHeader:  "Fixed Header"
            case .fixedFooter:  "Fixed Footer"
            case .showDividers: "Show Dividers"
            case .padContent:   "Pad Content"
            }
        }
    }

    public static let empty:        Self = .init(rawValue: .zero)
    public static let fixedHeader:  Self = .init(shift: .fixedHeader)
    public static let fixedFooter:  Self = .init(shift: .fixedFooter)
    public static let showDividers: Self = .init(shift: .showDividers)
    public static let padContent:   Self = .init(shift: .padContent)

    public static let `default`: Self = .padContent

    public static let fixed: Self = [.fixedHeader, .fixedFooter]
}


// MARK: - Trait


public struct HeaderFooterContainerTrait: OptionSetTrait, Sendable {
    let operation: OptionSetTraitOperation<HeaderFooterContainerOptions>

    public static let fixedHeader:  Self = .union(.fixedHeader)
    public static let fixedFooter:  Self = .union(.fixedFooter)
    public static let showDividers: Self = .union(.showDividers)
    public static let padContent:   Self = .union(.padContent)

    public static let fixed:        Self = .union(.fixed)

    public static let noPadding: Self = .subtract(.padContent)
}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeForcedLayout

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
    @Previewable @State var options: HeaderFooterContainerOptions = .default
    @Previewable @State var useDeviceSafeArea: Bool = true
    @Previewable @State var enableEdgePadding: Bool = PreviewContent.platformEnableEdgePadding
    @Previewable @State var fixedHeight: Double = 100

    if !useDeviceSafeArea {
        SafeAreaPad(edge: .top, showDivider: true)
    }

    HeaderFooterContainer(enableEdgePadding: enableEdgePadding, options: options) {
        ForEach(HeaderFooterContainerOptions.Shift.allCases) { shift in
            Toggle(property: $options.displayProperty(for: shift))
        }

        Divider()

        Toggle("Use Device SafeArea", isOn: $useDeviceSafeArea)
        Toggle("Enable Edge Padding", isOn: $enableEdgePadding)
        Text("Platform default: \(PreviewContent.platformEnableEdgePadding.description)")
            .font(.caption.monospaced())
        Slider.captioned(
            "Fixed Content Height",
            value: $fixedHeight,
            in: 0...800,
            currentValueFormat: .fractionLength(2),
            boundsValueFormat: .arithmeticRoundedInteger)

        CaptionRectangle(
            "Fixed Content", color: .red,
            width: 150, height: fixedHeight,
            traits: .height)
    }

    if !useDeviceSafeArea {
        SafeAreaPad(edge: .bottom, showDivider: true)
    }
}
