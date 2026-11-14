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

            SymbolToggleButton(
                "Toggle", toggle: $isOn,
                firstStyle: .background, secondStyle: .secondary,
                animations: playback
            )
            .labelStyle(.iconOnly)
            .buttonStyle(AnimatedPressedButtonStyle(isOn: isOn, playback: playback))

        }
    }

    // FIXME: Move to its own file.
    // FIXME: Rename to PopCapsuleButtonStyle.
    /// Configures the round toggle button to animate its background.
    struct AnimatedPressedButtonStyle: ButtonStyle {
        let isOn: Bool
        let playback: AnimationPlayback

        func makeBody(configuration: Configuration) -> some View {
            let isPressed = configuration.isPressed
            let colorAnimation: Animation? = .default.speed(2).playback(playback)
            let scaleAnimation: Animation? = .bouncy(duration: 0.25, extraBounce: 0.3).playback(playback)

            let backgroundStyle: AnyShapeStyle = .if(isOn, then: .tint, else: .gray.secondary)

            // When animations are disabled, scale is also disabled.
            let pressedScale: CGFloat = playback.isDisabled ? .one : 1.5

            configuration.label
            .padding(4)
            .background {
                Capsule()
                .fill(backgroundStyle)
                .brightness(isPressed ? 0.2 : .zero)
            }
            .animation(colorAnimation, value: Hasher.combining(isOn, isPressed))
            .scaleEffect(configuration.isPressed ? pressedScale : 1.0, anchor: .center)
            .animation(scaleAnimation, value: isPressed)
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


// FIXME: Move to additions.
extension ShapeStyle where Self == AnyShapeStyle {
    static func `if`(
        _ condition: Bool,
        then trueStyle: some ShapeStyle,
        else falseStyle: some ShapeStyle
    ) -> Self {
        condition ? Self(trueStyle) : Self(falseStyle)
    }
}


// FIXME: Move to its own file.
// MARK: - SymbolToggleButton

struct SymbolToggleButton<FirstStyle, SecondStyle>: View
where FirstStyle: ShapeStyle, SecondStyle: ShapeStyle
{

    @Binding private var toggle: Bool

    private let titleKey: LocalizedStringKey
    private let firstStyle: FirstStyle
    private let secondStyle: SecondStyle
    private let playback: AnimationPlayback

    init(
        _ titleKey: LocalizedStringKey,
        toggle: Binding<Bool>,
        firstStyle: FirstStyle = .primary,
        secondStyle: SecondStyle = .primary,
        animations playback: AnimationPlayback = .normal
    ) {
        self.titleKey = titleKey
        self._toggle = toggle
        self.firstStyle = firstStyle
        self.secondStyle = secondStyle
        self.playback = playback
    }

    var body: some View {
        // TODO: Review how accessibility would work for this control, since the control has a title, and this
        // button  also has a title. Compare with the stock Toggle.
        Button("Toggle") {
            toggle.toggle()
        } icon: {
            ZStack {
                // FIXME: With BaselinedImageView with an empty overlay.
                // This view keeps stable the size of the button while transition are playing.
                Image(systemName: "circle")
                .hidden()

                // The ZStacks are required for the dismiss animation to perform properly.

                // Checkmark is animated with a scale+opacity fast animation.
                let checkmarkTransition: AnyTransition = .asymmetric(
                    insertion: .scale(scale: 2),
                    removal:   .scale(scale: 0.5)
                ).combined(with: .opacity)
                let checkmarkAnimation: Animation? = .default.speed(3)
                    .playback(playback)

                // Xmark is fades in with a slight delay, and fades out with scale.
                let xmarkTransition: AnyTransition = .asymmetric(
                    insertion: .identity,
                    removal:   .scale(scale: 0.5)
                ).combined(with: .opacity)
                let xmarkAnimation: Animation? = .default.speed(2).delay(toggle ? 0 : 0.1)
                    .playback(playback)

                ZStack {
                    if toggle {
                        UniformSizeSymbol(systemName: "checkmark")
                        .foregroundStyle(firstStyle)
                        .transition(checkmarkTransition)
                    }
                }.animation(checkmarkAnimation, value: toggle)


                ZStack {
                    if !toggle {
                        UniformSizeSymbol(systemName: "xmark")
                        .foregroundStyle(secondStyle)
                        .transition(xmarkTransition)
                    }
                }.animation(xmarkAnimation, value: toggle)
            }
        }
    }

}

#Preview("SymbolToggleButton") {
    @Previewable @State var toggle = true

    SymbolToggleButton("Default", toggle: $toggle)
    SymbolToggleButton("Styled", toggle: $toggle, firstStyle: .red, secondStyle: .secondary)
}

struct RoundToggleButtonStyle: ButtonStyle {

    func makeBody(configuration: Configuration) -> some View {

    }

}
