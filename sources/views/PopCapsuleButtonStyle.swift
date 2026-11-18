//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Configures the round toggle button to animate its background.
struct PopCapsuleButtonStyle: ButtonStyle {
    let capsuleStyle: AnyShapeStyle
    let playback: AnimationPlayback

    init(capsuleStyle: some ShapeStyle, animations playback: AnimationPlayback) {
        self.capsuleStyle = AnyShapeStyle(capsuleStyle)
        self.playback = playback
    }

    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        let colorAnimation: Animation? = .default.speed(2).playback(playback)
        let scaleAnimation: Animation? = .bouncy(duration: 0.25, extraBounce: 0.3).playback(playback)

        // When animations are disabled, scale is also disabled.
        let pressedScale: CGFloat = playback.isDisabled ? .one : 1.5

        configuration.label
        // FIXME: Also make padding a parameter.
        .padding(4)
        .background { // FIXME: is this background needed? could the background be set in animation closure?
            // Work around to animating the background color. capsuleStyle is not hashable, thus
            // cannot be checked for equality. Using foregroundColor to paint a shape does not
            // animate between styles.
            Color.clear.animation(colorAnimation, body: { content in
                content
                .background(capsuleStyle, in: .capsule)
                .brightness(isPressed ? 0.2 : .zero)
            })
        }
        // FIXME: Could this be done in animation closure?
//        .background {
//            Capsule()
//            .fill(capsuleStyle)
//            .brightness(isPressed ? 0.2 : .zero)
//        }
//        .animation(colorAnimation, value: Hasher.combining(capsuleStyle, isPressed))
        .scaleEffect(configuration.isPressed ? pressedScale : 1.0, anchor: .center)
        .animation(scaleAnimation, value: isPressed)
    }

}


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing) {
    @Previewable @State var colorToggle = true
    Group {
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

