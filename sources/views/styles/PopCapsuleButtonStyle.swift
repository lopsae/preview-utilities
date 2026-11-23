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


// MARK: - PopCapsuleBackup


// FIXME: Likely move to its own file.


enum PopCapsuleDefaults {
    // These defaults configure an icon-only button to pop and scale similar to the toggle button.
    static let paddings: EdgeInsets = .all(4)
    static let popPaddings: EdgeInsets = .zero
    static let popScale: CGFloat = 1.4
}


// FIXME: Delete if PopCapsule is sufficient.
/// Applies to the given content a capsule background and a scale effect.
///
/// The capsule effect has two states controlled through the `pop` parameter. When popping changes,
/// the scale and paddings are animated with a bouncy animation.
///
/// The style of capsule background is animated anytime the style changes.
///
/// The `playback` parameter can be used to modify the animations, or disable them entirely.
///
struct PopCapsuleBackup<Content>: View where Content: View {

    let pop: Bool
    let capsuleStyle: AnyShapeStyle
    let paddings: EdgeInsets
    let popPaddings: EdgeInsets
    let popScale: CGFloat
    let playback: AnimationPlayback

    let content: () -> Content

    init(
        pop: Bool,
        capsuleStyle: some ShapeStyle,
        paddings: EdgeInsets = PopCapsuleDefaults.paddings,
        popPaddings: EdgeInsets = PopCapsuleDefaults.popPaddings,
        popScale: CGFloat = PopCapsuleDefaults.popScale,
        animations playback: AnimationPlayback = .normal,
        @ContentBuilder content: @escaping () -> Content
    ) {
        self.pop = pop
        self.capsuleStyle = AnyShapeStyle(capsuleStyle)
        self.paddings = paddings
        self.popPaddings = popPaddings
        self.popScale = popScale
        self.playback = playback
        self.content = content
    }

    var body: some View {
        let capsuleBrightness = pop ? 0.15 : .zero

        let targetScale = pop ? popScale : .one
        let targetPopPaddings = pop ? popPaddings : .zero

        // Color is animated automatically when it changes. There is no way to directly track for
        // `capsuleStyle` changes.
        let colorAnimation: Animation? = .default.speed(2).playback(playback)

        // Paddings and scale are animated when each changes.
        let paddingsAndScaleAnimation: Animation? = .bouncy(duration: 0.25, extraBounce: 0.3).playback(playback)

        // Paddings on is own is expected to never change, since it changes the view layout.
        // It is explicitly NOT animated.

        content()
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
            .padding(targetPopPaddings.negative)
            .animation(paddingsAndScaleAnimation, value: targetPopPaddings)
        }
        .scaleEffect(targetScale, anchor: .center)
        .animation(paddingsAndScaleAnimation, value: targetScale)
    }

}


#Preview("PopCapsuleBackup", traits: .spacing(20)) {
    @Previewable @State var pop = false
    @Previewable @State var style = true

    Button("Default Bordered", systemImage: "circle") {}
    .buttonStyle(.borderedProminent)

    let popStyle: AnyShapeStyle = .if(style, then: .tint, else: .gray.secondary)
    PopCapsuleBackup(pop: pop, capsuleStyle: popStyle) {
        Label("PopCapsule", systemImage: "popcorn")
        .foregroundStyle(.background)
    }

    Button("Pop") {
        if pop { style.toggle() }
        pop.toggle()
    }
    Text("pop: \(pop.description)\nstyle: \(style.description)")
    .font(.caption.monospaced())
}


#Preview("Properties", traits: .spacing(20), .fixedHeaderFooter) {
    @Previewable @State var popToggle = false
    @Previewable @State var styleToggle = true
    @Previewable @State var paddingsToggle = false
    @Previewable @State var popPaddingsToggle = false
    @Previewable @State var popScaleToggle = false

    let capsuleStyle: AnyShapeStyle = .if(styleToggle, then: .tint, else: .gray.secondary)
    let paddings:    EdgeInsets = paddingsToggle    ? .all(8) : PopCapsuleDefaults.paddings
    let popPaddings: EdgeInsets = popPaddingsToggle ? .all(8) : PopCapsuleDefaults.popPaddings
    let popScale:    CGFloat    = popScaleToggle    ? 2       : PopCapsuleDefaults.popScale

    VisibleSpacer()

    VStack(items: AnimationPlayback.fixedCases, spacing: SpacingDefaults.padding) { playback in
        PopCapsuleBackup(
            pop: popToggle,
            capsuleStyle: capsuleStyle,
            paddings: paddings,
            popPaddings: popPaddings,
            popScale: popScale,
            animations: playback
        ) {
            Label("Pop Capsule", systemImage: "popcorn")
            .foregroundStyle(.white)
        }
        .expandingWidthFrame(height: 120, alignment: .center)
        .background {
            Rectangle().strokeBorder(.quinary, style: .dividerDash(width: 2))
        }
    }

    VStack {
        HStack {
            Toggle("Pop", isOn: $popToggle)
            Toggle("Style", isOn: $styleToggle)
            Toggle("Pad", isOn: $paddingsToggle)
        }
        HStack {
            Toggle("PopPad", isOn: $popPaddingsToggle)
            Toggle("PopScale", isOn: $popScaleToggle)
        }
    }
    .toggleStyle(.button)
    .buttonStyle(.bordered)
    .tint(.orange)

    Text("""
        pop:      \(popToggle.description)
        style:    \(styleToggle.description)
        pad:      \(paddingsToggle.description)
        popPad:   \(popPaddingsToggle.description)
        popScale: \(popScaleToggle.description)
        """)
    .font(.caption.monospaced())
    .fixedSize()
}
