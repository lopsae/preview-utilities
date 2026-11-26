//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// A button style that applies an animated capsule background and scale effect to the button label.
///
/// The style wraps the button label in a configured ``PopCapsule`` to animate the capsule
/// background and scale when the button is pressed.
///
/// Use the `playback` property to modify or disable animations.
///
/// ### Style Composition
///
/// This style builds on top of the button default label and is composable with other label styles.
/// Stack it with other label styles compose its effects.
///
/// For example, compose with ``SwiftUI/LabelStyle/uniformIcon`` to use a uniform symbol size, and
/// with `LabelStyle.iconOnly` to only display the button icon.
struct PopCapsuleButtonStyle: ButtonStyle {

    // The default paddings are set to reproduce the size of a bordered button.
    static let defaultPaddings: EdgeInsets = .init(horizontal: 12, vertical: 7)
    static let defaultPressedPaddings: EdgeInsets = .zero
    static let defaultPressedScale: CGFloat = 1.1

    let style: AnyShapeStyle
    let paddings: EdgeInsets
    let pressedPaddings: EdgeInsets
    let pressedScale: CGFloat
    let playback: AnimationPlayback

    init(
        style: some ShapeStyle = .tint,
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


// MARK: - ButtonStyle Extension


extension ButtonStyle where Self == PopCapsuleButtonStyle {

    static var popCapsule: Self { .init() }

}


// MARK: - Previews


#Preview("Default", traits: .paddingSpacing, .headerFooter) {
    @Previewable @State var colorToggle = true
    HStack(spacing: SpacingDefaults.padding) {
        Button("Pop Capsule") {}
        .buttonStyle(.popCapsule)

        Button("Icon Only", systemImage: "party.popper") { }
        .buttonStyle(.popCapsule)
        .labelStyle(.iconOnly)
        .tint(.purple)

        Button("Uniform Icon Only", systemImage: "party.popper") { }
        .buttonStyle(PopCapsuleButtonStyle(style: .indigo))
        .labelStyle(.uniformIcon)
        .labelStyle(.iconOnly)
    }

    DashedDivider()

    VStack(items: AnimationPlayback.fixedCases, spacing: SpacingDefaults.padding) { playback in
        let capsuleStyle: AnyShapeStyle = .if(colorToggle, then: .orange, else: .gray)
        let buttonStyle = PopCapsuleButtonStyle(style: capsuleStyle, animations: playback)
        Button("Uniform", systemImage: "popcorn") { colorToggle.toggle() }
        .buttonStyle(buttonStyle)
        .labelStyle(.uniformIcon)
        .tint(.orange)
    }
}


// MARK: Comparison
#Preview("Comparison", traits: .paddingSpacing, .headerFooter) {
    PreviewCaption("The default configuration matches the size of the bordered button.")

    Button("Comparison", systemImage: "circle") { }
    .buttonStyle(.borderedProminent)
    .floatingCaption("Bordered Prominent", alignment: .outerBottomTrailing, .size)
    .padding(.bottom, 40)

    Button("Comparison", systemImage: "circle") { }
    .buttonStyle(.popCapsule)
    .labelStyle(.uniformIcon)
    .floatingCaption("PopCapsule Button", alignment: .outerBottomTrailing, .size)
    .padding(.bottom, 40)
}


// MARK: Scale&Padding
#Preview("Scale&Padding", traits: .paddingSpacing, .headerFooter) {
    @Previewable @State var colorToggle = true

    VStack(items: AnimationPlayback.fixedCases, spacing: SpacingDefaults.padding) { playback in
        let capsuleStyle: AnyShapeStyle = .if(colorToggle, then: .orange, else: .gray)
        let buttonStyle = PopCapsuleButtonStyle(
            style: capsuleStyle,
            paddings: .init(horizontal: 8, vertical: 4),
            pressedPaddings: .all(4),
            pressedScale: .one,
            animations: playback
        )
        Button("Only Paddings", systemImage: "popcorn") { colorToggle.toggle() }
        .buttonStyle(buttonStyle)
        .labelStyle(.uniformIcon)
    }

    DashedDivider()

    VStack(items: AnimationPlayback.fixedCases, spacing: SpacingDefaults.padding) { playback in
        let capsuleStyle: AnyShapeStyle = .if(colorToggle, then: .orange, else: .gray)
        let buttonStyle = PopCapsuleButtonStyle(
            style: capsuleStyle,
            paddings: .init(horizontal: 8, vertical: 4),
            pressedPaddings: .all(4),
            pressedScale: 1.2,
            animations: playback
        )
        Button("Paddings + Scale", systemImage: "popcorn") { colorToggle.toggle() }
        .buttonStyle(buttonStyle)
        .labelStyle(.uniformIcon)
    }

    DashedDivider()

    VStack(items: AnimationPlayback.fixedCases, spacing: SpacingDefaults.padding) { playback in
        let capsuleStyle: AnyShapeStyle = .if(colorToggle, then: .orange, else: .gray)
        let buttonStyle = PopCapsuleButtonStyle(
            style: capsuleStyle,
            paddings: .init(horizontal: 8, vertical: 4),
            pressedScale: .one,
            animations: playback
        )
        Button("No Scale", systemImage: "popcorn") { colorToggle.toggle() }
        .buttonStyle(buttonStyle)
        .labelStyle(.uniformIcon)
    }
}
