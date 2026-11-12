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

            Button("Toggle") {
                isOn.toggle()
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
                    let xmarkAnimation: Animation? = .default.speed(2).delay(isOn ? 0 : 0.1)
                        .playback(playback)

                    ZStack {
                        if isOn {
                            BaselinedImageView(systemName: "checkmark")
                            .foregroundStyle(.background)
                            .transition(checkmarkTransition)
                        }
                    }.animation(checkmarkAnimation, value: isOn)


                    ZStack {
                        if !isOn {
                            BaselinedImageView(systemName: "xmark")
                            .foregroundStyle(.secondary)
                            .transition(xmarkTransition)
                        }
                    }.animation(xmarkAnimation, value: isOn)
                }
            }
            .buttonStyle(AnimatedPressedButtonStyle(isOn: isOn, playback: playback))

        }
    }

    /// Configures the round toggle button to animate its background.
    struct AnimatedPressedButtonStyle: ButtonStyle {
        let isOn: Bool
        let playback: AnimationPlayback

        func makeBody(configuration: Configuration) -> some View {
            let isPressed = configuration.isPressed
            let colorAnimation: Animation? = .default.speed(2).playback(playback)
            let scaleAnimation: Animation? = .bouncy(duration: 0.3, extraBounce: 0.4).playback(playback)

//            let backgroundStyle: AnyShapeStyle = isOn ? AnyShapeStyle(.tint) : AnyShapeStyle(.gray.secondary)
            let backgroundStyle: AnyShapeStyle = .if(isOn, then: .tint, else: .gray.secondary)

            // When animations are disabled, scale is also disabled.
            let pressedScale: CGFloat = playback.isDisabled ? .one : 1.4

            configuration.label
            .labelStyle(.iconOnly)
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


// MARK: - AnimationModifier.


enum AnimationPlayback {
    case normal
    case scaled(CGFloat)
    case disabled

    var isDisabled: Bool {
        switch self {
        case .normal:   false
        case .scaled:   false
        case .disabled: true
        }
    }

    static let slow: Self = .scaled(0.2)
}


extension Animation {

    func playback(_ playback: AnimationPlayback) -> Self? {
        switch playback {
        case .normal:            self
        case .scaled(let speed): self.speed(speed)
        case .disabled:          nil
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
extension AnyShapeStyle {
    static func `if`(
        _ condition: Bool,
        then trueStyle: some ShapeStyle,
        else falseStyle: some ShapeStyle
    ) -> Self {
        condition ? Self(trueStyle) : Self(falseStyle)
    }
}


// FIXME: Move to its own file.
// FIXME: Rename:  UniformSymbol, SquareSymbol, FixedFootprintImage. FixedSizeImage
// TODO: Based/Brough from Trailing{Closure}, consider exposing or moving to its own package.
// TODO: Check what happens to the accessibility label of a label with this style.

/// Image framed to a square view size, irregardless of the image size.
private struct BaselinedImageView: View {

    private let image: Image

    init(systemName: String) {
        self.image = Image(systemName: systemName)
    }

    var body: some View {
        Image(systemName: "circle")
        .hidden()
        .overlay(alignment: .centerFirstTextBaseline) {
            image
        }
        .contentShape(.circle)
    }

}


#Preview("BaselinedImageView", traits: .paddingSpacing) {
    let imageNames = [
        "ladybug",
        "guidepoint.horizontal",
        "guidepoint.vertical",
        "minus",
        "photo.badge.shield.exclamationmark",
        "clock.badge.airplane"
    ]

    ForEach(imageNames, id: \.self) { imageName in
        BaselinedImageView(systemName: imageName)
        .floatingCaption(alignment: .outerTrailingTop, .colorStyle(.cyan), .size)
    }

    HStack(imageNames, id: \.self, spacing: 8) { imageName in
        BaselinedImageView(systemName: imageName)
    }
    .debugAlignmentGuide(vertical: .firstTextBaseline)

}
