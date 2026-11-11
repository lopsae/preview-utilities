//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Toggle control with a label and a round toggle button.
struct RoundToggle: View {

    @Binding private var isOn: Bool

    private let titleKey: LocalizedStringKey
    private let speedFactor: CGFloat

    // FIXME: Possible animation modifier parameter: nil for no modification, .speed(0.4) to slow down, .none to remove all animations.
    init(_ titleKey: LocalizedStringKey, isOn: Binding<Bool>, speedFactor: CGFloat = .one) {
        self.titleKey = titleKey
        self._isOn = isOn
        self.speedFactor = speedFactor
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
                    Image(systemName: "circle")
                        .hidden()

                    // The ZStacks are required for the dismiss animation to perform properly.

                    // Checkmark is animated with a scale+opacity fast animation.
                    ZStack {
                        if isOn {
                            BaselinedImageView(systemName: "checkmark")
                            .transition(.asymmetric(
                                insertion: .scale(scale: 2),
                                removal: .scale(scale: 0.5)
                            ).combined(with: .opacity))
                        }
                    }.animation(.default.speed(3).speed(speedFactor), value: isOn)

                    // Xmark is fades in with a slight delay, and fades out +scale.
                    ZStack {
                        if !isOn {
                            BaselinedImageView(systemName: "xmark")
                            .transition(.asymmetric(
                                insertion: .opacity,
                                removal: .scale(scale: 0.5).combined(with: .opacity)
                            ))
                        }
                    }.animation(.default.speed(2).delay(isOn ? 0 : 0.1).speed(speedFactor), value: isOn)
                }
            }
            .buttonStyle(AnimatedPressedButtonStyle(isOn: isOn, speedFactor: speedFactor))

        }
    }

    /// Configures the round toggle button to animate its background.
    struct AnimatedPressedButtonStyle: ButtonStyle {
        let isOn: Bool
        let speedFactor: CGFloat

        func makeBody(configuration: Configuration) -> some View {
            let foregroundStyle: AnyShapeStyle = isOn ? AnyShapeStyle(.background) : AnyShapeStyle(.primary.secondary)
            let backgroundStyle: AnyShapeStyle = isOn ? AnyShapeStyle(.tint) : AnyShapeStyle(.gray.secondary)
            configuration.label
            .labelStyle(.iconOnly)
            // FIXME: Should foreground be applied to each mark view?
            .foregroundStyle(foregroundStyle)
            .padding(4)
            .background(backgroundStyle, in: .capsule)
            // Animation for background color.
            .animation(.default.speed(2).speed(speedFactor), value: isOn)
            .scaleEffect(configuration.isPressed ? 1.4 : 1.0, anchor: .center)
            // Animation for scale effect.
            .animation(.bouncy(duration: 0.3, extraBounce: 0.4).speed(speedFactor), value: configuration.isPressed)
        }

    }

}


#Preview("Default", traits: .fixedHeader) {
    @Previewable @State var toggleValues: [(isOn: Bool, speed: CGFloat)] = [
        (true, .one),
        (false, .one),
        (true, 0.2)
    ]
    VStack($toggleValues.indexed(), id: \.index) { index, $toggleValue in
        RoundToggle("Toggle \(index)", isOn: $toggleValue.isOn, speedFactor: toggleValue.speed)
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
