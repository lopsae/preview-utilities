//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI

/// A toggle style that displays a leading round button along a label.
///
/// This style is composable with `LabelStyle`, stack it with other label styles to compose its
/// effects.
struct RoundCheckmarkToggleStyle: ToggleStyle {

    // TODO: Support disabled state.
    private let playback: AnimationPlayback

    init(playback: AnimationPlayback = .normal) {
        self.playback = playback
    }

    func makeBody(configuration: Configuration) -> some View {
        let symbolToggle = SymbolToggle(
            toggle: configuration.isOn,
            firstStyle: .white,
            secondStyle: .secondary,
            animations: playback
        )

        let capsuleStyle: AnyShapeStyle = .if(configuration.isOn, then: .tint, else: .gray.secondary)
        let pressedScale: CGFloat = playback.isDisabled ? .one : PopCapsuleIconButtonStyle.defaultPressedScale
        let buttonStyle = PopCapsuleIconButtonStyle(
            style: capsuleStyle,
            pressedScale: pressedScale,
            animations: playback
        )

        Button(
            action: { configuration.isOn.toggle() },
            title: configuration.label,
            icon: symbolToggle
        )
        .buttonStyle(buttonStyle)
    }
}


// MARK: - ToggleStyle Extension


extension ToggleStyle where Self == RoundCheckmarkToggleStyle {

    static var roundCheckmark: Self { .init() }

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter) {
    @Previewable @State var toggleValues: [
        (title: LocalizedStringKey, isOn: Bool, playback: AnimationPlayback)
    ] = [
        ("First Toggle",  true,  .normal),
        ("Second Toggle", false, .normal),
        ("Slow Toggle",   true,  .slow),
        ("No Animations", true,  .disabled)
    ]

    VStack($toggleValues.indexed(), id: \.index, alignment: .leading) { index, $values in
        Toggle(values.title, isOn: $values.isOn)
        .toggleStyle(RoundCheckmarkToggleStyle(playback: values.playback))
    }
    .expandingWidthFrame(alignment: .leading)
}


// MARK: Styles
#Preview("Styles", traits: .headerFooter) {
    @Previewable @State var toggle = true

    Toggle("Toggle", isOn: $toggle)

    Toggle("Round", isOn: $toggle)
    .toggleStyle(.roundCheckmark)

    Toggle("Round", isOn: $toggle)
    .toggleStyle(.roundCheckmark)
    .labelStyle(.iconOnly)
}


// MARK: Comparison
#Preview("Comparison", traits: .headerFooter) {
    @Previewable @State var toggle = false

    PreviewCaption("""
        Default sizing from `PopCapsuleIconButton` is used, which matches the height of the default 
        toggle.
        """)

    let comparisonView = VStack(spacing: .zero) {
        DashedDivider()

        HStack {
            Toggle("Comparison", isOn: $toggle)
            .toggleStyle(.roundCheckmark)
            .labelStyle(.iconOnly)

            Toggle("Toggle", isOn: $toggle)
            .toggleStyle(.onlySwitch)
        }
        .debugAlignmentGuide(vertical: .top, .extendedLength(20))
        .debugAlignmentGuide(vertical: .bottom, .extendedLength(20))
        .padding(.vertical, 5)

        DashedDivider()
    }

    comparisonView

    comparisonView
    .scaledLayout(3)
}
