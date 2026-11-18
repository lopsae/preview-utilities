//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Toggle control with a label and a round toggle button.
struct RoundToggle: View {

    @Binding private var isOn: Bool

    private let titleKey: LocalizedStringKey
    private let playback: AnimationPlayback

    init(
        _ titleKey: LocalizedStringKey,
        isOn: Binding<Bool>,
        animations playback: AnimationPlayback = .normal
    ) {
        self.titleKey = titleKey
        self._isOn = isOn
        self.playback = playback
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(titleKey)
            Spacer()

            let backgroundStyle: AnyShapeStyle = .if(isOn, then: .tint, else: .gray.secondary)
            SymbolToggleButton(
                "Toggle", toggle: $isOn,
                firstStyle: .background, secondStyle: .secondary,
                animations: playback
            )
            .labelStyle(.iconOnly)
            .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: backgroundStyle, animations: playback))

        }
    }

}


// MARK: - Previews


#Preview("Default", traits: .fixedHeader) {
    @Previewable @State var comparisonValue = true
    @Previewable @State var toggleValues: [
        (title: LocalizedStringKey, isOn: Bool, playback: AnimationPlayback)
    ] = [
        ("First Toggle",  true,  .normal),
        ("Second Toggle", false, .normal),
        ("Slow Toggle",   true,  .slow),
        ("No Animations", true,  .disabled)
    ]

    VStack($toggleValues.indexed(), id: \.index) { index, $values in
        RoundToggle(values.title, isOn: $values.isOn, animations: values.playback)
    }

    DashedDivider()
    HStack {
        RoundToggle("Comparison", isOn: $comparisonValue)
        Toggle(isOn: $comparisonValue) { EmptyView() }
        .frame(width: 80)
        .debugAlignmentGuide(vertical: .top, .extendedLength(50), .anchor(.trailing))
        .debugAlignmentGuide(vertical: .bottom, .extendedLength(50), .anchor(.trailing))
    }
}
