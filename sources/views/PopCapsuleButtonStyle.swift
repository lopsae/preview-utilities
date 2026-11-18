//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Configures the round toggle button to animate its background.
struct PopCapsuleButtonStyle: ButtonStyle {
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


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing) {
    @Previewable @State var colorToggle = true
    Group {
        Button("Pop Capsule") {}
        .buttonStyle(PopCapsuleButtonStyle(isOn: colorToggle, playback: .normal))

        let capsuleStyle: AnyShapeStyle = .if(colorToggle, then: .orange, else: .teal)
        Button("Uniform Size") {
            colorToggle.toggle()
        } icon: {
            UniformSizeSymbol(systemName: "popcorn")
        }
        .buttonStyle(PopCapsuleButtonStyle(isOn: colorToggle, playback: .normal))

        Button("Uniform Size") {
            colorToggle.toggle()
        } icon: {
            UniformSizeSymbol(systemName: "popcorn")
        }
        .buttonStyle(PopCapsuleButtonStyle(isOn: colorToggle, playback: .slow))

        Button("Icon Only", action: {}, icon: UniformSizeSymbol(systemName: "party.popper"))
            .buttonStyle(PopCapsuleButtonStyle(isOn: colorToggle, playback: .normal))
        .labelStyle(.iconOnly)
    }
    .foregroundStyle(.background)

}

