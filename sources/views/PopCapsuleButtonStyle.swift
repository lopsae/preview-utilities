//
//  PreviewUtilities
//  Created by Maic Lopez Saenz.
//


import SwiftUI


/// Configures the round toggle button to animate its background.
struct PopCapsuleButtonStyle: ButtonStyle {

    static let defaultPressedScale: CGFloat = 1.5
    static let defaultPaddings: EdgeInsets = .all(4)

    let capsuleStyle: AnyShapeStyle
    let paddings: EdgeInsets
    let pressedPaddings: EdgeInsets?
    let pressedScale: CGFloat
    let playback: AnimationPlayback

    init(
        capsuleStyle: some ShapeStyle,
        paddings: EdgeInsets = defaultPaddings,
        pressedPaddings: EdgeInsets? = nil,
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

        let capsuleBrightness = isPressed ? 0.15 : .zero

        // When animations are disabled, scale is also disabled.
        // FIXME: Since pressed scale can be configured, always use scale. Scale can be disabled through the parameter.
        let targetScale: CGFloat = playback.isDisabled ? .one : pressedScale
        let scale = isPressed ? targetScale : .one

        let targetPressedPaddings = isPressed ? pressedPaddings ?? .all(.zero) : .all(.zero)
//        let animatedPaddings = isPressed ? targetPressedPaddings : paddings

        let colorAnimation: Animation? = .default.speed(2).playback(playback)
        // FIXME: Rename, this animates both scale and padding.
        let scaleAnimation: Animation? = .bouncy(duration: 0.25, extraBounce: 0.3).playback(playback)

        configuration.label
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
            .padding(targetPressedPaddings.negative)
            .animation(scaleAnimation, value: isPressed)
        }

//        .animation(colorAnimation) { content in
//            content.background {
//                Capsule()
//                .fill(capsuleStyle)
//                .brightness(capsuleBrightness)
//                // Padding animates along scale automatically, since isPressed changes value.
//                .padding(targetPressedPaddings.negative)
//            }
//        }


        .scaleEffect(scale, anchor: .center)
        .animation(scaleAnimation, value: isPressed)
    }

}


// MARK: - Previews


#Preview("Default", traits: .headerFooter) {
    @Previewable @State var colorToggle = true
    VStack.expandingWidth(alignment: .leading, spacing: SpacingDefaults.padding) {
        Button("Pop Capsule") {}
            .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: .tint))

        let capsuleStyle: AnyShapeStyle = .if(colorToggle, then: .orange, else: .teal)
        Button("Uniform Size") {
            colorToggle.toggle()
        } icon: {
            UniformSizeSymbol(systemName: "popcorn")
        }
        .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: capsuleStyle))

        Button("Uniform Size - Slow") {
            colorToggle.toggle()
        } icon: {
            UniformSizeSymbol(systemName: "popcorn")
        }
        .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: capsuleStyle, animations: .slow))

        Button("Uniform Size - None") {
            colorToggle.toggle()
        } icon: {
            UniformSizeSymbol(systemName: "popcorn")
        }
        .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: capsuleStyle))

        Button("Icon Only", action: {}, icon: UniformSizeSymbol(systemName: "party.popper"))
        .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: .purple))
        .labelStyle(.iconOnly)
    }
    .foregroundStyle(.background)

}


#Preview("Scale&Padding", traits: .headerFooter) {
    @Previewable @State var colorToggle = true
    VStack.expandingWidth(alignment: .center, spacing: SpacingDefaults.padding) {
        Button("Scale") {}

        let capsuleStyle: AnyShapeStyle = .if(colorToggle, then: .orange, else: .teal)

        Button("Small Scale") {
            colorToggle.toggle()
        } icon: {
            UniformSizeSymbol(systemName: "popcorn")
        }
        .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: .tint, pressedScale: 1.2))

        Button("No Scale") {
            colorToggle.toggle()
        } icon: {
            UniformSizeSymbol(systemName: "popcorn")
        }
        .buttonStyle(PopCapsuleButtonStyle(capsuleStyle: .tint, pressedScale: .one))

        Button("No Scale + Paddings") {
            colorToggle.toggle()
        } icon: {
            UniformSizeSymbol(systemName: "popcorn")
        }
        .buttonStyle(PopCapsuleButtonStyle(
            capsuleStyle: capsuleStyle,
            paddings: .init(horizontal: 8, vertical: 4),
            pressedPaddings: .all(4),
            pressedScale: .one,
            animations: .normal
        ))

        Button("No Scale + Paddings - Slow") {
            colorToggle.toggle()
        } icon: {
            UniformSizeSymbol(systemName: "popcorn")
        }
        .buttonStyle(PopCapsuleButtonStyle(
            capsuleStyle: capsuleStyle,
            paddings: .init(horizontal: 8, vertical: 4),
            pressedPaddings: .all(4),
            pressedScale: .one,
            animations: .slow
        ))
    }
    .foregroundStyle(.background)

}


// FIXME: Move to additions.
extension EdgeInsets {

    var negative: Self {
        .init(
            top:    -top,    leading:  -leading,
            bottom: -bottom, trailing: -trailing
        )
    }

}
