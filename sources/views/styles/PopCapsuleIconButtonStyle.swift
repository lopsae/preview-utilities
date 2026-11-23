//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct PopCapsuleIconButtonStyle: ButtonStyle {

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
        self.paddings        = paddings
        self.pressedPaddings = pressedPaddings
        self.pressedScale    = pressedScale
        self.playback        = playback
    }

    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed

        let brightness: CGFloat = isPressed ? 0.15 : .zero
        let popPaddings: EdgeInsets = isPressed ? pressedPaddings : .zero
        let popScale: CGFloat = isPressed ? pressedScale : .one

        // FIXME: Reenable after incorporating updates of PopCapsuleIconLabelStyle
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
    .scaleEffect(2)
}
