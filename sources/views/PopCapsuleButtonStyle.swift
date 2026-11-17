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
