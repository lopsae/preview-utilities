//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Configures the round toggle button to animate its background.
///
/// Style is animated when changed.
/// Paddings and scale are animated when isPressed changes.
/// Pressed paddings is applied negative to paddings, only when pressed.
struct PopCapsuleButtonStyle: ButtonStyle {

    static let defaultPressedScale: CGFloat = 1.4
    static let defaultPaddings: EdgeInsets = .all(4)
    static let defaultPressedPaddings: EdgeInsets = .zero

    let capsuleStyle: AnyShapeStyle
    let paddings: EdgeInsets
    let pressedPaddings: EdgeInsets
    let pressedScale: CGFloat
    let playback: AnimationPlayback

    init(
        capsuleStyle: some ShapeStyle,
        paddings: EdgeInsets = defaultPaddings,
        pressedPaddings: EdgeInsets = defaultPressedPaddings,
        pressedScale: CGFloat = defaultPressedScale,
        animations playback: AnimationPlayback = .normal
    ) {
        self.capsuleStyle = AnyShapeStyle(capsuleStyle)
        self.paddings = paddings
        self.pressedPaddings = pressedPaddings
        self.pressedScale = pressedScale
        self.playback = playback
    }

    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed

        let capsuleBrightness = isPressed ? 0.15 : .zero

        let targetScale = isPressed ? pressedScale : .one
        let targetPressedPaddings = isPressed ? pressedPaddings : .all(.zero)

        // Color is animated automatically when it changes. There is no way to directly track for
        // `capsuleStyle` changes.
        let colorAnimation: Animation? = .default.speed(2).playback(playback)
        // Paddings and scale are animated only when isPressed changes.
        let paddingsAndScaleAnimation: Animation? = .bouncy(duration: 0.25, extraBounce: 0.3).playback(playback)

        configuration.label
        .padding(paddings)
        .background {
            ClearRectangle()
            .animation(colorAnimation) { content in
                content.background {
                    Capsule()
                        .fill(capsuleStyle)
                        .brightness(capsuleBrightness)
                }
            }
            .padding(targetPressedPaddings.negative)
            .animation(paddingsAndScaleAnimation, value: isPressed)
        }
        .scaleEffect(targetScale, anchor: .center)
        .animation(paddingsAndScaleAnimation, value: isPressed)
    }

}


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing, .headerFooter) {
    @Previewable @State var colorToggle = true
    HStack(spacing: SpacingDefaults.padding) {
        Button("Pop Capsule") {}
        .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: .tint))

        Button("Icon Only", action: {}, icon: UniformSizeSymbol(systemName: "party.popper"))
        .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: .purple))
        .labelStyle(.iconOnly)
    }
    .foregroundStyle(.background)

    VStack(items: AnimationPlayback.fixedCases, spacing: SpacingDefaults.padding) { playback in
        let capsuleStyle: AnyShapeStyle = .if(colorToggle, then: .orange, else: .teal)
        let buttonStyle = PopCapsuleButtonStyle(capsuleStyle: capsuleStyle, animations: playback)
        Button("Uniform", systemImage: "popcorn") { colorToggle.toggle() }
        .labelStyle(.uniformIcon)
        .buttonStyle(buttonStyle)
    }
    .foregroundStyle(.background)
}


#Preview("Scale&Padding", traits: .paddingSpacing, .headerFooter) {
    @Previewable @State var colorToggle = true

    VStack(items: AnimationPlayback.fixedCases, spacing: SpacingDefaults.padding) { playback in
        let capsuleStyle: AnyShapeStyle = .if(colorToggle, then: .orange, else: .teal)
        let buttonStyle = PopCapsuleButtonStyle(
            capsuleStyle: capsuleStyle,
            paddings: .init(horizontal: 8, vertical: 4),
            pressedPaddings: .all(4),
            pressedScale: .one,
            animations: playback
        )
        Button("Only Paddings", systemImage: "popcorn") { colorToggle.toggle() }
        .labelStyle(.uniformIcon)
        .buttonStyle(buttonStyle)
    }
    .foregroundStyle(.background)

    DashedDivider()

    VStack(items: AnimationPlayback.fixedCases, spacing: SpacingDefaults.padding) { playback in
        let capsuleStyle: AnyShapeStyle = .if(colorToggle, then: .orange, else: .teal)
        let buttonStyle = PopCapsuleButtonStyle(
            capsuleStyle: capsuleStyle,
            paddings: .init(horizontal: 8, vertical: 4),
            pressedPaddings: .all(4),
            pressedScale: 1.2,
            animations: playback
        )
        Button("Paddings + Scale", systemImage: "popcorn") { colorToggle.toggle() }
        .labelStyle(.uniformIcon)
        .buttonStyle(buttonStyle)
    }
    .foregroundStyle(.background)

    DashedDivider()

    VStack(items: AnimationPlayback.fixedCases, spacing: SpacingDefaults.padding) { playback in
        let capsuleStyle: AnyShapeStyle = .if(colorToggle, then: .orange, else: .teal)
        let buttonStyle = PopCapsuleButtonStyle(
            capsuleStyle: capsuleStyle,
            paddings: .init(horizontal: 8, vertical: 4),
            pressedScale: .one,
            animations: playback
        )
        Button("No Scale", systemImage: "popcorn") { colorToggle.toggle() }
        .labelStyle(.uniformIcon)
        .buttonStyle(buttonStyle)
    }
    .foregroundStyle(.background)
}
