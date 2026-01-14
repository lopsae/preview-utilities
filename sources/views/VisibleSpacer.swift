//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct VisibleSpacer: View {

    var body: some View {
        Text("Spacer")
        .foregroundStyle(.tertiary)
        .font(.caption)
        .padding(.horizontal, 8)
        .frame(minHeight: 0, maxHeight: .infinity, alignment: .center)
        .background(.gray.quaternary)
    }

}


// MARK: - Previews


@MainActor
private struct PreviewContent {

    static let layout: PreviewTrait<Preview.ViewTraits> = .iPhoneProSizeLayout

}


#Preview("Default", traits: .headerFooter(.showDividers), PreviewContent.layout) {
    VisibleSpacer()
}


#Preview("Sizing", traits: .zeroSpacing, .headerFooter(.showDividers), PreviewContent.layout) {
    @Previewable @State var fixedHeight: Double = 100

    Slider.captioned(
        "Fixed Content Height",
        value: $fixedHeight,
        in: 0...500,
        currentValueFormat: .fractionLength(2),
        boundsValueFormat: .arithmeticRoundedInteger)
    .padding()

    Rectangle()
        .fill(.mint.tertiary)
        .frame(width: 150, height: fixedHeight)
        .floatingCaption("Fixed Content", .border, .height)

    VisibleSpacer()
}

