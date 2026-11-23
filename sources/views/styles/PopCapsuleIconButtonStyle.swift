//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct PopCapsuleIconButtonStyle: ButtonStyle {

    // FIXME: Rename to pop terms.
    static let defaultPressedScale: CGFloat = 1.4
    static let defaultPaddings: EdgeInsets = .all(4)
    static let defaultPressedPaddings: EdgeInsets = .zero

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


// FIXME: Preview with just scale, and just padding.
#Preview("PopIconButton") {
    @Previewable @State var styleToggle = true

    let style: AnyShapeStyle = .if(styleToggle, then: .tint, else: .gray.secondary)
    Button("Pop Button", systemImage: "popcorn") { styleToggle.toggle() }
    .buttonStyle(PopCapsuleIconButtonStyle(style: style))

    Button("Pop Button", systemImage: "popcorn") { styleToggle.toggle() }
    .buttonStyle(PopCapsuleIconButtonStyle(style: style))
    .labelStyle(.iconOnly)
}
