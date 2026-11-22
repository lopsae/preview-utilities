//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


struct PopCapsuleIconLabelStyle: LabelStyle {

    // FIXME: Rename to pop terms.
    static let defaultPressedScale: CGFloat = 1.4
    static let defaultPaddings: EdgeInsets = .all(4)
    static let defaultPressedPaddings: EdgeInsets = .zero

    let isPopping: Bool
    let capsuleStyle: AnyShapeStyle
    let paddings: EdgeInsets
    let pressedPaddings: EdgeInsets
    let pressedScale: CGFloat
    let playback: AnimationPlayback

    init(
        isPopping: Bool,
        capsuleStyle: some ShapeStyle,
        paddings: EdgeInsets = defaultPaddings,
        pressedPaddings: EdgeInsets = defaultPressedPaddings,
        pressedScale: CGFloat = defaultPressedScale,
        animations playback: AnimationPlayback = .normal
    ) {
        self.isPopping = isPopping
        self.capsuleStyle = AnyShapeStyle(capsuleStyle)
        self.paddings = paddings
        self.pressedPaddings = pressedPaddings
        self.pressedScale = pressedScale
        self.playback = playback
    }

    func makeBody(configuration: Configuration) -> some View {
        Label {
            configuration.title
        } icon: {
            PopCapsuleBackup(
                pop: isPopping,
                capsuleStyle: capsuleStyle,
                paddings: paddings,
                popPaddings: pressedPaddings,
                popScale: pressedScale,
                animations: playback
            ) {
                UniformSizeSymbol {
                    configuration.icon
                }
                .foregroundStyle(.white)
            }
        }
    }

}


#Preview("PopIconLabel") {
    @Previewable @State var pop = false
    @Previewable @State var style = true

    let popStyle: AnyShapeStyle = .if(style, then: .tint, else: .gray.secondary)
    Label("Pop Label", systemImage: "popcorn")
    .labelStyle(PopCapsuleIconLabelStyle(isPopping: pop, capsuleStyle: popStyle))

    Button("Pop") {
        if pop { style.toggle() }
        pop.toggle()
    }
    Text("pop: \(pop.description)\nstyle: \(style.description)")
    .font(.caption.monospaced())
}
