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

    private let playback: AnimationPlayback

    init(playback: AnimationPlayback = .normal) {
        self.playback = playback
    }

    func makeBody(configuration: Configuration) -> some View {
        let backgroundStyle: AnyShapeStyle = .if(configuration.isOn, then: .tint, else: .gray.secondary)
        let buttonStyle = PopCapsuleButtonStyle(
            capsuleStyle: backgroundStyle,
            animations: playback
        )


        Label {
            configuration.label
        } icon: {
            SymbolToggleButton(
                "Toggle", toggle: configuration.$isOn,
                firstStyle: .background, secondStyle: .secondary,
                animations: playback
            )
            .labelStyle(.iconOnly)
            .buttonStyle(buttonStyle)
        }
    }

}


// MARK: - ToggleStyle Extension


extension ToggleStyle where Self == RoundCheckmarkToggleStyle {

    static var roundCheckmark: Self { .init() }

}


// MARK: - OnlyToggle


/// A toggle style that displays only the switch.
///
/// This style uses fixed sizes to force the switch in place, different devices or operating systems
/// may show incorrectly framed switches.
struct OnlySwitchToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Toggle(isOn: configuration.$isOn) {
            EmptyView()
        }
        // TODO: Should the label be added as accessibility element?
        .toggleStyle(.switch)
        .frame(width: 59, alignment: .trailing)
    }
}


extension ToggleStyle where Self == OnlySwitchToggleStyle {
    static var onlySwitch: Self { .init() }
}


// MARK: - Previews


#Preview("Default", traits: .fixedHeader) {
    @Previewable @State var comparisonValue = false
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

//        RoundToggle(values.title, isOn: $values.isOn, animations: values.playback)
    }
    .expandingWidthFrame(alignment: .leading)

    DashedDivider()

    HStack {
        Text("Comparison")
        Spacer()
        Toggle("Comparison", isOn: $comparisonValue)
        .toggleStyle(.roundCheckmark)
        .labelStyle(.iconOnly)

        Toggle(isOn: $comparisonValue) { EmptyView() }
        .frame(width: 80)
        .debugAlignmentGuide(vertical: .top, .extendedLength(50), .anchor(.trailing))
        .debugAlignmentGuide(vertical: .bottom, .extendedLength(50), .anchor(.trailing))
    }

    DashedDivider()

    Text("Standalone")
    Toggle(isOn: $comparisonValue) { EmptyView() }
    .frame(width: 59, alignment: .trailing)
    .border(.orange.secondary, width: 3)
    .expandingWidthFrame(alignment: .leading)
}


// FIXME: Keep and replace RoundToggle.
// FIXME: Create convenience static accessor.


#Preview("RoundCheckmarkToggleStyle", traits: .headerFooter) {
    @Previewable @State var toggle = true

    Toggle("Toggle", isOn: $toggle)

    Toggle("Round", isOn: $toggle)
    .toggleStyle(.roundCheckmark)

    Toggle("Round", isOn: $toggle)
    .toggleStyle(.roundCheckmark)
    .labelStyle(.iconOnly)

}


// MARK: Standalone
#Preview("Standalone", traits: .headerFooter) {
    @Previewable @State var toggleTrue = true
    @Previewable @State var toggleFalse = false

    HStack {
        Toggle("Labeled", isOn: $toggleTrue)
        .toggleStyle(.onlySwitch)
        Text("Labeled")
    }
    .expandingWidthFrame(alignment: .leading)

    HStack {
        Toggle("Extra Style", isOn: $toggleFalse)
        .toggleStyle(.onlySwitch)
        // This external style does not apply, because `onlySwitch` forces it to switch.
        // FUTURE: roundCheckmark could display only the button, and an additional `labeled` style
        // could wrap it in a label.
        .toggleStyle(.button)
        Text("Extra Style")
    }
    .expandingWidthFrame(alignment: .leading)

    DashedDivider()

    HStack {
        Toggle("True", isOn: $toggleTrue)
            .border(.orange.secondary, width: 3)
        Toggle("False", isOn: $toggleFalse)
            .border(.orange.secondary, width: 3)
    }
    .toggleStyle(.onlySwitch)
    .scaleEffect(2.5)
    .padding(.vertical, 20)
}
