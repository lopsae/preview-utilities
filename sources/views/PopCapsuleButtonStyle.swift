//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Configures the round toggle button to animate its background.
struct PopCapsuleButtonStyle: ButtonStyle {

    static let defaultPressedScale: CGFloat = 1.5

    let capsuleStyle: AnyShapeStyle
//    let padding:
    let pressedScale: CGFloat
    let playback: AnimationPlayback

    init(
        capsuleStyle: some ShapeStyle,
        pressedScale: CGFloat = defaultPressedScale,
        animations playback: AnimationPlayback
    ) {
        self.capsuleStyle = AnyShapeStyle(capsuleStyle)
        self.pressedScale = pressedScale
        self.playback = playback
    }

    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed

        let capsuleBrightness = isPressed ? 0.15 : .zero

        // When animations are disabled, scale is also disabled.
        let targetScale: CGFloat = playback.isDisabled ? .one : pressedScale
        let scale = isPressed ? targetScale : .one

        let colorAnimation: Animation? = .default.speed(2).playback(playback)
        let scaleAnimation: Animation? = .bouncy(duration: 0.25, extraBounce: 0.3).playback(playback)

        configuration.label
        // FIXME: Also make padding a parameter.
        .padding(4)
        .animation(colorAnimation) { content in
            content.background {
                Capsule()
                .fill(capsuleStyle)
                .brightness(capsuleBrightness)
            }
        }
        .scaleEffect(scale, anchor: .center)
        .animation(scaleAnimation, value: isPressed)
    }

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter) {
    @Previewable @State var colorToggle = true
    VStack.expandingWidth(alignment: .leading, spacing: SpacingDefaults.padding) {
        Button("Pop Capsule") {}
            .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: .tint, animations: .normal))

        let capsuleStyle: AnyShapeStyle = .if(colorToggle, then: .orange, else: .teal)
        Button("Uniform Size") {
            colorToggle.toggle()
        } icon: {
            UniformSizeSymbol(systemName: "popcorn")
        }
        .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: capsuleStyle, animations: .normal))

        Button("Uniform Size - Slow") {
            colorToggle.toggle()
        } icon: {
            UniformSizeSymbol(systemName: "popcorn")
        }
        .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: capsuleStyle, animations: .slow))

        Button("Uniform Size - None") {
            colorToggle.toggle()
        } icon: {
            UniformSizeSymbol(systemName: "popcorn")
        }
        .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: capsuleStyle, animations: .disabled))

        Button("Icon Only", action: {}, icon: UniformSizeSymbol(systemName: "party.popper"))
            .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: .purple, animations: .normal))
        .labelStyle(.iconOnly)
    }
    .foregroundStyle(.background)

}

