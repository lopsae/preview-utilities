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
        let capsuleBrightness = isPressed ? 0.15 : .zero
        let colorAnimation: Animation? = .default.speed(2).playback(playback)
        let scaleAnimation: Animation? = .bouncy(duration: 0.25, extraBounce: 0.3).playback(playback)

        // When animations are disabled, scale is also disabled.
        let pressedScale: CGFloat = playback.isDisabled ? .one : 1.5

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
        .scaleEffect(configuration.isPressed ? pressedScale : 1.0, anchor: .center)
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

