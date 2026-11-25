//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// A label style that applies an animated capsule background and scale effect to the label icon.
///
/// The style wraps the label icon in a configured ``PopCapsule``. Changes to the `style`,
/// `brightness`, `popPaddings`, and `popScale` properties are animated.
///
/// Use the `playback` property to modify or disable animations.
///
/// ### Style Composition
///
/// This style internally builds a `Label` view and is composable with other label styles. Stack it
/// with other label styles compose its effects.
///
/// For example, compose with ``SwiftUI/LabelStyle/uniformIcon`` for a perfectly circular background
/// behind any symbol icon.
///
/// Use the `playback` property to modify or disable animations.
struct PopCapsuleIconLabelStyle: LabelStyle {

    // The default paddings are set to reproduce the size of a toggle, when used with a uniform
    // symbol size.
    static let defaultPaddings: EdgeInsets = .all(4)

    let style: AnyShapeStyle
    let brightness: CGFloat
    let paddings: EdgeInsets
    let popPaddings: EdgeInsets
    let popScale: CGFloat
    let playback: AnimationPlayback

    init(
        style: some ShapeStyle,
        brightness: CGFloat = .zero,
        paddings: EdgeInsets = defaultPaddings,
        popPaddings: EdgeInsets = .zero,
        popScale: CGFloat = .one,
        animations playback: AnimationPlayback = .normal
    ) {
        self.style = AnyShapeStyle(style)
        self.brightness  = brightness
        self.paddings    = paddings
        self.popPaddings = popPaddings
        self.popScale    = popScale
        self.playback    = playback
    }

    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            PopCapsule(
                style: style,
                brightness: brightness,
                paddings: popPaddings,
                scale: popScale,
                animations: playback
            ) {
                configuration.icon
                .foregroundStyle(.white)
                .padding(paddings)
            }
        }
    }

}


// MARK: - Previews


#Preview("Default", traits: .spacing(20)) {
    Label("Default", systemImage: "popcorn")
    .labelStyle(PopCapsuleIconLabelStyle(style: .orange))

    Label("Uniform", systemImage: "popcorn")
    .labelStyle(.uniformIcon)
    .labelStyle(PopCapsuleIconLabelStyle(style: .red))

    Label("Icon Only", systemImage: "popcorn")
    .labelStyle(.uniformIcon)
    .labelStyle(PopCapsuleIconLabelStyle(style: .brown))
    .labelStyle(.iconOnly)
}


// MARK: Pop
#Preview("Pop", traits: .spacing(20)) {
    @Previewable @State var popToggle = false
    @Previewable @State var styleToggle = true

    let style: AnyShapeStyle = .if(styleToggle, then: .tint, else: .gray.secondary)
    let brightness: CGFloat =  popToggle ? 0.15 : .zero
    let paddings: EdgeInsets = popToggle ? .all(6) : .zero
    let scale: CGFloat =       popToggle ? 1.4 : .one

    let scaleLabelStyle = PopCapsuleIconLabelStyle(
        style: style,
        brightness: brightness,
        paddings: .all(4),
        popPaddings: .zero,
        popScale: scale
    )

    Label("Pop Scale", systemImage: "guidepoint.horizontal")
    .labelStyle(scaleLabelStyle)

    Label("Pop Scale", systemImage: "popcorn")
    .labelStyle(.uniformIcon)
    .labelStyle(scaleLabelStyle)


    let paddingLabelStyle = PopCapsuleIconLabelStyle(
        style: style,
        brightness: brightness,
        paddings: .all(4),
        popPaddings: paddings,
        popScale: .one
    )
    Label("Pop Scale", systemImage: "popcorn")
    .labelStyle(.uniformIcon)
    .labelStyle(paddingLabelStyle)

    Button("Pop") {
        if popToggle { styleToggle.toggle() }
        popToggle.toggle()
    }.buttonStyle(.bordered)

    Text("""
        pop:   \(popToggle.description)
        style: \(styleToggle.description)
        """
    ).font(.caption.monospaced())
}
