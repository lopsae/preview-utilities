//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


// FIXME: Document.
// Label with the icon wrapped in PopCapsule+UniformSizeSymbol.
struct PopCapsuleIconLabelStyle: LabelStyle {

    static let defaultPaddings: EdgeInsets = .all(4)
    static let defaultPopPaddings: EdgeInsets = .zero
    static let defaultPopScale: CGFloat = 1.4

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
        popPaddings: EdgeInsets = defaultPopPaddings,
        popScale: CGFloat = defaultPopScale,
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
                UniformSizeSymbol {
                    configuration.icon
                }
                .foregroundStyle(.white)
                .padding(paddings)
            }
        }
    }

}


// MARK: - Previews


#Preview("Default", traits: .spacing(20)) {
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
    Label("Pop Scale", systemImage: "popcorn")
    .labelStyle(scaleLabelStyle)

    let paddingLabelStyle = PopCapsuleIconLabelStyle(
        style: style,
        brightness: brightness,
        paddings: .all(4),
        popPaddings: paddings,
        popScale: .one
    )
    Label("Pop Scale", systemImage: "popcorn")
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
