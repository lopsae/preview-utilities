//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


public struct VisibleSpacer: View {

    let axis: Axis


    public init(axis: Axis = .vertical) {
        self.axis = axis
    }


    public var body: some View {
        let minWidth:  CGFloat?, maxWidth:  CGFloat?
        let minHeight: CGFloat?, maxHeight: CGFloat?
        let paddingEdges: Edge.Set
        switch axis {
        case .horizontal:
            minWidth = .zero
            maxWidth = .infinity
            minHeight = nil
            maxHeight = nil
            paddingEdges = .vertical
        case .vertical:
            minHeight = .zero
            maxHeight = .infinity
            minWidth = nil
            maxWidth = nil
            paddingEdges = .horizontal
        }

        return Text("Spacer")
            .foregroundStyle(.tertiary)
            .font(.caption)
            .fixedSize()
            .padding(paddingEdges, Defaults.padding / 2)
            .frame(
                minWidth: minWidth,
                maxWidth: maxWidth,
                minHeight: minHeight,
                maxHeight: maxHeight,
                alignment: .center)
            .background(
                .gray.quaternary,
                in: RoundedRectangle(cornerRadius: Defaults.padding / 4))
    }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeForcedLayout

}


#Preview("Default", traits: .headerFooter(.showDividers), PreviewContent.layout) {
    VisibleSpacer()
    DashedDivider()
    VisibleSpacer(axis: .horizontal)
    DashedDivider()
    VisibleSpacer(axis: .vertical)
}


#Preview("Vertical", traits: .zeroSpacing, .headerFooter(.showDividers), PreviewContent.layout) {
    @Previewable @State var fixedHeight: Double = 100

    Slider.captioned(
        "Fixed Content Height",
        value: $fixedHeight,
        in: 0...500,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)
    .padding()

    CaptionRectangle(
        "Fixed Content", fill: .mint.gradient.tertiary,
        width: 150, height: fixedHeight,
        traits: .height)

    VisibleSpacer()
}


#Preview("Horizontal", traits: .zeroSpacing, .headerFooter(.showDividers), PreviewContent.layout) {
    @Previewable @State var fixedWidth: Double = 100

    Slider.captioned(
        "Fixed Content Width",
        value: $fixedWidth,
        in: 0...500,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)
    .padding()

    HStack(spacing: 0) {
        Rectangle()
            .fill(.mint.tertiary)
            .frame(width: fixedWidth, height: 150)
            .floatingCaption("Fixed Content", .border, .width)
        VisibleSpacer(axis: .horizontal)
    }
    .padding(.horizontal)
}

