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

        // FIXME: Reenable after incorporating updates of PopCapsuleIconLabelStyle
//        let labelStyle = PopCapsuleIconLabelStyle(
//            isPopping: isPressed,
//            capsuleStyle: capsuleStyle
//        )
        configuration.label
//        .labelStyle(labelStyle)
    }

}


#Preview("PopIconButton") {
    @Previewable @State var style = true

    let popStyle: AnyShapeStyle = .if(style, then: .tint, else: .gray.secondary)
    Button("Pop Button", systemImage: "popcorn") { style.toggle() }
    .buttonStyle(PopCapsuleIconButtonStyle(capsuleStyle: popStyle))

    Button("Pop Button", systemImage: "popcorn") { style.toggle() }
    .buttonStyle(PopCapsuleIconButtonStyle(capsuleStyle: popStyle))
    .labelStyle(.iconOnly)
}
