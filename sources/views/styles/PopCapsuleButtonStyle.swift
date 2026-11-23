//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// FIXME: Recheck docs. This style creates a button similar to .borderedProminent with a pop effect.
/// Configures the round toggle button to animate its background.
///
/// Style is animated when changed.
/// Paddings and scale are animated when isPressed changes.
/// Pressed paddings is applied negative to paddings, only when pressed.
struct PopCapsuleButtonStyle: ButtonStyle {

    // FIXME: update defaults to make this buttons resemble bordered buttons.
    // FIXME: Use this defaults for icon only style, since these are used for RoundToggle.
    static let defaultPaddings: EdgeInsets = .all(4)
    static let defaultPressedPaddings: EdgeInsets = .zero
    static let defaultPressedScale: CGFloat = 1.4

    let style: AnyShapeStyle
    let paddings: EdgeInsets
    let pressedPaddings: EdgeInsets
    let pressedScale: CGFloat
    let playback: AnimationPlayback

    init(
        style: some ShapeStyle,
        paddings: EdgeInsets = defaultPaddings,
        pressedPaddings: EdgeInsets = defaultPressedPaddings,
        pressedScale: CGFloat = defaultPressedScale,
        animations playback: AnimationPlayback = .normal
    ) {
        self.style = AnyShapeStyle(style)
        self.paddings = paddings
        self.pressedPaddings = pressedPaddings
        self.pressedScale = pressedScale
        self.playback = playback
    }

    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed

        let brightness = isPressed ? 0.15 : .zero
        let targetScale = isPressed ? pressedScale : .one
        let targetPressedPaddings = isPressed ? pressedPaddings : .zero

        PopCapsule(
            style: style,
            brightness: brightness,
            paddings: targetPressedPaddings,
            scale: targetScale,
            animations: playback
        ) {
            configuration.label
            .foregroundStyle(.white)
            .padding(paddings)
        }
    }

}


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing, .headerFooter) {
    @Previewable @State var colorToggle = true
    HStack(spacing: SpacingDefaults.padding) {
        Button("Pop Capsule") {}
        .buttonStyle(PopCapsuleButtonStyle(style: .tint))

        Button("Icon Only", action: {}, icon: UniformSizeSymbol(systemName: "party.popper"))
        .buttonStyle(PopCapsuleButtonStyle(style: .purple))
        .labelStyle(.iconOnly)
    }
    .foregroundStyle(.background)

    VStack(items: AnimationPlayback.fixedCases, spacing: SpacingDefaults.padding) { playback in
        let capsuleStyle: AnyShapeStyle = .if(colorToggle, then: .orange, else: .teal)
        let buttonStyle = PopCapsuleButtonStyle(style: capsuleStyle, animations: playback)
        Button("Uniform", systemImage: "popcorn") { colorToggle.toggle() }
        .labelStyle(.uniformIcon)
        .buttonStyle(buttonStyle)
    }
    .foregroundStyle(.background)
}


// MARK: Scale&Padding
#Preview("Scale&Padding", traits: .paddingSpacing, .headerFooter) {
    @Previewable @State var colorToggle = true

    VStack(items: AnimationPlayback.fixedCases, spacing: SpacingDefaults.padding) { playback in
        let capsuleStyle: AnyShapeStyle = .if(colorToggle, then: .orange, else: .teal)
        let buttonStyle = PopCapsuleButtonStyle(
            style: capsuleStyle,
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
            style: capsuleStyle,
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
            style: capsuleStyle,
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
