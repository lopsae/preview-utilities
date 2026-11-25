//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// A button style that applies an animated capsule background and scale effect to the button icon.
///
/// The style applies the ``UniformSizeSymbolLabelStyle`` and the ``PopCapsuleIconLabelStyle`` to
/// the button label to animate the capsule background and scale when the button is pressed.
///
/// Use the `playback` property to modify or disable animations.
///
/// ### Style Composition
///
/// This style builds on top of the button default label and is composable with other label styles.
/// Stack it with other label styles compose its effects.
///
/// For example, compose with `LabelStyle.iconOnly` to only display the button icon.
struct PopCapsuleIconButtonStyle: ButtonStyle {

    // The default paddings are set to reproduce the size of a toggle, when used with a uniform
    // symbol size.
    static let defaultPaddings: EdgeInsets = .all(4)
    static let defaultPressedPaddings: EdgeInsets = .zero
    static let defaultPressedScale: CGFloat = 1.45

    let style: AnyShapeStyle
    let paddings: EdgeInsets
    let pressedPaddings: EdgeInsets
    let pressedScale: CGFloat
    let playback: AnimationPlayback

    init(
        style: some ShapeStyle,
        paddings:        EdgeInsets = defaultPaddings,
        pressedPaddings: EdgeInsets = defaultPressedPaddings,
        pressedScale:    CGFloat    = defaultPressedScale,
        animations playback: AnimationPlayback = .normal
    ) {
        self.style = AnyShapeStyle(style)
        self.paddings        = paddings
        self.pressedPaddings = pressedPaddings
        self.pressedScale    = pressedScale
        self.playback        = playback
    }

    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed

        let brightness: CGFloat     = isPressed ? 0.15 : .zero
        let popPaddings: EdgeInsets = isPressed ? pressedPaddings : .zero
        let popScale: CGFloat       = isPressed ? pressedScale : .one

        let labelStyle = PopCapsuleIconLabelStyle(
            style: style,
            brightness: brightness,
            paddings: paddings,
            popPaddings: popPaddings,
            popScale: popScale,
            animations: playback
        )
        configuration.label
        .labelStyle(.uniformIcon)
        .labelStyle(labelStyle)
    }

}


// MARK: - Previews


#Preview("Default") {

    Button("Default", systemImage: "popcorn") { }
    .buttonStyle(PopCapsuleIconButtonStyle(style: .orange))

    Button("Icon Only", systemImage: "popcorn") { }
    .buttonStyle(PopCapsuleIconButtonStyle(style: .pink))
    .labelStyle(.iconOnly)
}


// MARK: Comparison
#Preview("Comparison", traits: .paddingSpacing, .headerFooter) {
    @Previewable @State var toggle = false

    PreviewCaption("The default configuration matches the height of the default toggle.")

    let comparisonView = VStack(spacing: .zero) {
        DashedDivider()

        HStack {
            Button("Pop Capsule", systemImage: "checkmark") { }
            .buttonStyle(PopCapsuleIconButtonStyle(style: .green))
            .labelStyle(.iconOnly)

            Toggle("Toggle", isOn: $toggle)
            .toggleStyle(.onlySwitch)
        }
        .debugAlignmentGuide(vertical: .top, .extendedLength(20))
        .debugAlignmentGuide(vertical: .bottom, .extendedLength(20))
        .padding(.vertical, 5)

        DashedDivider()
    }

    comparisonView

    comparisonView
    .scaledLayout(3)

    Button("Pop Capsule", systemImage: "checkmark") { }
    .buttonStyle(PopCapsuleIconButtonStyle(style: .green))
    .labelStyle(.iconOnly)
    .floatingCaption(alignment: .outerTrailing, .padding(8), .height)

    Toggle("Toggle", isOn: $toggle)
    .toggleStyle(.onlySwitch)
    .floatingCaption(alignment: .outerTrailing, .padding(8), .height)
}


// MARK: Pops
#Preview("Pops", traits: .spacing(20)) {
    @Previewable @State var styleToggle = true

    let style: AnyShapeStyle = .if(styleToggle, then: .tint, else: .gray.secondary)

    let padStyle = PopCapsuleIconButtonStyle(
        style: style,
        pressedPaddings: .all(8),
        pressedScale: .one
    )
    Button("Paddings", systemImage: "popcorn") { styleToggle.toggle() }
    .buttonStyle(padStyle)

    let scaleStyle = PopCapsuleIconButtonStyle(
        style: style,
        pressedPaddings: .zero,
        pressedScale: 2
    )
    Button("Scale", systemImage: "popcorn") { styleToggle.toggle() }
    .buttonStyle(scaleStyle)
}


// MARK: Playback
#Preview("Playback") {
    @Previewable @State var styleToggle = true

    let style: AnyShapeStyle = .if(styleToggle, then: .tint, else: .gray.secondary)

    VStack(items: AnimationPlayback.fixedCases, alignment: .leading, spacing: 16) { playback in
        let buttonStyle = PopCapsuleIconButtonStyle(
            style: style,
            animations: playback
        )

        Button(playback.displayName.capitalized, systemImage: "popcorn") { styleToggle.toggle() }
        .buttonStyle(buttonStyle)
    }
    .scaledLayout(2)
}
