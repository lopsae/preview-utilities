//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Applies an animated scale effect and a padded capsule background.
///
/// Applies to the given content a capsule background padded outwardly and with a brightness effect.
/// Also applies a scale effect to the entire view.
///
/// The capsule fill style and brightness is animated when those properties change.
///
/// The padding and scale are animated with a fast bouncy animation when those properties change.
///
/// The `playback` parameter can be used to modify or disable the animations.
struct PopCapsule<Content>: View where Content: View {

    let style: AnyShapeStyle
    let brightness: CGFloat
    let paddings: EdgeInsets
    let scale: CGFloat
    let playback: AnimationPlayback

    let content: () -> Content

    init(
        style: some ShapeStyle,
        brightness: CGFloat,
        paddings: EdgeInsets,
        scale: CGFloat,
        animations playback: AnimationPlayback = .normal,
        @ContentBuilder content: @escaping () -> Content
    ) {
        self.style = AnyShapeStyle(style)
        self.brightness = brightness
        self.paddings   = paddings
        self.scale      = scale
        self.playback   = playback
        self.content    = content
    }

    var body: some View {
        // Style & brightness is animated automatically when it changes. There is no way to directly
        // track for `style` changes.
        let styleAnimation: Animation? = .default.speed(2).playback(playback)

        // Paddings and scale are animated when each changes.
        let paddingsAndScaleAnimation: Animation? = .bouncy(duration: 0.25, extraBounce: 0.3).playback(playback)

        content()
        .background {
            ClearRectangle()
            .animation(styleAnimation) { content in
                content.background {
                    Capsule()
                    .fill(style)
                    .brightness(brightness)
                }
            }
            .padding(paddings.negative)
            .animation(paddingsAndScaleAnimation, value: paddings)
        }
        .scaleEffect(scale, anchor: .center)
        .animation(paddingsAndScaleAnimation, value: scale)
    }

}


// MARK: - Previews


#Preview("Default", traits: .spacing(20)) {
    @Previewable @State var popToggle = false
    @Previewable @State var styleToggle = true

    let style: AnyShapeStyle = .if(styleToggle, then: .tint, else: .gray.secondary)
    let brightness: CGFloat =  popToggle ? 0.15 : .zero
    let paddings: EdgeInsets = popToggle ? .init(horizontal: 6, vertical: 4) : .zero
    let scale: CGFloat =       popToggle ? 1.2 : .one
    PopCapsule(
        style: style,
        brightness: brightness,
        paddings: .zero,
        scale: scale
    ) {
        Label("Pop Scale", systemImage: "popcorn")
        .padding(horizontal: 12, vertical: 7)
        .labelStyle(.uniformIcon)
        .foregroundStyle(.white)
    }

    PopCapsule(
        style: style,
        brightness: brightness,
        paddings: paddings,
        scale: .one
    ) {
        Label("Pop Padding", systemImage: "popcorn")
        .padding(horizontal: 12, vertical: 7)
        .labelStyle(.uniformIcon)
        .foregroundStyle(.white)
    }

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


// MARK: Properties
#Preview("Properties", traits: .spacing(20), .fixedHeaderFooter) {
    @Previewable @State var styleToggle = true
    @Previewable @State var brightnessToggle = false
    @Previewable @State var paddingsToggle = false
    @Previewable @State var scaleToggle = false

    let style: AnyShapeStyle = .if(styleToggle, then: .tint, else: .gray.secondary)
    let brightness: CGFloat = brightnessToggle ? 0.3 : .zero
    let paddings: EdgeInsets = paddingsToggle ? .all(8) : .zero
    let scale: CGFloat = scaleToggle ? 1.4 : .one

    VisibleSpacer()

    VStack(items: AnimationPlayback.fixedCases, spacing: SpacingDefaults.padding) { playback in
        PopCapsule(
            style: style,
            brightness: brightness,
            paddings: paddings,
            scale: scale,
            animations: playback
        ) {
            Label("Pop Padding", systemImage: "popcorn")
            .padding(horizontal: 12, vertical: 7)
            .labelStyle(.uniformIcon)
            .foregroundStyle(.white)
        }
        .expandingWidthFrame(height: 120, alignment: .center)
        .background {
            Rectangle().strokeBorder(.quinary, style: .dividerDash(width: 2))
        }
    }

    VStack {
        HStack {
            Toggle("Style", isOn: $styleToggle)
            Toggle("Bright", isOn: $brightnessToggle)
            Toggle("Pad", isOn: $paddingsToggle)
            Toggle("Scale", isOn: $scaleToggle)
        }
        HStack {

        }
    }
    .toggleStyle(.button)
    .buttonStyle(.bordered)
    .tint(.orange)

    Text("""
        style:  \(styleToggle.description)
        bright: \(brightnessToggle.description)
        pad:    \(paddingsToggle.description)
        scale:  \(scaleToggle.description)
        """)
    .font(.caption.monospaced())
    .fixedSize()
}
